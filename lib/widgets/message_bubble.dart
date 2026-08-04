// Default location: lib/widgets/message_bubble.dart
// Message bubble widget with animation, markdown, latex and token cost display

import 'package:flutter/material.dart';
import '../models/message.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final isAssistant = message.role == MessageRole.assistant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isUser
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: !isUser
                  ? Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.1))
                  : null,
            ),
            child: SelectableText(
              message.content,
              style: TextStyle(
                color: isUser ? Colors.white : null,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              if (isAssistant && message.formattedCost.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Text(
                    '${message.totalTokens} tkn • ${message.formattedCost}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
