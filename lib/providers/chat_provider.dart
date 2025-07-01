// Default location: lib/providers/chat_provider.dart
// Provider to manage chat state

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/bot.dart';
import '../services/openrouter_service.dart';
import '../providers/settings_provider.dart';

class ChatProvider extends ChangeNotifier {
  final OpenRouterService _openRouterService;
  final SettingsProvider _settingsProvider;
  List<Message> _messages = [];
  final Map<String, List<Message>> _sessionMessages = {};
  List<String> _sessionIds = [];
  String _currentSessionId = '';
  Bot? _selectedBot;
  bool _isLoading = false;
  String? _error;
  String? _preparedMessage;
  int _chatCounter = 0;

  // Getters
  List<Message> get messages => _messages;
  Map<String, List<Message>> get sessions => _sessionMessages;
  List<String> get sessionIds => _sessionIds;
  String get currentSessionId => _currentSessionId;
  Bot? get selectedBot => _selectedBot;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMessages => _messages.isNotEmpty;
  bool get hasSessions => _sessionIds.isNotEmpty;
  String? get preparedMessage => _preparedMessage;

  // Constructor
  ChatProvider(this._openRouterService, this._settingsProvider) {
    _loadSessions();
    // Initialize API service when app starts
    if (_settingsProvider.hasApiKey) {
      _openRouterService.initialize(_settingsProvider.apiKey);
    }
  }

  // Check internet connection and verify API service is working
  Future<bool> isApiServiceAvailable() async {
    // Cannot access API service if no API key
    if (!_settingsProvider.hasApiKey) {
      return false;
    }
    
    // Initialize service if not already initialized
    if (!_openRouterService.isInitialized) {
      _openRouterService.initialize(_settingsProvider.apiKey);
    }
    
    // Test API connection
    return await _openRouterService.testApiConnection();
  }

  // Load sessions from storage
  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load session IDs
      final sessionsData = prefs.getString('chat_sessions');
      if (sessionsData != null) {
        final Map<String, dynamic> data = jsonDecode(sessionsData);
        _sessionIds = List<String>.from(data['sessionIds'] ?? []);
      }
      
      // Load current session ID
      _currentSessionId = prefs.getString('current_session_id') ?? '';
      
      // Load individual session messages
      for (var id in _sessionIds) {
        final messagesJson = prefs.getString('session_$id');
        if (messagesJson != null) {
          final List<dynamic> messagesData = jsonDecode(messagesJson);
          _sessionMessages[id] = messagesData
              .map((msg) => Message.fromJson(msg))
              .toList();
        }
      }
      
      // Set current messages
      if (_currentSessionId.isNotEmpty) {
        _messages = _sessionMessages[_currentSessionId] ?? [];
      }
      
      // Update chat counter based on number of sessions
      _chatCounter = _sessionIds.length;
      _openRouterService.setChatCounter(_chatCounter);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading sessions: $e');
    }
  }
  
  // Save sessions to storage
  Future<void> _saveSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save session IDs
      final Map<String, dynamic> sessionsData = {
        'sessionIds': _sessionIds,
      };
      await prefs.setString('chat_sessions', jsonEncode(sessionsData));
      
      // Save current session ID
      await prefs.setString('current_session_id', _currentSessionId);
      
      // Save individual session messages
      for (var id in _sessionIds) {
        final messages = _sessionMessages[id] ?? [];
        final messagesJson = jsonEncode(
          messages.map((msg) => msg.toFullJson()).toList()
        );
        await prefs.setString('session_$id', messagesJson);
      }
    } catch (e) {
      debugPrint('Error saving sessions: $e');
    }
  }
  
  // Create a new session
  void createNewSession() {
    _createNewSession();
    notifyListeners();
  }
  
  // Helper method to create new session
  void _createNewSession() {
    const uuid = Uuid();
    final sessionId = uuid.v4();
    _sessionIds.add(sessionId);
    _sessionMessages[sessionId] = [];
    _currentSessionId = sessionId;
    _messages = [];
    _chatCounter++;
    _openRouterService.setChatCounter(_chatCounter);
    _saveSessions();
  }
  
  // Switch to a different session
  void switchSession(String sessionId) {
    if (_sessionIds.contains(sessionId)) {
      _currentSessionId = sessionId;
      _messages = _sessionMessages[sessionId] ?? [];
      _saveSessions();
      notifyListeners();
    }
  }
  
  // Delete a session
  void deleteSession(String sessionId) async {
    if (_sessionIds.contains(sessionId)) {
      _sessionIds.remove(sessionId);
      _sessionMessages.remove(sessionId);
      
      // If current session was deleted, switch to another or create new one
      if (_currentSessionId == sessionId) {
        if (_sessionIds.isNotEmpty) {
          _currentSessionId = _sessionIds.first;
          _messages = _sessionMessages[_currentSessionId] ?? [];
        } else {
          _createNewSession();
        }
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_$sessionId');
      _saveSessions();
      notifyListeners();
    }
  }

  // Set the selected bot
  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }

  // Add a user message
  Future<void> sendMessage(String content, {File? imageFile}) async {
    if (content.isEmpty && imageFile == null) return;
    if (_selectedBot == null) {
      _error = 'Please select a bot first';
      notifyListeners();
      return;
    }

    // Clear any previous errors
    _error = null;

    // Create a unique ID for the message
    const uuid = Uuid();
    String messageId = uuid.v4();
    String? imageUrl;

    try {
      // Handle image upload if provided
      if (imageFile != null) {
        _isLoading = true;
        notifyListeners();
        
        try {
          // Upload image and get base64 data URL
          imageUrl = await _openRouterService.uploadImage(imageFile);
          debugPrint('Image uploaded successfully: ${imageUrl?.substring(0, 50)}...');
        } catch (uploadError) {
          _error = uploadError.toString();
          if (_error!.startsWith('Exception: ')) {
            _error = _error!.substring('Exception: '.length);
          }
          _isLoading = false;
          notifyListeners();
          return;
        }
        
        if (imageUrl == null) {
          _error = 'Görsel yükleme başarısız oldu';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Trim mesajı ve boş ise basit bir boşluk karakteri ekle
      final trimmedContent = content.trim();
      
      // Create and add user message - make sure content is not null even if empty
      final userMessage = Message(
        id: messageId,
        role: MessageRole.user,
        content: trimmedContent.isEmpty ? " " : trimmedContent,
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
        sessionId: _currentSessionId,
      );
      
      // İşlemi deferred yaparak UI thread'inin bloke olmasını önleyebiliriz
      Future.microtask(() {
        _messages.add(userMessage);
        _sessionMessages[_currentSessionId] = _messages;
        _saveSessions();
        notifyListeners(); // İlk notifyListeners burada
      }).then((_) {
        // Generate AI response
        return _generateResponse();
      });
    } catch (e) {
      debugPrint('Error sending message: $e');
      _error = 'Mesaj gönderilirken bir hata oluştu';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate AI response based on conversation history
  Future<void> _generateResponse() async {
    if (_selectedBot == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      const uuid = Uuid();
      final responseId = uuid.v4();
      
      // Create a temporary "thinking" message
      final tempMessage = Message(
        id: responseId,
        role: MessageRole.assistant,
        content: "Düşünüyor...",
        timestamp: DateTime.now(),
        sessionId: _currentSessionId,
      );
      
      _messages.add(tempMessage);
      _sessionMessages[_currentSessionId] = _messages;
      notifyListeners();
      
      // Get response from OpenAI
      final response = await _openRouterService.generateChatResponse(
        messages: _messages,
        bot: _selectedBot!,
        systemPrompt: _settingsProvider.systemPrompt,
        temperature: _settingsProvider.temperature,
        maxTokens: _settingsProvider.maxTokens,
        sessionId: _currentSessionId,
      );
      
      // Remove the temporary message before adding the real response
      _messages.removeLast();
      
      if (response != null) {
        // Add the actual response
        _messages.add(response);
        _sessionMessages[_currentSessionId] = _messages;
        await _saveSessions();
      } else {
        _error = 'Failed to generate response';
      }
    } catch (e) {
      _error = 'Error generating response: $e';
      debugPrint('Error generating response: $e');
    } finally {
      _isLoading = false;
      // notifyListeners bazen render sırasında çağrılınca soruna neden olabilir
      // Bu yüzden karar ağacından sonraya atalım
      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  // Clear chat history for current session
  void clearChat() {
    _messages = [];
    _sessionMessages[_currentSessionId] = [];
    _error = null;
    _saveSessions();
    notifyListeners();
  }

  // Belirli bir mesajı sil
  // Verilen ID'ye sahip mesajı sohbetten kaldırır
  void deleteMessage(String messageId) {
    _messages.removeWhere((message) => message.id == messageId);
    _sessionMessages[_currentSessionId] = _messages;
    _saveSessions();
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Prepare a message to be edited before sending
  // This will be used for suggestion chips in the empty chat state
  void prepareMessage(String content) {
    // We'll use this method to fill the input field with the content
    // without actually sending the message
    // The MessageInput widget will need to listen for this value
    
    // Notify listeners that we have a prepared message
    _preparedMessage = content;
    notifyListeners();
    
    // Reset the prepared message after a short delay
    // This ensures that the MessageInput widget has time to pick it up
    Future.delayed(const Duration(milliseconds: 300), () {
      _preparedMessage = null;
      notifyListeners();
    });
  }
} 