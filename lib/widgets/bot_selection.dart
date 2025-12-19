// lib/widgets/bot_selection.dart
// Modern bot selection widget with gradient icons and improved design

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bot.dart';
import '../providers/settings_provider.dart';
import '../languages/languages.dart';
import '../core/theme/app_colors.dart';
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
    required this.selectedBot,
    required this.onSelectBot,
    required this.onAddBot,
    required this.onEditBot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                Languages.labelSelectBot,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Bot list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: bots.length,
          itemBuilder: (context, index) => _buildBotCard(context, bots[index]),
        ),

        const SizedBox(height: AppSpacing.md),

        // Add new bot button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: OutlinedButton.icon(
            onPressed: onAddBot,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text(Languages.labelAddNewBot),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusMd,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildBotCard(BuildContext context, Bot bot) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = selectedBot?.id == bot.id;
    final settings = Provider.of<SettingsProvider>(context);

    // Get bot color based on icon type
    final botColor = _getBotColor(bot.iconName);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onSelectBot(bot),
          borderRadius: AppSpacing.borderRadiusLg,
          child: AnimatedContainer(
            duration: AppSpacing.animFast,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? botColor.withOpacity(0.1)
                  : (isDark ? AppColors.cardDark : AppColors.cardLight),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: isSelected
                    ? botColor
                    : theme.colorScheme.outline.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: botColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Bot icon with gradient background
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        botColor,
                        botColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: AppSpacing.borderRadiusMd,
                    boxShadow: [
                      BoxShadow(
                        color: botColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconData(bot.iconName),
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Bot info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              bot.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: botColor,
                                borderRadius: AppSpacing.borderRadiusSm,
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bot.model,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xxs,
                        children: [
                          _buildPropertyChip(
                            context,
                            Icons.thermostat_outlined,
                            '${settings.temperature.toStringAsFixed(1)}',
                            botColor,
                          ),
                          _buildPropertyChip(
                            context,
                            Icons.token_outlined,
                            '${settings.maxTokens}',
                            botColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Edit button
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => onEditBot(bot),
                  tooltip: Languages.tooltipEditBot,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBotColor(String iconName) {
    switch (iconName) {
      case 'chat':
        return AppColors.primary;
      case 'smart_toy':
        return AppColors.secondary;
      case 'edit':
        return AppColors.accent;
      case 'science':
        return const Color(0xFF10B981); // Green
      case 'school':
        return const Color(0xFFF59E0B); // Amber
      case 'code':
        return const Color(0xFF8B5CF6); // Purple
      default:
        return AppColors.primary;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'chat':
        return Icons.chat_rounded;
      case 'smart_toy':
        return Icons.smart_toy_rounded;
      case 'edit':
        return Icons.edit_note_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'code':
        return Icons.code_rounded;
      default:
        return Icons.auto_awesome;
    }
  }
}
