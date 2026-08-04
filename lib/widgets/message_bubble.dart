// Default location: lib/widgets/message_bubble.dart
// Message bubble widget with animation, markdown, latex and token cost display

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;

import '../models/message.dart';
import '../providers/settings_provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'markdown_latex_extension.dart';

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

    // Read settings without listening (we only need the value here).
    final settings = context.read<SettingsProvider>();
    final showRaw = settings.showRawFormat;

    final textColor =
        isUser ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color;

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
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.1),
                    )
                  : null,
            ),
            child: showRaw
                ? SelectableText(
                    message.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                    ),
                  )
                : MarkdownBody(
                    data: message.content,
                    selectable: true,
                    extensionSet: md.ExtensionSet.gitHubFlavored,
                    blockSyntaxes: const [
                      LatexBlockSyntax(),
                      DoubleDollarLatexBlockSyntax(),
                    ],
                    inlineSyntaxes: [InlineLatexSyntax()],
                    builders: {
                      'latex': LatexElementBuilder(
                          textStyle: TextStyle(color: textColor)),
                      'inlineLatex': InlineLatexElementBuilder(
                          textStyle: TextStyle(color: textColor)),
                    },
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                      p: TextStyle(color: textColor, fontSize: 15),
                      h1: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      h2: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      h3: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      h4: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      h5: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      h6: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      em: TextStyle(color: textColor, fontSize: 15),
                      strong: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      a: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                      blockquote: TextStyle(color: textColor, fontSize: 15),
                      img: TextStyle(color: textColor, fontSize: 15),
                      listBullet: TextStyle(color: textColor, fontSize: 15),
                      listIndent: AppSpacing.xs,
                      code: TextStyle(
                        color: textColor,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      codeblockPadding: const EdgeInsets.all(AppSpacing.sm),
                      codeblockDecoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
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
