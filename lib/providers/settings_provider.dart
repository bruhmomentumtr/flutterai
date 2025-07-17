// Default location: lib/providers/settings_provider.dart
// Provider to manage application settings

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settingsvariables/default_settings_variables.dart';
import '../languages/languages.dart';

// SharedPreferences keys
const String _themeModeKey = 'themeMode';
const String _apiKeyKey = 'apiKey';
const String _showRawFormatKey = 'showRawFormat';
const String _temperatureKey = 'temperature';
const String _maxTokensKey = 'maxTokens';
const String _systemPromptKey = 'systemPrompt';

class SettingsProvider extends ChangeNotifier {
  // Theme mode
  ThemeMode _themeMode = ThemeMode.system;
  // API key
  String _apiKey = '';
  // Show raw format (disable markdown/LaTeX rendering)
  bool _showRawFormat = false;
  
  // Common chat settings
  double _temperature = defaultTemperature;
  int _maxTokens = defaultMaxTokens;
  String _systemPrompt = defaultSystemPrompt;
  
  // Getters
  ThemeMode get themeMode => _themeMode;
  String get apiKey => _apiKey;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get hasApiKey => _apiKey.isNotEmpty;
  bool get showRawFormat => _showRawFormat;
  
  // Chat settings getters
  double get temperature => _temperature;
  int get maxTokens => _maxTokens;
  String get systemPrompt => _systemPrompt;

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeString = prefs.getString(_themeModeKey) ?? 'system';
      _themeMode = _getThemeModeFromString(themeModeString);
      
      // Load API key
      _apiKey = prefs.getString(_apiKeyKey) ?? '';
      
      // Load show raw format option
      _showRawFormat = prefs.getBool(_showRawFormatKey) ?? false;
      
      // Load chat settings
      _temperature = prefs.getDouble(_temperatureKey) ?? defaultTemperature;
      _maxTokens = prefs.getInt(_maxTokensKey) ?? defaultMaxTokens;
      _systemPrompt = prefs.getString(_systemPromptKey) ?? defaultSystemPrompt;
      
      notifyListeners();
    } catch (e) {
      debugPrint('${Languages.msgErrorLoadingSettings} $e');
    }
  }

  // Save all settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save theme mode
      await prefs.setString(_themeModeKey, _themeMode.toString().split('.').last);
      
      // Save API key
      await prefs.setString(_apiKeyKey, _apiKey);
      
      // Save show raw format option
      await prefs.setBool(_showRawFormatKey, _showRawFormat);
      
      // Save chat settings
      await prefs.setDouble(_temperatureKey, _temperature);
      await prefs.setInt(_maxTokensKey, _maxTokens);
      await prefs.setString(_systemPromptKey, _systemPrompt);
    } catch (e) {
      debugPrint('${Languages.msgErrorSavingSettings} $e');
    }
  }

  // Set API key
  Future<void> setApiKey(String apiKey) async {
    _apiKey = apiKey;
    await _saveSettings();
    notifyListeners();
  }
  
  // Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveSettings();
    notifyListeners();
  }
  
  // Set show raw format option
  Future<void> setShowRawFormat(bool showRaw) async {
    _showRawFormat = showRaw;
    await _saveSettings();
    notifyListeners();
  }
  
  // Set temperature
  Future<void> setTemperature(double value) async {
    _temperature = value;
    await _saveSettings();
    notifyListeners();
  }
  
  // Set maximum tokens
  Future<void> setMaxTokens(int value) async {
    _maxTokens = value;
    await _saveSettings();
    notifyListeners();
  }
  
  // Set system prompt
  Future<void> setSystemPrompt(String value) async {
    _systemPrompt = value;
    await _saveSettings();
    notifyListeners();
  }
  
  // Helper to convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
} 