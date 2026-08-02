// Default location: lib/widgets/bot_selection.dart
// Searchable bot and model selection widget with pricing display

import 'package:flutter/material.dart';
import '../models/bot.dart';
import '../languages/languages.dart';
import '../core/theme/app_spacing.dart';

class BotSelection extends StatefulWidget {
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
  State<BotSelection> createState() => _BotSelectionState();
}

class _BotSelectionState extends State<BotSelection> {
  void _showModelSearchPicker(BuildContext context) {
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredBots = widget.bots.where((bot) {
              final query = searchQuery.toLowerCase();
              return bot.name.toLowerCase().contains(query) ||
                  bot.model.toLowerCase().contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Languages.textYourBots,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onAddBot();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Model veya bot ara...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    ),
                    onChanged: (val) {
                      setStateModal(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: filteredBots.isEmpty
                        ? Center(
                            child: Text(
                              Languages.textNoBotsConfigured,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredBots.length,
                            itemBuilder: (context, index) {
                              final bot = filteredBots[index];
                              final isSelected = widget.selectedBot?.id == bot.id;
                              final pricingText = bot.formattedPricing;

                              return ListTile(
                                selected: isSelected,
                                title: Text(bot.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                  '${bot.model}${pricingText.isNotEmpty ? ' • $pricingText' : ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onEditBot(bot);
                                  },
                                ),
                                onTap: () {
                                  widget.onSelectBot(bot);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentBot = widget.selectedBot;
    final pricingText = currentBot?.formattedPricing ?? '';

    return InkWell(
      onTap: () => _showModelSearchPicker(context),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
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
        child: Row(
          children: [
            const Icon(Icons.smart_toy_outlined),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentBot?.name ?? Languages.labelSelectBot,
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
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
