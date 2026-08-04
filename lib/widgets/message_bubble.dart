// Default location: lib/widgets/message_bubble.dart
// Message bubble widget with animation, markdown, latex and token cost display

import 'dart:convert';
import 'dart:typed_data';
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isUser && message.imageBase64 != null)
                  _UserImagePreview(
                    base64DataUri: message.imageBase64!,
                    isUser: isUser,
                  ),
                if (isUser && message.imageBase64 != null)
                  const SizedBox(height: AppSpacing.sm),
                showRaw
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
                          BracketLatexBlockSyntax(),
                        ],
                        inlineSyntaxes: [InlineLatexSyntax()],
                        builders: {
                          'latex': LatexElementBuilder(
                              textStyle: TextStyle(color: textColor)),
                          'inlineLatex': InlineLatexElementBuilder(
                              textStyle: TextStyle(color: textColor)),
                          'image': _MarkdownImageBuilder(
                              textColor: textColor ?? Colors.white),
                        },
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(Theme.of(context))
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
              ],
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

/// Renders an image attached to a user message. Decodes the base64 data URI
/// stored on the message and displays it inline within the chat bubble.
class _UserImagePreview extends StatelessWidget {
  final String base64DataUri;
  final bool isUser;

  const _UserImagePreview({
    Key? key,
    required this.base64DataUri,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bytes = _decodeDataUri(base64DataUri);
    if (bytes == null) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 240,
          maxWidth: 320,
        ),
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error rendering image preview: $error');
            return Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 16,
                    color: isUser ? Colors.white70 : null,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Image',
                    style: TextStyle(
                      fontSize: 12,
                      color: isUser ? Colors.white70 : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Uint8List? _decodeDataUri(String dataUri) {
    try {
      // Accept both "data:image/png;base64,XYZ" and raw "XYZ".
      final commaIndex = dataUri.indexOf(',');
      if (commaIndex < 0) {
        return base64Decode(dataUri);
      }
      final header = dataUri.substring(0, commaIndex);
      final payload = dataUri.substring(commaIndex + 1);
      if (header.contains(';base64')) {
        return base64Decode(payload);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to decode image data URI: $e');
      return null;
    }
  }
}

/// Renders markdown images emitted by the assistant. Catches plain `![alt](url)`
/// references which would otherwise be omitted by flutter_markdown_plus.
class _MarkdownImageBuilder extends MarkdownElementBuilder {
  final Color textColor;

  _MarkdownImageBuilder({required this.textColor});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final src = element.attributes['src'];
    final alt = element.attributes['alt'] ?? '';
    if (src == null || src.isEmpty) {
      return Text(
        alt,
        style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280, maxWidth: 360),
          child: Image.network(
            src,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Text(
              alt.isNotEmpty ? alt : src,
              style: TextStyle(
                color: textColor,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool isBlockElement() => true;
}
