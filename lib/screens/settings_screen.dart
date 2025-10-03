// Default location: lib/screens/settings_screen.dart
// Settings screen for managing application settings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../languages/languages.dart';
import '../settingsvariables/default_settings_variables.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _apiKeyController;
  late TextEditingController _temperatureController;
  late TextEditingController _maxTokensController;
  late TextEditingController _systemPromptController;
  bool _showRawFormat = false;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _apiKeyController = TextEditingController(text: settings.apiKey);
    _temperatureController =
        TextEditingController(text: settings.temperature.toString());
    _maxTokensController =
        TextEditingController(text: settings.maxTokens.toString());
    _systemPromptController =
        TextEditingController(text: settings.systemPrompt);
    _showRawFormat = settings.showRawFormat;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _temperatureController.dispose();
    _maxTokensController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final settings = context.read<SettingsProvider>();
      settings.setApiKey(_apiKeyController.text);
      settings.setShowRawFormat(_showRawFormat);
      settings.setTemperature(double.parse(_temperatureController.text));
      settings.setMaxTokens(int.parse(_maxTokensController.text));
      settings.setSystemPrompt(_systemPromptController.text);
      Navigator.pop(context);
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Languages.textReset),
        content: const Text(Languages.textResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(Languages.textNo),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(Languages.textYes),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final settings = context.read<SettingsProvider>();
      settings.setApiKey('');
      settings.setShowRawFormat(false);
      settings.setTemperature(defaultTemperature);
      settings.setMaxTokens(defaultMaxTokens);
      settings.setSystemPrompt(defaultSystemPrompt);
      _apiKeyController.text = settings.apiKey;
      _temperatureController.text = settings.temperature.toString();
      _maxTokensController.text = settings.maxTokens.toString();
      _systemPromptController.text = settings.systemPrompt;
      _showRawFormat = settings.showRawFormat;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Languages.textSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
            tooltip: Languages.textReset,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: Languages.textApiKey,
                hintText: Languages.textApiKeyHint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Languages.textApiKeyError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(Languages.textShowRawFormat),
              subtitle: const Text(Languages.textShowRawFormatDesc),
              value: _showRawFormat,
              onChanged: (value) {
                setState(() {
                  _showRawFormat = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _temperatureController,
              decoration: const InputDecoration(
                labelText: Languages.textTemperature,
                helperText: Languages.textTemperatureDesc,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Languages.errorTemperatureEmpty;
                }
                final temperature = double.tryParse(value);
                if (temperature == null || temperature < 0 || temperature > 2) {
                  return Languages.errorTemperatureRange;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxTokensController,
              decoration: const InputDecoration(
                labelText: Languages.textMaxTokens,
                helperText: Languages.textMaxTokensDesc,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Languages.errorMaxTokensEmpty;
                }
                final maxTokens = int.tryParse(value);
                if (maxTokens == null || maxTokens <= 0) {
                  return Languages.errorMaxTokensPositive;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _systemPromptController,
              decoration: const InputDecoration(
                labelText: Languages.textSystemPrompt,
                helperText: Languages.textSystemPromptDesc,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(Languages.textCancel),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: _saveSettings,
                  child: const Text(Languages.textSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
