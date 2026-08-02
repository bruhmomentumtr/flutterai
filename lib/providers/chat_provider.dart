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
import '../languages/languages.dart';

class ChatProvider extends ChangeNotifier {
  final OpenRouterService _openRouterService;
  final SettingsProvider _settingsProvider;
  List<Message> _messages = [];
  final Map<String, List<Message>> _sessionMessages = {};
  String _currentSessionId = '';
  Bot? _selectedBot;
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  Bot? get selectedBot => _selectedBot;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentSessionId => _currentSessionId;
  Map<String, List<Message>> get sessionMessages => _sessionMessages;

  /// Calculate total cost spent in the active chat session
  double get currentSessionTotalCost {
    return _messages.fold(0.0, (sum, msg) => sum + (msg.cost ?? 0.0));
  }

  /// Calculate total tokens used in the active chat session
  int get currentSessionTotalTokens {
    return _messages.fold(0, (sum, msg) => sum + msg.totalTokens);
  }

  /// Formatted current session cost (e.g. "$0.0125")
  String get formattedSessionCost {
    final cost = currentSessionTotalCost;
    if (cost == 0) return '';
    if (cost < 0.0001) return '<\$0.0001';
    return '\$${cost.toStringAsFixed(4)}';
  }

  static const String _sessionsKey = 'chat_sessions_list';
  static const String _sessionPrefix = 'chat_session_';

  ChatProvider(this._openRouterService, this._settingsProvider) {
    _initSession();
  }

  void selectBot(Bot bot) {
    _selectedBot = bot;
    notifyListeners();
  }

  void _initSession() {
    _currentSessionId = const Uuid().v4();
    _messages = [];
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionIds = prefs.getStringList(_sessionsKey) ?? [];

      for (final id in sessionIds) {
        final messagesJson = prefs.getStringList('$_sessionPrefix$id');
        if (messagesJson != null) {
          _sessionMessages[id] = messagesJson.map((str) {
            return Message.fromJson(jsonDecode(str));
          }).toList();
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading chat sessions: $e');
    }
  }

  Future<void> _saveCurrentSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionIds = prefs.getStringList(_sessionsKey) ?? [];

      if (!sessionIds.contains(_currentSessionId)) {
        sessionIds.insert(0, _currentSessionId);
        await prefs.setStringList(_sessionsKey, sessionIds);
      }

      final messagesJson =
          _messages.map((msg) => jsonEncode(msg.toJson())).toList();
      await prefs.setStringList(
          '$_sessionPrefix$_currentSessionId', messagesJson);

      _sessionMessages[_currentSessionId] = List.from(_messages);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving chat session: $e');
    }
  }

  Future<void> sendMessage(String content, {File? imageFile}) async {
    if (content.isEmpty && imageFile == null) return;
    if (_selectedBot == null) {
      _error = Languages.msgPleaseSelectBot;
      notifyListeners();
      return;
    }

    _error = null;
    _isLoading = true;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
      imageUrl: imageFile?.path,
    );

    _messages.add(userMessage);
    notifyListeners();

    try {
      final assistantMessage = await _openRouterService.sendMessage(
        prompt: content,
        bot: _selectedBot!,
        history: _messages.sublist(0, _messages.length - 1),
        imageUrl: imageFile?.path,
        temperature: _settingsProvider.temperature,
        maxTokens: _settingsProvider.maxTokens,
      );

      _messages.add(assistantMessage);
      await _saveCurrentSession();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startNewSession() {
    _currentSessionId = const Uuid().v4();
    _messages = [];
    notifyListeners();
  }

  void loadSession(String sessionId) {
    if (_sessionMessages.containsKey(sessionId)) {
      _currentSessionId = sessionId;
      _messages = List.from(_sessionMessages[sessionId]!);
      notifyListeners();
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionIds = prefs.getStringList(_sessionsKey) ?? [];
      sessionIds.remove(sessionId);
      await prefs.setStringList(_sessionsKey, sessionIds);
      await prefs.remove('$_sessionPrefix$sessionId');

      _sessionMessages.remove(sessionId);

      if (_currentSessionId == sessionId) {
        startNewSession();
      } else {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting chat session: $e');
    }
  }
}
