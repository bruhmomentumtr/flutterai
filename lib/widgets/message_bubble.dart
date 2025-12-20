// lib/widgets/message_bubble.dart
// Modern message bubble widget with animations and markdown support

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/message.dart';
import '../providers/settings_provider.dart';
import '../providers/chat_provider.dart';
import 'dart:convert';
import '../languages/languages.dart';
import '../core/markdown/markdown_normalizer.dart';
import '../core/theme/app_spacing.dart';

// LaTeX regex patterns
final Map<String, RegExp> _latexPatterns = {
  'dollar': RegExp(r'\$\$([\s\S]*?)\$\$', multiLine: true),
  'dollarSingleLine': RegExp(r'\$([\s\S]*?)\$(?!\$)', multiLine: true),
  'latexTag': RegExp(r'\[latex\]([\s\S]*?)\[/latex\]', multiLine: true),
  'standardLatex': RegExp(r'\\begin\{equation\}([\s\S]*?)\\end\{equation\}',
      multiLine: true),
  'displayLatex':
      RegExp(r'\\begin\{align\}([\s\S]*?)\\end\{align\}', multiLine: true),
  'inlineLatex':
      RegExp(r'\\begin\{math\}([\s\S]*?)\\end\{math\}', multiLine: true),
  'inlineLatexMath': RegExp(r'\\\(([\s\S]*?)\\\)', multiLine: true),
  'displayLatexMath': RegExp(r'\\\[([\s\S]*?)\\\]', multiLine: true),
};

// Turkish character mapping
const Map<String, String> _turkishMap = {
  'ı': 'i',
  'İ': 'I',
  'ğ': 'g',
  'Ğ': 'G',
  'ü': 'u',
  'Ü': 'U',
  'ş': 's',
  'Ş': 'S',
  'ö': 'o',
  'Ö': 'O',
  'ç': 'c',
  'Ç': 'C',
};

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool showAnimation;

  const MessageBubble({
    Key? key,
    required this.message,
    this.showAnimation = true,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  bool _showRawContent = false;
  bool _showThinking = false; // For thinking/response tab toggle
  final MarkdownNormalizer _normalizer = MarkdownNormalizer();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppSpacing.animMedium,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    if (widget.showAnimation) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.id != widget.message.id) {
      setState(() {
        _showRawContent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUser = widget.message.role == MessageRole.user;
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
              horizontal: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // AI Avatar
                if (!isUser) ...[
                  _buildAvatar(context, isUser, isDark),
                  const SizedBox(width: AppSpacing.xs),
                ],

                // Message content
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width *
                          AppSpacing.bubbleMaxWidth,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(AppSpacing.bubbleRadius),
                        topRight:
                            const Radius.circular(AppSpacing.bubbleRadius),
                        bottomLeft: Radius.circular(isUser
                            ? AppSpacing.bubbleRadius
                            : AppSpacing.radiusXs),
                        bottomRight: Radius.circular(isUser
                            ? AppSpacing.radiusXs
                            : AppSpacing.bubbleRadius),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title for AI messages
                        if (widget.message.title != null && !isUser) ...[
                          Text(
                            widget.message.title!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isUser
                                  ? Colors.white.withOpacity(0.8)
                                  : theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],

                        // Image preview
                        if (widget.message.imageUrl != null) ...[
                          ClipRRect(
                            borderRadius: AppSpacing.borderRadiusMd,
                            child: _buildImagePreview(
                                context, widget.message.imageUrl!),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],

                        // Thinking tabs for AI messages with thinking content
                        if (!isUser &&
                            widget.message.thinkingContent != null) ...[
                          _buildThinkingTabs(context, theme),
                          const SizedBox(height: AppSpacing.xs),
                        ],

                        // Message content
                        RepaintBoundary(
                          child: _showRawContent || settings.showRawFormat
                              ? _buildSimpleTextContent(
                                  context,
                                  _showThinking &&
                                          widget.message.thinkingContent != null
                                      ? widget.message.thinkingContent!
                                      : widget.message.content,
                                  isUser
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                )
                              : _getContentWidget(
                                  context,
                                  _normalizer.normalize(
                                    _showThinking &&
                                            widget.message.thinkingContent !=
                                                null
                                        ? widget.message.thinkingContent!
                                        : widget.message.content,
                                  ),
                                  isUser
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                  isUser,
                                ),
                        ),

                        // Bottom row
                        const SizedBox(height: AppSpacing.xs),
                        _buildBottomRow(context, isUser, theme),
                      ],
                    ),
                  ),
                ),

                // User Avatar
                if (isUser) ...[
                  const SizedBox(width: AppSpacing.xs),
                  _buildAvatar(context, isUser, isDark),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      width: AppSpacing.avatarSm,
      height: AppSpacing.avatarSm,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUser ? theme.colorScheme.primary : theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: (isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary)
                .withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person : Icons.auto_awesome,
        size: 18,
        color: isUser
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSecondary,
      ),
    );
  }

  /// Build mini tabs for switching between Response and Thinking content
  Widget _buildThinkingTabs(BuildContext context, ThemeData theme) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMiniTab(
            context: context,
            theme: theme,
            label: 'Response',
            icon: Icons.chat_bubble_outline,
            isSelected: !_showThinking,
            onTap: () => setState(() => _showThinking = false),
          ),
          _buildMiniTab(
            context: context,
            theme: theme,
            label: 'Thinking',
            icon: Icons.psychology_outlined,
            isSelected: _showThinking,
            onTap: () => setState(() => _showThinking = true),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTab({
    required BuildContext context,
    required ThemeData theme,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context, bool isUser, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle raw content
        if (_containsLatexSyntax(widget.message.content))
          _buildIconButton(
            icon: _showRawContent ? Icons.code_off : Icons.code,
            onPressed: () => setState(() => _showRawContent = !_showRawContent),
            isUser: isUser,
          ),

        // More options
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 16,
            color: isUser
                ? Colors.white.withOpacity(0.7)
                : theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          tooltip: Languages.textMoreOptions,
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            _buildMenuItem(Icons.copy, Languages.textCopyMessage),
            _buildMenuItem(Icons.code, Languages.textCopyRawText),
            _buildMenuItem(Icons.delete_outline, Languages.textDeleteMessage),
          ],
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minHeight: 24, minWidth: 24),
        ),

        // Timestamp
        Text(
          _formatTime(widget.message.timestamp),
          style: TextStyle(
            fontSize: 11,
            color: isUser
                ? Colors.white.withOpacity(0.6)
                : theme.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isUser,
  }) {
    return IconButton(
      icon: Icon(icon, size: 16),
      onPressed: onPressed,
      color: isUser
          ? Colors.white.withOpacity(0.7)
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      constraints: const BoxConstraints(minHeight: 24, minWidth: 24),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String text) {
    return PopupMenuItem<String>(
      value: text,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, size: 18),
        title: Text(text),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    if (value == Languages.textCopyMessage) {
      _copyMessageToClipboard(context);
    } else if (value == Languages.textCopyRawText) {
      _copyRawMessageToClipboard(context);
    } else if (value == Languages.textDeleteMessage) {
      _deleteMessage(context);
    }
  }

  bool _containsLatexSyntax(String content) {
    return content.contains(r'$$') ||
        content.contains(r'\begin') ||
        content.contains(r'\(') ||
        content.contains(r'\)') ||
        content.contains(r'[latex]');
  }

  bool _containsMarkdown(String content) {
    final patterns = [
      r'#{1,6}\s.+',
      r'\*\*.+?\*\*',
      r'_.+?_',
      r'\*.+?\*',
      r'`[^`]+`',
      r'```[\s\S]*?```',
      r'\[.+?\]\(.+?\)',
      r'^\s*[-*+]\s',
      r'^\s*\d+\.\s',
      r'^\s*>\s',
    ];
    for (final pattern in patterns) {
      if (RegExp(pattern, multiLine: true).hasMatch(content)) return true;
    }
    return false;
  }

  Widget _getContentWidget(
      BuildContext context, String content, Color textColor, bool isUser) {
    if (_containsLatexSyntax(content)) {
      try {
        return _buildLatexContent(context, content, textColor, isUser);
      } catch (e) {
        return _buildSimpleTextContent(context, content, textColor);
      }
    } else if (_containsMarkdown(content)) {
      try {
        return _buildMarkdownContent(context, content, textColor);
      } catch (e) {
        return _buildSimpleTextContent(context, content, textColor);
      }
    }
    return _buildSimpleTextContent(context, content, textColor);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildSimpleTextContent(
      BuildContext context, String content, Color textColor) {
    if (_containsMarkdown(content) && !_containsLatexSyntax(content)) {
      return _buildMarkdownContent(context, content, textColor);
    }
    return SizedBox(
      width: double.infinity,
      child: SelectableText(
        content,
        style: TextStyle(color: textColor, fontSize: 15, height: 1.4),
      ),
    );
  }

  Widget _buildMarkdownContent(
      BuildContext context, String content, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: MarkdownBody(
        data: content,
        styleSheet: _createMarkdownStyleSheet(context, textColor),
        selectable: true,
      ),
    );
  }

  Widget _buildLatexContent(
      BuildContext context, String content, Color textColor, bool isUser) {
    final allMatches = <Match>[];
    for (final pattern in _latexPatterns.values) {
      allMatches.addAll(pattern.allMatches(content));
    }

    if (allMatches.isEmpty) {
      return _containsMarkdown(content)
          ? _buildMarkdownContent(context, content, textColor)
          : _buildSimpleTextContent(context, content, textColor);
    }

    allMatches.sort((a, b) => a.start.compareTo(b.start));

    // Filter overlapping
    final filteredMatches = <Match>[];
    for (final current in allMatches) {
      bool overlapping = false;
      for (final previous in filteredMatches) {
        if (current.start >= previous.start && current.end <= previous.end) {
          overlapping = true;
          break;
        }
      }
      if (!overlapping) filteredMatches.add(current);
    }

    List<Widget> widgets = [];
    int lastEnd = 0;

    for (final match in filteredMatches) {
      if (match.start > lastEnd) {
        final text = content.substring(lastEnd, match.start);
        if (text.trim().isNotEmpty) {
          widgets.add(Text(text, style: TextStyle(color: textColor)));
        }
      }

      final latexContent = match.group(1)?.trim() ?? '';
      widgets.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Math.tex(
            _sanitizeLatexContent(latexContent),
            textStyle: TextStyle(color: textColor, fontSize: 16),
            onErrorFallback: (err) => Text(
              match.group(0) ?? '',
              style: TextStyle(color: textColor, fontFamily: 'monospace'),
            ),
          ),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < content.length) {
      final text = content.substring(lastEnd);
      if (text.trim().isNotEmpty) {
        widgets.add(Text(text, style: TextStyle(color: textColor)));
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  String _sanitizeLatexContent(String latex) {
    String result = latex;
    // Replace line breaks inside \text{} commands with spaces
    result = result.replaceAllMapped(
      RegExp(r'\\text\{([^}]*)\}'),
      (match) {
        String textContent = match.group(1) ?? '';
        textContent = textContent.replaceAll(RegExp(r'\s*\n\s*'), ' ');
        return '\\text{$textContent}';
      },
    );
    _turkishMap.forEach((k, v) => result = result.replaceAll(k, v));
    result = result.replaceAll(RegExp(r'%.*?$', multiLine: true), '');
    return result;
  }

  MarkdownStyleSheet _createMarkdownStyleSheet(
      BuildContext context, Color textColor) {
    final theme = Theme.of(context);
    return MarkdownStyleSheet(
      p: TextStyle(color: textColor, fontSize: 15, height: 1.4),
      h1: TextStyle(
          color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
      h2: TextStyle(
          color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
      h3: TextStyle(
          color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
      code: TextStyle(
        color: textColor,
        backgroundColor:
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        fontFamily: 'monospace',
        fontSize: 13,
      ),
      codeblockPadding: const EdgeInsets.all(12),
      codeblockDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      listBullet: TextStyle(color: textColor),
      a: TextStyle(color: theme.colorScheme.primary),
    );
  }

  Widget _buildImagePreview(BuildContext context, String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      final base64Data = imageUrl.split(',').last;
      return Image.memory(
        base64Decode(base64Data),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
        errorBuilder: (_, __, ___) => _buildImageError(context),
      );
    }
    return _buildImageError(context);
  }

  Widget _buildImageError(BuildContext context) {
    return Container(
      height: 100,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.broken_image,
            color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  void _copyMessageToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.message.content)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(Languages.textMessageCopied),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    });
  }

  void _copyRawMessageToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.message.content)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(Languages.textRawTextCopied),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _deleteMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Languages.textDeleteMessageTitle),
        content: const Text(Languages.textDeleteMessageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(Languages.textCancel),
          ),
          FilledButton(
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .deleteMessage(widget.message.id);
              Navigator.pop(ctx);
            },
            child: const Text(Languages.textDelete),
          ),
        ],
      ),
    );
  }
}
