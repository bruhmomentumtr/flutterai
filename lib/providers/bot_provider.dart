// Default location: lib/providers/bot_provider.dart
// Provider to manage bot configurations

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/bot.dart';
import '../settingsvariables/default_settings_variables.dart';
import '../languages/languages.dart';

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
      _error = msgErrorInitializingBots + e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load bots from SharedPreferences
  Future<void> _loadBotsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final botsJson = prefs.getString(msgBotName);
    
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
      await prefs.setString(msgBotName, botsJson);
    } catch (e) {
      _error = msgErrorSavingBots + e.toString();
      notifyListeners();
    }
  }

  // Create default bot configurations
  void _createDefaultBots() {
    // Use the defaultBots list from default_settings_variables.dart
    _bots = defaultBots;
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
      _error = msgBotNotFound;
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
