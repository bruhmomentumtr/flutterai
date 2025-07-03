// Default location: lib/providers/bot_provider.dart
// Provider to manage bot configurations

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/bot.dart';

class BotProvider extends ChangeNotifier {
  List<Bot> _bots = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Bot> get bots => _bots;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasBots => _bots.isNotEmpty;

  // Initialize with default bots
  Future<void> initializeBots() async {
    _isLoading = true;
    notifyListeners();

    try {
      // First, try to load bots from SharedPreferences
      await _loadBotsFromPrefs();
      
      // If no bots found, create defaults
      if (_bots.isEmpty) {
        _createDefaultBots();
      }
    } catch (e) {
      _error = 'Error initializing bots: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load bots from SharedPreferences
  Future<void> _loadBotsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final botsJson = prefs.getString('bots');
    
    if (botsJson != null) {
      final List<dynamic> decodedList = jsonDecode(botsJson);
      _bots = decodedList.map((item) => Bot.fromJson(item)).toList();
    }
  }

  // Save bots to SharedPreferences
  Future<void> _saveBots() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final botsJson = jsonEncode(_bots.map((bot) => bot.toJson()).toList());
      await prefs.setString('bots', botsJson);
    } catch (e) {
      _error = 'Error saving bots: $e';
      notifyListeners();
    }
  }

  // Create default bot configurations
  void _createDefaultBots() {
    _bots = [
      Bot(
        id: const Uuid().v4(),
        name: 'Llama 3.2 11b vision free',
        model: 'meta-llama/llama-3.2-11b-vision-instruct:free',
        iconName: 'smart_toy',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'gemini 2.5 flash',
        model: 'google/gemini-2.5-flash',
        iconName: 'chat',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'GPT-4.1 nano',
        model: 'openai/gpt-4.1-nano',
        iconName: 'edit',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'Qwen 3.0 14b',
        model: 'qwen/qwen3-14b',
        iconName: 'chat',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'gemma 3 27b',
        model: 'google/gemma-3-27b-it',
        iconName: 'chat',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'openrouter auto',
        model: 'openrouter/auto',
        iconName: 'chat',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'ministral 8b',
        model: 'mistralai/ministral-8b',
        iconName: 'chat',
      ),
      Bot(
        id: const Uuid().v4(),
        name: 'claude sonnet 4',
        model: 'anthropic/claude-sonnet-4',
        iconName: 'smart_toy',
      ),
    ];
    
    _saveBots();
  }

  // Add a new bot
  Future<void> addBot(Bot bot) async {
    _bots.add(bot);
    await _saveBots();
    notifyListeners();
  }

  // Update an existing bot
  Future<void> updateBot(Bot updatedBot) async {
    final index = _bots.indexWhere((bot) => bot.id == updatedBot.id);
    
    if (index != -1) {
      _bots[index] = updatedBot;
      await _saveBots();
      notifyListeners();
    } else {
      _error = 'Bot not found';
      notifyListeners();
    }
  }

  // Delete a bot
  Future<void> deleteBot(String botId) async {
    _bots.removeWhere((bot) => bot.id == botId);
    await _saveBots();
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 