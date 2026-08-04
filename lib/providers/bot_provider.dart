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
    await _syncWithApiBots(updatedBotsWithPricing);
  }

  /// Sync the local bot list with the latest data fetched from the API.
  ///
  /// - For every existing bot whose `model` is also present in [apiBots],
  ///   pricing is refreshed while user customizations (name, systemPrompt,
  ///   temperature, maxTokens, iconName) are preserved.
  /// - For every bot in [apiBots] that does not yet exist locally (matched
  ///   by `model`), a new `Bot` is appended so the user can pick any model
  ///   OpenRouter exposes.
  Future<void> syncWithApiBots(List<Bot> apiBots) async {
    await _syncWithApiBots(apiBots);
  }

  Future<void> _syncWithApiBots(List<Bot> apiBots) async {
    if (apiBots.isEmpty) return;

    final existingModels = _bots.map((b) => b.model).toSet();

    final priceMap = <String, Map<String, double?>>{
      for (var b in apiBots)
        b.model: {'prompt': b.promptPrice, 'completion': b.completionPrice},
    };

    // 1) Refresh pricing for bots the user already has.
    _bots = _bots.map((bot) {
      final pricing = priceMap[bot.model];
      if (pricing == null) return bot;
      return bot.copyWith(
        promptPrice: pricing['prompt'],
        completionPrice: pricing['completion'],
      );
    }).toList();

    // 2) Add new models returned by the API (without touching user's
    //    customized entries above).
    for (final apiBot in apiBots) {
      if (existingModels.contains(apiBot.model)) continue;

      _bots.add(Bot(
        id: apiBot.id.isNotEmpty ? apiBot.id : const Uuid().v4(),
        name: apiBot.name.isNotEmpty ? apiBot.name : apiBot.model,
        model: apiBot.model,
        description: apiBot.description,
        promptPrice: apiBot.promptPrice,
        completionPrice: apiBot.completionPrice,
        iconName: 'smart_toy',
      ));
    }

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
