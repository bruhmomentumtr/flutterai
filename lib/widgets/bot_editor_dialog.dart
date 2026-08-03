// Default location: lib/widgets/bot_editor_dialog.dart
// Dialog for creating and editing bot configurations

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/bot.dart';
import '../languages/languages.dart';
import '../core/theme/app_spacing.dart';

class BotEditorDialog extends StatefulWidget {
  final Bot? bot;
  final List<String> availableModels;
  final Function(Bot)? onSave;

  const BotEditorDialog({
    Key? key,
    this.bot,
    this.availableModels = const [],
    this.onSave,
  }) : super(key: key);

  @override
  State<BotEditorDialog> createState() => _BotEditorDialogState();
}

class _BotEditorDialogState extends State<BotEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _systemPromptController;
  String? _selectedModel;
  double _temperature = 0.7;
  double _maxTokens = 2048;
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bot?.name ?? '');
    _systemPromptController =
        TextEditingController(text: widget.bot?.systemPrompt ?? '');
    _selectedModel = widget.bot?.model ??
        (widget.availableModels.isNotEmpty
            ? widget.availableModels.first
            : 'openai/gpt-4o-mini');
    _temperature = widget.bot?.temperature ?? 0.7;
    _maxTokens = (widget.bot?.maxTokens ?? 2048).toDouble();
    _selectedIcon = widget.bot?.iconName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  void _saveBot() {
    if (_formKey.currentState?.validate() != true) return;

    final savedBot = Bot(
      id: widget.bot?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      model: _selectedModel ?? 'openai/gpt-4o-mini',
      systemPrompt: _systemPromptController.text.trim(),
      temperature: _temperature,
      maxTokens: _maxTokens.toInt(),
      iconName: _selectedIcon,
      promptPrice: widget.bot?.promptPrice,
      completionPrice: widget.bot?.completionPrice,
    );

    if (widget.onSave != null) {
      widget.onSave!(savedBot);
    }

    Navigator.pop(context, savedBot);
  }

  @override
  Widget build(BuildContext context) {
    final isNewBot = widget.bot == null;
    final title = isNewBot ? Languages.titleCreateBot : Languages.titleEditBot;

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: Languages.labelBotName,
                  hintText: Languages.hintBotName,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return Languages.errorBotName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: widget.availableModels.contains(_selectedModel)
                    ? _selectedModel
                    : (widget.availableModels.isNotEmpty
                        ? widget.availableModels.first
                        : _selectedModel),
                decoration: InputDecoration(
                  labelText: Languages.labelModel,
                ),
                items: (widget.availableModels.isEmpty
                        ? [_selectedModel ?? 'openai/gpt-4o-mini']
                        : widget.availableModels)
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedModel = val);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _systemPromptController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: Languages.labelSystemPrompt,
                  hintText: Languages.hintSystemPrompt,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${Languages.labelTemperature}${_temperature.toStringAsFixed(1)}'),
                  Slider(
                    value: _temperature,
                    min: 0.0,
                    max: 2.0,
                    divisions: 20,
                    onChanged: (val) => setState(() => _temperature = val),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${Languages.labelMaxTokens}${_maxTokens.toInt()}'),
                  Slider(
                    value: _maxTokens,
                    min: 256,
                    max: 8192,
                    divisions: 31,
                    onChanged: (val) => setState(() => _maxTokens = val),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Languages.buttonCancel),
        ),
        ElevatedButton(
          onPressed: _saveBot,
          child: Text(isNewBot ? Languages.buttonCreate : Languages.buttonUpdate),
        ),
      ],
    );
  }
}
