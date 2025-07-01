// Default location: lib/screens/settings_screen.dart
// Settings screen for managing application settings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

// Default settings values
const double _defaultTemperature = 0.7;
const int _defaultMaxTokens = 1024;
const String _defaultSystemPrompt = """You are a helpful assistant that formats responses clearly. 

When writing mathematical expressions or equations, you MUST use LaTeX syntax in your responses.

For inline equations, use: \$\$equation here\$\$
For block equations, use: [equation here]

When writing code, always use code blocks with language specification:
```python
print("Hello World")
```

Format all your responses with proper markdown.""";

// User-facing text messages
const String _textSettings = 'Ayarlar';
const String _textApiKey = 'API Anahtarı';
const String _textApiKeyHint = 'OpenRouter API anahtarınızı girin';
const String _textApiKeyError = 'API anahtarı boş olamaz';
const String _textShowRawFormat = 'Ham Formatı Göster';
const String _textShowRawFormatDesc = 'Mesajları ham formatında göster';
const String _textTemperature = 'Sıcaklık';
const String _textTemperatureDesc = 'Yanıtların yaratıcılık seviyesi (0.0 - 2.0)';
const String _textMaxTokens = 'Maksimum Token';
const String _textMaxTokensDesc = 'Yanıtlar için maksimum token sayısı';
const String _textSystemPrompt = 'Sistem Promptu';
const String _textSystemPromptDesc = 'AI asistanı için sistem promptu';
const String _textSave = 'Kaydet';
const String _textCancel = 'İptal';
const String _textReset = 'Sıfırla';
const String _textResetConfirm = 'Tüm ayarlar varsayılan değerlerine sıfırlanacak. Devam etmek istiyor musunuz?';
const String _textYes = 'Evet';
const String _textNo = 'Hayır';

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
    _temperatureController = TextEditingController(text: settings.temperature.toString());
    _maxTokensController = TextEditingController(text: settings.maxTokens.toString());
    _systemPromptController = TextEditingController(text: settings.systemPrompt);
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
        title: const Text(_textReset),
        content: const Text(_textResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(_textNo),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(_textYes),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final settings = context.read<SettingsProvider>();
      settings.setApiKey('');
      settings.setShowRawFormat(false);
      settings.setTemperature(_defaultTemperature);
      settings.setMaxTokens(_defaultMaxTokens);
      settings.setSystemPrompt(_defaultSystemPrompt);
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
        title: const Text(_textSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetSettings,
            tooltip: _textReset,
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
                labelText: _textApiKey,
                hintText: _textApiKeyHint,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return _textApiKeyError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text(_textShowRawFormat),
              subtitle: const Text(_textShowRawFormatDesc),
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
                labelText: _textTemperature,
                helperText: _textTemperatureDesc,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Sıcaklık değeri boş olamaz';
                }
                final temperature = double.tryParse(value);
                if (temperature == null || temperature < 0 || temperature > 2) {
                  return 'Sıcaklık değeri 0.0 ile 2.0 arasında olmalıdır';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxTokensController,
              decoration: const InputDecoration(
                labelText: _textMaxTokens,
                helperText: _textMaxTokensDesc,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Maksimum token değeri boş olamaz';
                }
                final maxTokens = int.tryParse(value);
                if (maxTokens == null || maxTokens <= 0) {
                  return 'Maksimum token değeri pozitif bir sayı olmalıdır';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _systemPromptController,
              decoration: const InputDecoration(
                labelText: _textSystemPrompt,
                helperText: _textSystemPromptDesc,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(_textCancel),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: _saveSettings,
                  child: const Text(_textSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 