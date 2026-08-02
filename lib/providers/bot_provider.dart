// Default location: lib/providers/bot_provider.dart
// Provider to manage bot configurations

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bot.dart';
import '../settingsvariables/default_settings_variables.dart';
import '../languages/languages.dart';

class BotProvider extends ChangeNotifier {
  List<Bot> _bots = [];
  bool _isLoading = false;
  String? _error;

  List<Bot> get bots => _bots;
  bool get isLoading => _isLoading;
  String? get error => _error;

  static const String _botsKey = 'saved_bots';

  BotProvider() {
    _loadBots();
  }

  Future<void> initializeBots() async {
    await _loadBots();
  }

  // Load saved bots from SharedPreferences or use default bots
  Future<void> _loadBots() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final botsJson = prefs.getStringList(_botsKey);

      if (botsJson != null && botsJson.isNotEmpty) {
        _bots = botsJson.map((jsonStr) {
          final Map<String, dynamic> json = jsonDecode(jsonStr);
          return Bot.fromJson(json);
        }).toList();
      } else {
        _bots = List.from(defaultBots);
        await _saveBotsToPrefs();
      }
    } catch (e) {
      _error = '${Languages.msgErrorLoadingBots}: $e';
      _bots = List.from(defaultBots);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save current bots list to SharedPreferences
  Future<void> _saveBotsToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final botsJson = _bots.map((bot) => jsonEncode(bot.toJson())).toList();
      await prefs.setStringList(_botsKey, botsJson);
    } catch (e) {
      _error = '${Languages.msgErrorSavingBots}: $e';
      notifyListeners();
    }
  }

  // Add a new bot
  Future<void> addBot(Bot bot) async {
    _bots.add(bot);
    await _saveBotsToPrefs();
    notifyListeners();
  }

  // Update an existing bot
  Future<void> updateBot(Bot updatedBot) async {
    final index = _bots.indexWhere((b) => b.id == updatedBot.id);
    if (index != -1) {
      _bots[index] = updatedBot;
      await _saveBotsToPrefs();
      notifyListeners();
    }
  }

  // Apply pricing updates from API
  Future<void> updateBotPrices(List<Bot> updatedBotsWithPricing) async {
    final priceMap = {
      for (var b in updatedBotsWithPricing)
        b.model: {'prompt': b.promptPrice, 'completion': b.completionPrice}
    };

    _bots = _bots.map((bot) {
      if (priceMap.containsKey(bot.model)) {
        return bot.copyWith(
          promptPrice: priceMap[bot.model]?['prompt'],
          completionPrice: priceMap[bot.model]?['completion'],
        );
      }
      return bot;
    }).toList();

    await _saveBotsToPrefs();
    notifyListeners();
  }

  // Delete a bot
  Future<void> deleteBot(String id) async {
    _bots.removeWhere((b) => b.id == id);
    await _saveBotsToPrefs();
    notifyListeners();
  }

  // Get bot by ID
  Bot? getBotById(String id) {
    try {
      return _bots.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  // Get bot by Model
  Bot? getBotByModel(String model) {
    try {
      return _bots.firstWhere((b) => b.model == model);
    } catch (_) {
      return null;
    }
  }
}
