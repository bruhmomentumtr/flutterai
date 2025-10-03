// Default location: lib/widgets/message_bubble.dart
// Message bubble widget to display chat messages with markdown support

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

// LaTeX regex patterns
final Map<String, RegExp> _latexPatterns = {
  'dollar': RegExp(r'\$\$([\s\S]*?)\$\$', multiLine: true), // $$ x^2 $$ formatı
  'dollarSingleLine': RegExp(r'\$([\s\S]*?)\$(?!\$)',
      multiLine: true), // $ x^2 $ formatı (tek dolar)
  'latexTag': RegExp(r'\[latex\]([\s\S]*?)\[/latex\]',
      multiLine: true), // [latex] x^2 [/latex] formatı
  'standardLatex': RegExp(r'\\begin\{equation\}([\s\S]*?)\\end\{equation\}',
      multiLine: true), // \begin{equation} formatı
  'displayLatex': RegExp(r'\\begin\{align\}([\s\S]*?)\\end\{align\}',
      multiLine: true), // \begin{align} formatı
  'inlineLatex': RegExp(r'\\begin\{math\}([\s\S]*?)\\end\{math\}',
      multiLine: true), // \begin{math} formatı
  'inlineLatexMath':
      RegExp(r'\\\(([\s\S]*?)\\\)', multiLine: true), // \( x^2 \) formatı
  'displayLatexMath':
      RegExp(r'\\\[([\s\S]*?)\\\]', multiLine: true), // \[ x^2 \] formatı
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

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _showRawContent = false;

  // Widget'ın yeniden oluşturulma durumunda state'i korumak için
  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mesaj değiştiğinde raw content gösterimini sıfırla
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

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary.withAlpha(204)
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display title if present and it's a bot message
            if (widget.message.title != null && !isUser) ...[
              Text(
                widget.message.title!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Divider(),
              const SizedBox(height: 4.0),
            ],

            // Display image if present
            if (widget.message.imageUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: _buildImagePreview(context, widget.message.imageUrl!),
              ),
              const SizedBox(height: 8.0),
            ],

            // Display message content - wrap in RepaintBoundary for better performance
            RepaintBoundary(
              child: _showRawContent || settings.showRawFormat
                  ? _buildSimpleTextContent(
                      context,
                      widget.message.content,
                      isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface)
                  : _getContentWidget(
                      context,
                      widget.message.content,
                      isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      isUser),
            ),

            // Bottom row with timestamp, copy and delete buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Toggle rendering button (only show if message contains LaTeX content)
                if (_containsLatexSyntax(widget.message.content))
                  IconButton(
                    icon: Icon(
                      _showRawContent ? Icons.code_off : Icons.code,
                      size: 16.0,
                      color: isUser
                          ? theme.colorScheme.onPrimary.withAlpha(179)
                          : theme.colorScheme.onSurface.withAlpha(153),
                    ),
                    tooltip: _showRawContent
                        ? Languages.textShowProcessed
                        : Languages.textShowRaw,
                    onPressed: () {
                      setState(() {
                        _showRawContent = !_showRawContent;
                      });
                    },
                    constraints: const BoxConstraints(
                      minHeight: 24,
                      minWidth: 24,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                // More actions button
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 16.0,
                    color: isUser
                        ? theme.colorScheme.onPrimary.withAlpha(179)
                        : theme.colorScheme.onSurface.withAlpha(153),
                  ),
                  tooltip: Languages.textMoreOptions,
                  onSelected: (value) {
                    if (value == Languages.textCopyMessage) {
                      _copyMessageToClipboard(context);
                    } else if (value == Languages.textCopyRawText) {
                      _copyRawMessageToClipboard(context);
                    } else if (value == Languages.textDeleteMessage) {
                      _deleteMessage(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: Languages.textCopyMessage,
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.copy, size: 18),
                        title: Text(Languages.textCopyMessage),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: Languages.textCopyRawText,
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.code, size: 18),
                        title: Text(Languages.textCopyRawText),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: Languages.textDeleteMessage,
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.delete_outline, size: 18),
                        title: Text(Languages.textDeleteMessage),
                      ),
                    ),
                  ],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                  position: PopupMenuPosition.under,
                ),
                // Timestamp
                Text(
                  _formatTime(widget.message.timestamp),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: isUser
                        ? theme.colorScheme.onPrimary.withAlpha(179)
                        : theme.colorScheme.onSurface.withAlpha(153),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // LaTeX sözdizimi içerip içermediğini kontrol et
  bool _containsLatexSyntax(String content) {
    return content.contains(r'$$') ||
        content.contains(r'\begin') ||
        content.contains(r'\(') ||
        content.contains(r'\)') ||
        content.contains(r'[latex]');
  }

  // Markdown sözdizimi içerip içermediğini kontrol et
  bool _containsMarkdown(String content) {
    // Markdown için yaygın patternler
    final patterns = [
      r'#{1,6}\s.+', // headers
      r'\*\*.+?\*\*', // bold
      r'_.+?_', // italic with underscore
      r'\*.+?\*', // italic with asterisk
      r'`[^`]+`', // inline code
      r'```[\s\S]*?```', // code blocks
      r'~~~[\s\S]*?~~~', // alternate code blocks
      r'\[.+?\]\(.+?\)', // links
      r'!\[.+?\]\(.+?\)', // images
      r'^\s*[-*+]\s', // unordered list items
      r'^\s*\d+\.\s', // numbered list items
      r'^\s*>\s', // blockquotes
      r'^\s*\|.+\|.+\|', // tables
      r'^\s*-{3,}', // horizontal rule
      r'<[a-z][a-z0-9]*(\s+[a-z0-9]+="[^"]*")*\s*>', // html tags
    ];

    // Her satırı kontrol etmek için içeriği satırlara böl
    final lines = content.split('\n');

    // Liste ve numaralı liste için arka arkaya satırları kontrol et
    bool hasListItems = false;
    bool hasNumberedList = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Liste kontrolü
      if (RegExp(r'^\s*[-*+]\s').hasMatch(line)) {
        hasListItems = true;
      }

      // Numaralı liste kontrolü
      if (RegExp(r'^\s*\d+\.\s').hasMatch(line)) {
        hasNumberedList = true;
      }

      // Tablo kontrolü - en az iki satırı olan bir tablo yapısı
      if (i < lines.length - 1 &&
          RegExp(r'^\s*\|.+\|.+\|').hasMatch(line) &&
          RegExp(r'^\s*\|[\s-:]*\|[\s-:]*\|').hasMatch(lines[i + 1])) {
        return true;
      }
    }

    if (hasListItems || hasNumberedList) {
      return true;
    }

    // Diğer markdown elementlerini kontrol et
    for (final pattern in patterns) {
      final regex = RegExp(pattern, multiLine: true);
      if (regex.hasMatch(content)) {
        return true;
      }
    }

    return false;
  }

  // İçerik türüne göre widget seç
  Widget _getContentWidget(
      BuildContext context, String content, Color textColor, bool isUser) {
    // Hem LaTeX hem de Markdown içeriyor mu diye kontrol et
    if (_containsLatexSyntax(content)) {
      try {
        return _buildLatexContent(context, content, textColor, isUser);
      } catch (e) {
        debugPrint('LaTeX render edilirken hata oluştu: $e');
        return _buildSimpleTextContent(context, content, textColor);
      }
    } else if (_containsMarkdown(content)) {
      try {
        return _buildMarkdownContent(context, content, textColor);
      } catch (e) {
        debugPrint('Markdown render edilirken hata oluştu: $e');
        return _buildSimpleTextContent(context, content, textColor);
      }
    } else {
      return _buildSimpleTextContent(context, content, textColor);
    }
  }

  // Helper method to format timestamp
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Basit metin içeriği gösterme
  Widget _buildSimpleTextContent(
      BuildContext context, String content, Color textColor) {
    // Markdown içeriyor mu kontrol et
    if (_containsMarkdown(content) && !_containsLatexSyntax(content)) {
      return _buildMarkdownContent(context, content, textColor);
    }

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onLongPress: () {
          // Uzun basınca metni panoya kopyalama seçeneği sun
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
            const SnackBar(
              content: Text(Languages.textCopyToClipboard),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              width: 250,
            ),
          );
        },
        child: Text(
          content,
          style: TextStyle(
            color: textColor,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  // Markdown içeriği oluştur
  Widget _buildMarkdownContent(
      BuildContext context, String content, Color textColor) {
    // Kod blokları için dil tanımalı düzenleme
    final formattedContent = _formatCodeBlocks(content);

    return SizedBox(
      width: double.infinity,
      child: MarkdownBody(
        data: formattedContent,
        styleSheet: _createMarkdownStyleSheet(context, textColor),
        selectable: false,
        onTapLink: (text, href, title) {
          // Link tıklamaları için özel işleme yapılabilir
          debugPrint('Link tıklandı: $href');
        },
        builders: const {
          // Özel markdown elemanları için builder'lar eklenebilir
        },
      ),
    );
  }

  // Kod bloklarını formatla - dil tanımalı
  String _formatCodeBlocks(String content) {
    // Markdown kod bloklarını bul: ```dil ...kod... ```
    final codeBlockRegex = RegExp(r'```(\w*)\n([\s\S]*?)```', multiLine: true);

    // Her kod bloğunu işle
    String formattedContent = content;
    final matches = codeBlockRegex.allMatches(content);

    // Kod bloklarına dil bilgisi ekle veya eksik olanları düzelt
    for (final match in matches) {
      final fullMatch = match.group(0) ?? '';
      final language = match.group(1) ?? '';
      final code = match.group(2) ?? '';

      // Eğer dil belirtilmemişse "text" olarak işaretle
      if (language.trim().isEmpty) {
        final replacementBlock = '```text\n$code```';
        formattedContent =
            formattedContent.replaceFirst(fullMatch, replacementBlock);
      }
    }

    return formattedContent;
  }

  // LaTeX içeriğini güvenli şekilde oluştur
  Widget _buildLatexContent(
      BuildContext context, String content, Color textColor, bool isUser) {
    try {
      // Farklı LaTeX formatlarını tespit eden regex ifadeleri
      final dollarRegex = _latexPatterns['dollar']!;
      final dollarSingleLineRegex = _latexPatterns['dollarSingleLine']!;
      final latexTagRegex = _latexPatterns['latexTag']!;
      final standardLatexRegex = _latexPatterns['standardLatex']!;
      final displayLatexRegex = _latexPatterns['displayLatex']!;
      final inlineLatexRegex = _latexPatterns['inlineLatex']!;
      final inlineLatexMathRegex = _latexPatterns['inlineLatexMath']!;
      final displayLatexMathRegex = _latexPatterns['displayLatexMath']!;

      // Tüm eşleşmeleri topla
      List<Match> allMatches = [];
      allMatches.addAll(dollarRegex.allMatches(content));
      allMatches.addAll(dollarSingleLineRegex.allMatches(content));
      allMatches.addAll(latexTagRegex.allMatches(content));
      allMatches.addAll(standardLatexRegex.allMatches(content));
      allMatches.addAll(displayLatexRegex.allMatches(content));
      allMatches.addAll(inlineLatexRegex.allMatches(content));
      allMatches.addAll(inlineLatexMathRegex.allMatches(content));
      allMatches.addAll(displayLatexMathRegex.allMatches(content));

      // Eşleşme yoksa normal metni göster
      if (allMatches.isEmpty) {
        // LaTeX yok, markdown kontrolü yap
        if (_containsMarkdown(content)) {
          return _buildMarkdownContent(context, content, textColor);
        } else {
          return _buildSimpleTextContent(context, content, textColor);
        }
      }

      // Konum bilgisine göre sırala
      allMatches.sort((a, b) => a.start.compareTo(b.start));

      // Örtüşen eşleşmeleri temizle (nested LaTeX patternlarını önle)
      List<Match> filteredMatches = [];
      for (int i = 0; i < allMatches.length; i++) {
        final current = allMatches[i];
        bool overlapping = false;

        // Önceki eşleşmelerle karşılaştır
        for (int j = 0; j < filteredMatches.length; j++) {
          final previous = filteredMatches[j];
          // Eğer mevcut eşleşme önceki bir eşleşmenin içindeyse
          if (current.start >= previous.start && current.end <= previous.end) {
            overlapping = true;
            break;
          }
        }

        if (!overlapping) {
          filteredMatches.add(current);
        }
      }

      // Process both text and LaTeX parts
      List<Widget> widgets = [];
      int lastEnd = 0;

      for (final match in filteredMatches) {
        // Add text before the LaTeX block
        if (match.start > lastEnd) {
          final text = content.substring(lastEnd, match.start);
          if (text.trim().isNotEmpty) {
            // LaTeX öncesi metin parçası için markdown kontrolü yap
            if (_containsMarkdown(text)) {
              widgets.add(SizedBox(
                width: double.infinity,
                child: Builder(builder: (context) {
                  try {
                    return MarkdownBody(
                      data: text,
                      styleSheet: _createMarkdownStyleSheet(context, textColor),
                      selectable: false,
                    );
                  } catch (e) {
                    return Text(text, style: TextStyle(color: textColor));
                  }
                }),
              ));
            } else {
              widgets.add(SizedBox(
                width: double.infinity,
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ));
            }
          }
        }

        // Get full match and group
        final fullMatch = match.group(0) ?? '';
        final latexContent = match.group(1) ?? '';

        // Belirli LaTeX komutlarını temizle/düzelt
        String cleanedLatex;
        try {
          // LaTeX içeriğinden Türkçe karakterleri doğru şekilde temizle
          cleanedLatex = _sanitizeLatexContent(latexContent);

          cleanedLatex = cleanedLatex
              .trim()
              .replaceAll(
                  '\\\\', '\\') // Çift ters eğik çizgileri tek hale getir
              .replaceAll('&', '') // align ortamından & karakterlerini çıkar
              .replaceAll('\\nonumber', ''); // nonumber etiketlerini çıkar
        } catch (e) {
          // LaTeX temizleme hatası
          debugPrint('LaTeX temizleme hatası: $e');
          cleanedLatex = latexContent.trim();
        }

        // Add the LaTeX block - Math.tex widget'ını error boundary içine al
        widgets.add(
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Builder(
              builder: (context) {
                try {
                  return Math.tex(
                    cleanedLatex,
                    textStyle: TextStyle(color: textColor, fontSize: 16.0),
                    onErrorFallback: (err) {
                      debugPrint(
                          'LaTeX error: $err for formula: $cleanedLatex');
                      return Text(
                        fullMatch,
                        style: TextStyle(
                            color: textColor, fontFamily: 'monospace'),
                      );
                    },
                  );
                } catch (e) {
                  debugPrint('LaTeX hata: $e');
                  return Text(
                    fullMatch,
                    style: TextStyle(color: textColor, fontFamily: 'monospace'),
                  );
                }
              },
            ),
          ),
        );

        lastEnd = match.end;
      }

      // Add text after the last LaTeX block
      if (lastEnd < content.length) {
        final text = content.substring(lastEnd);
        if (text.trim().isNotEmpty) {
          // LaTeX sonrası metin parçası için markdown kontrolü yap
          if (_containsMarkdown(text)) {
            widgets.add(SizedBox(
              width: double.infinity,
              child: Builder(builder: (context) {
                try {
                  return MarkdownBody(
                    data: text,
                    styleSheet: _createMarkdownStyleSheet(context, textColor),
                    selectable: false,
                  );
                } catch (e) {
                  return Text(text, style: TextStyle(color: textColor));
                }
              }),
            ));
          } else {
            widgets.add(SizedBox(
              width: double.infinity,
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ));
          }
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    } catch (e) {
      debugPrint('LaTeX işleme hatası: $e');
      // LaTeX render edilemezse Markdown kontrolü yap
      if (_containsMarkdown(content)) {
        return _buildMarkdownContent(context, content, textColor);
      }
      // Fallback to plain text if anything goes wrong
      return Text(
        content,
        style: TextStyle(color: textColor),
      );
    }
  }

  // LaTeX içeriğini Türkçe karakter ve sorunlara karşı temizler
  String _sanitizeLatexContent(String latex) {
    // Türkçe karakterleri ASCII eşdeğerleriyle değiştir
    String result = latex;

    // Türkçe karakterleri ASCII eşdeğerleriyle değiştir
    _turkishMap.forEach((turkishChar, asciiChar) {
      result = result.replaceAll(turkishChar, asciiChar);
    });

    // % işaretinden sonraki yorum satırlarını kaldır
    result = result.replaceAll(RegExp(r'%.*?$', multiLine: true), '');

    return result;
  }

  // Markdown stil sayfası oluşturan yardımcı fonksiyon
  MarkdownStyleSheet _createMarkdownStyleSheet(
      BuildContext context, Color textColor) {
    final theme = Theme.of(context);

    return MarkdownStyleSheet(
      p: TextStyle(
        color: textColor,
        fontSize: 16.0,
      ),
      h1: TextStyle(
        color: textColor,
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
      h2: TextStyle(
        color: textColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      h3: TextStyle(
        color: textColor,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
      h4: TextStyle(
        color: textColor,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      h5: TextStyle(
        color: textColor,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
      h6: TextStyle(
        color: textColor,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
      em: TextStyle(
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      strong: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      code: TextStyle(
        color: textColor,
        backgroundColor:
            theme.colorScheme.surfaceContainerHighest.withAlpha(77),
        fontFamily: 'monospace',
        fontSize: 14.0,
      ),
      codeblockPadding: const EdgeInsets.all(8.0),
      codeblockDecoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4.0),
      ),
      blockquote: TextStyle(
        color: textColor.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: textColor.withValues(alpha: 0.5),
            width: 4.0,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 16.0),
      listBullet: TextStyle(color: textColor),
      listIndent: 20.0,
      tableBorder: TableBorder.all(color: textColor.withValues(alpha: 0.3)),
      tableHead: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      tableBody: TextStyle(color: textColor),
      a: TextStyle(
        color: theme.colorScheme.primary,
      ),
    );
  }

  // Function to copy message content to clipboard
  void _copyMessageToClipboard(BuildContext context) {
    try {
      // Null kontrol
      if (widget.message.content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textMessageEmpty),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 250,
          ),
        );
        return;
      }

      Clipboard.setData(ClipboardData(text: widget.message.content)).then((_) {
        // Show a snackbar to confirm copy
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textMessageCopied),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 250,
          ),
        );
      }).catchError((error) {
        debugPrint('Kopyalama işlemi hatası: $error');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textMessageCopyError),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 250,
          ),
        );
      });
    } catch (e) {
      debugPrint('Kopyalama işlemi hatası: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mesaj kopyalanamadı'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          width: 250,
        ),
      );
    }
  }

  // Function to copy raw message text to clipboard
  void _copyRawMessageToClipboard(BuildContext context) {
    try {
      // Null kontrol
      if (widget.message.content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textRawTextEmpty),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 250,
          ),
        );
        return;
      }

      // Create a plain text version without any formatting
      String rawText = widget.message.content;

      Clipboard.setData(ClipboardData(text: rawText)).then((_) {
        // Show a snackbar to confirm copy
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textRawTextCopied),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 250,
          ),
        );
      }).catchError((error) {
        debugPrint('Panoya ham metin kopyalama hatası: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Languages.textRawTextCopyError),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            width: 250,
          ),
        );
      });
    } catch (e) {
      debugPrint('Ham metin kopyalama işlemi hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ham metin kopyalanamadı'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          width: 250,
        ),
      );
    }
  }

  // Görsel önizleme widget'ı
  Widget _buildImagePreview(BuildContext context, String imageUrl) {
    // Base64 görseli mi yoksa ağ görseli mi kontrol et
    if (imageUrl.startsWith('data:image')) {
      try {
        // Base64 görselini işle
        // Prefix'i kaldır: "data:image/jpeg;base64," -> sadece base64 kısmını al
        final RegExp regex = RegExp(r'data:image/[^;]+;base64,(.*)');
        final match = regex.firstMatch(imageUrl);

        if (match != null && match.groupCount >= 1) {
          final String base64String = match.group(1)!;
          return Image.memory(
            base64Decode(base64String),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200, // Sabit bir yükseklik ver
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Görsel yükleme hatası: $error');
              return Container(
                width: double.infinity,
                height: 150,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      Languages.textImageLoadError,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } catch (e) {
        debugPrint('Base64 görsel işleme hatası: $e');
      }

      // Hata durumunda hata görseli göster
      return Container(
        width: double.infinity,
        height: 150,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported,
                color: Theme.of(context).colorScheme.error, size: 40),
            const SizedBox(height: 8),
            Text(
              Languages.textImageFormatError,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      );
    } else {
      // Normal ağ görseli
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Theme.of(context).colorScheme.error),
                Text(
                  Languages.textImageLoadError,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Mesajı silmek için onay dialogu göster
  void _deleteMessage(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Languages.textDeleteMessageTitle),
        content: const Text(Languages.textDeleteMessageConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(Languages.textCancel),
          ),
          FilledButton(
            onPressed: () {
              chatProvider.deleteMessage(widget.message.id);
              Navigator.of(context).pop();
            },
            child: const Text(Languages.textDelete),
          ),
        ],
      ),
    );
  }
}
