// lib/screens/settings_screen.dart
// Modern settings screen with grouped sections and card design

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../languages/languages.dart';
import '../settingsvariables/default_settings_variables.dart';
import '../core/theme/app_spacing.dart';

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
  bool _isApiKeyVisible = false;
  double _temperatureValue = 0.7;

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
    _temperatureValue = settings.temperature;
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
      settings.setTemperature(_temperatureValue);
      settings.setMaxTokens(int.parse(_maxTokensController.text));
      settings.setSystemPrompt(_systemPromptController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
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
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
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
      setState(() {
        _apiKeyController.text = '';
        _temperatureController.text = defaultTemperature.toString();
        _temperatureValue = defaultTemperature;
        _maxTokensController.text = defaultMaxTokens.toString();
        _systemPromptController.text = defaultSystemPrompt;
        _showRawFormat = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Languages.textSettings),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.check),
            label: const Text(Languages.textSave),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          children: [
            // API Section
            _buildSectionHeader(
              context,
              icon: Icons.key_rounded,
              title: 'API Configuration',
            ),
            _buildCard(
              child: Column(
                children: [
                  TextFormField(
                    controller: _apiKeyController,
                    obscureText: !_isApiKeyVisible,
                    decoration: InputDecoration(
                      labelText: Languages.textApiKey,
                      hintText: Languages.textApiKeyHint,
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isApiKeyVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isApiKeyVisible = !_isApiKeyVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Languages.textApiKeyError;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Display Section
            _buildSectionHeader(
              context,
              icon: Icons.palette_outlined,
              title: 'Display',
            ),
            _buildCard(
              child: Column(
                children: [
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      return _buildSettingsTile(
                        title: 'Material You',
                        subtitle: 'Use system dynamic colors',
                        trailing: Switch.adaptive(
                          value: settings.useDynamicColors,
                          onChanged: (value) {
                            settings.setUseDynamicColors(value);
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsTile(
                    title: Languages.textShowRawFormat,
                    subtitle: Languages.textShowRawFormatDesc,
                    trailing: Switch.adaptive(
                      value: _showRawFormat,
                      onChanged: (value) {
                        setState(() {
                          _showRawFormat = value;
                        });
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      return _buildSettingsTile(
                        title: 'Theme Mode',
                        subtitle: 'Choose your preferred theme',
                        trailing: SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              icon: Icon(Icons.brightness_auto, size: 16),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              icon: Icon(Icons.light_mode, size: 16),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              icon: Icon(Icons.dark_mode, size: 16),
                            ),
                          ],
                          selected: {settings.themeMode},
                          onSelectionChanged: (Set<ThemeMode> modes) {
                            settings.setThemeMode(modes.first);
                          },
                          showSelectedIcon: false,
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Model Settings Section
            _buildSectionHeader(
              context,
              icon: Icons.tune_rounded,
              title: 'Model Settings',
            ),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Languages.textTemperature,
                          style: theme.textTheme.titleSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: AppSpacing.borderRadiusSm,
                          ),
                          child: Text(
                            _temperatureValue.toStringAsFixed(1),
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: _temperatureValue,
                    min: 0,
                    max: 2,
                    divisions: 20,
                    label: _temperatureValue.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _temperatureValue = value;
                        _temperatureController.text = value.toString();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      Languages.textTemperatureDesc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: TextFormField(
                      controller: _maxTokensController,
                      decoration: InputDecoration(
                        labelText: Languages.textMaxTokens,
                        helperText: Languages.textMaxTokensDesc,
                        prefixIcon: const Icon(Icons.format_list_numbered),
                        border: OutlineInputBorder(
                          borderRadius: AppSpacing.borderRadiusMd,
                        ),
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // System Prompt Section
            _buildSectionHeader(
              context,
              icon: Icons.psychology_outlined,
              title: 'System Prompt',
            ),
            _buildCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextFormField(
                  controller: _systemPromptController,
                  decoration: InputDecoration(
                    labelText: Languages.textSystemPrompt,
                    helperText: Languages.textSystemPromptDesc,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                  ),
                  maxLines: 4,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Reset Button
            Center(
              child: TextButton.icon(
                onPressed: _resetSettings,
                icon: Icon(Icons.restore,
                    color: Theme.of(context).colorScheme.error),
                label: Text(
                  Languages.textReset,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
