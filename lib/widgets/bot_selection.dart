// Default location: lib/widgets/bot_selection.dart
// Bot selection widget for choosing and configuring chatbots

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bot.dart';
import '../providers/settings_provider.dart';

class BotSelection extends StatelessWidget {
  final List<Bot> bots;
  final Bot? selectedBot;
  final Function(Bot) onSelectBot;
  final VoidCallback onAddBot;
  final Function(Bot) onEditBot;

  const BotSelection({
    Key? key,
    required this.bots,
    required this.selectedBot,
    required this.onSelectBot,
    required this.onAddBot,
    required this.onEditBot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Bot',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          _buildBotList(context),
          const SizedBox(height: 16.0),
          OutlinedButton.icon(
            onPressed: onAddBot,
            icon: const Icon(Icons.add),
            label: const Text('Add New Bot'),
          ),
        ],
      ),
    );
  }

  Widget _buildBotList(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bots.length,
      itemBuilder: (context, index) {
        final bot = bots[index];
        final isSelected = selectedBot?.id == bot.id;
        
        return Card(
          elevation: isSelected ? 4 : 1,
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: InkWell(
            onTap: () => onSelectBot(bot),
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    _getIconData(bot.iconName),
                    size: 32.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bot.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          bot.model,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            _buildPropertyChip(
                              context, 
                              'Temp: ${settings.temperature.toStringAsFixed(1)}',
                            ),
                            const SizedBox(width: 8.0),
                            _buildPropertyChip(
                              context, 
                              'Max: ${settings.maxTokens}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEditBot(bot),
                    tooltip: 'Edit Bot',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPropertyChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'chat':
        return Icons.chat;
      case 'smart_toy':
        return Icons.smart_toy;
      case 'edit':
        return Icons.edit;
      case 'science':
        return Icons.science;
      case 'school':
        return Icons.school;
      case 'code':
        return Icons.code;
      default:
        return Icons.android;
    }
  }
} 