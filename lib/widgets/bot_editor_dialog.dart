// Default location: lib/widgets/bot_editor_dialog.dart
// Dialog for creating and editing bot configurations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/bot.dart';
import '../providers/settings_provider.dart';
import '../languages/languages.dart';
import '../settingsvariables/default_settings_variables.dart';

class BotEditorDialog extends StatefulWidget {
  final Bot? bot; // null for creating a new bot
  final List<String> availableModels;

  const BotEditorDialog({
    Key? key,
    this.bot,
    required this.availableModels,
  }) : super(key: key);

  @override
  State<BotEditorDialog> createState() => _BotEditorDialogState();
}

class _BotEditorDialogState extends State<BotEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _systemPromptController = TextEditingController();
  
  String _selectedModel = 'openai/gpt-4o-mini';
  double _temperature = defaultTemperature;
  int _maxTokens = defaultMaxTokens;
  String _selectedIcon = 'chat';

  final List<MapEntry<String, IconData>> _iconOptions = [
    const MapEntry('chat', Icons.chat),
    const MapEntry('smart_toy', Icons.smart_toy),
    const MapEntry('edit', Icons.edit),
    const MapEntry('science', Icons.science),
    const MapEntry('school', Icons.school),
    const MapEntry('code', Icons.code),
    const MapEntry('android', Icons.android),
  ];

  @override
  void initState() {
    super.initState();
    
    // If editing an existing bot, populate the form with bot data
    if (widget.bot != null) {
      _nameController.text = widget.bot!.name;
      _selectedModel = widget.bot!.model;
      _selectedIcon = widget.bot!.iconName;
    }
    
    // Get global settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      setState(() {
        _systemPromptController.text = settings.systemPrompt;
        _temperature = settings.temperature;
        _maxTokens = settings.maxTokens;
      });
    });
    
    // If no available models or selected model not in list, use default
    if (widget.availableModels.isEmpty) {
      _selectedModel = 'openai/gpt-4o-mini';
    } else if (!widget.availableModels.contains(_selectedModel)) {
      _selectedModel = widget.availableModels.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNewBot = widget.bot == null;
    final title = isNewBot ? Languages.titleCreateBot : Languages.titleEditBot;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.07, 
        vertical: screenHeight * 0.08
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog title
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              // Content with form
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bot name field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: Languages.labelBotName,
                        hintText: Languages.hintBotName,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Languages.errorBotName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    
                    // Model selection dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: Languages.labelModel,
                      ),
                      value: _selectedModel,
                      items: _getModelItems(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedModel = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    
                    // System prompt field
                    TextFormField(
                      controller: _systemPromptController,
                      decoration: InputDecoration(
                        labelText: Languages.labelSystemPrompt,
                        hintText: Languages.hintSystemPrompt,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Languages.errorSystemPrompt;
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    
                    // Temperature slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Languages.labelTemperature}${_temperature.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Slider(
                          value: _temperature,
                          min: 0.0,
                          max: 2.0,
                          divisions: 20,
                          label: _temperature.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _temperature = value;
                            });
                          },
                        ),
                        Text(
                          Languages.labelTemperatureHelp,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    
                    // Max tokens slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Languages.labelMaxTokens}${_maxTokens}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Slider(
                          value: _maxTokens.toDouble(),
                          min: 1024,
                          max: 10240,
                          divisions: 9,
                          label: _maxTokens.toString(),
                          onChanged: (value) {
                            setState(() {
                              _maxTokens = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    
                    // Icon selection
                    Text(
                      Languages.labelIcon,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    
                    // Icon grid
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _iconOptions.map((option) {
                        final isSelected = _selectedIcon == option.key;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIcon = option.key;
                            });
                          },
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Icon(
                              option.value,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              
              // Button row
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(Languages.buttonCancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saveBot,
                    child: Text(isNewBot ? Languages.buttonCreate : Languages.buttonUpdate),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBot() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    // Save global settings
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    settings.setSystemPrompt(_systemPromptController.text);
    settings.setTemperature(_temperature);
    settings.setMaxTokens(_maxTokens);

    // Create or update bot
    final Bot result;
    
    if (widget.bot == null) {
      // Creating a new bot
      const uuid = Uuid();
      result = Bot(
        id: uuid.v4(),
        name: _nameController.text,
        model: _selectedModel,
        iconName: _selectedIcon,
      );
    } else {
      // Updating existing bot
      result = widget.bot!.copyWith(
        name: _nameController.text,
        model: _selectedModel,
        iconName: _selectedIcon,
      );
    }
    
    Navigator.of(context).pop(result);
  }

  // Helper method to get model dropdown items with proper validation
  List<DropdownMenuItem<String>> _getModelItems() {
    final defaultModels = ['openai/gpt-3.5-turbo', 'openai/gpt-4', 'anthropic/claude-2'];
    final models = widget.availableModels.isEmpty ? defaultModels : widget.availableModels;
    
    // Ensure selected model is in the list
    if (!models.contains(_selectedModel)) {
      models.add(_selectedModel);
    }
    
    return models.map((model) => DropdownMenuItem(
      value: model,
      child: Text(model),
    )).toList();
  }
} 