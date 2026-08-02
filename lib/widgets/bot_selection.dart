// Default location: lib/widgets/bot_selection.dart
// Bot selection widget with pricing display

import 'package:flutter/material.dart';
import '../models/bot.dart';
import '../languages/languages.dart';
import '../core/theme/app_spacing.dart';

class BotSelection extends StatelessWidget {
  final List<Bot> bots;
  final Bot? selectedBot;
  final Function(Bot) onSelectBot;
  final VoidCallback onAddBot;
  final Function(Bot) onEditBot;

  const BotSelection({
    Key? key,
    required this.bots,
    this.selectedBot,
    required this.onSelectBot,
    required this.onAddBot,
    required this.onEditBot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Bot>(
          isExpanded: true,
          value: selectedBot,
          hint: Text(Languages.labelSelectBot),
          items: bots.map((bot) {
            final pricingText = bot.formattedPricing;
            return DropdownMenuItem<Bot>(
              value: bot,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bot.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (pricingText.isNotEmpty)
                          Text(
                            pricingText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => onEditBot(bot),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (bot) {
            if (bot != null) onSelectBot(bot);
          },
        ),
      ),
    );
  }
}
