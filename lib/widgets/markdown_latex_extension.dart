// Default location: lib/widgets/markdown_latex_extension.dart
// Extension to enable LaTeX rendering in Markdown.
// Supports multiple math delimiters used by different AI models:
//   - [latex]...[/latex]   (explicit block)
//   - $$...$$              (display math, LaTeX style)
//   - \[...\]              (display math, Claude/OpenAI style)
//   - \(...\)              (inline math, Claude/OpenAI style)
//   - $...$                (inline math, LaTeX style - skipped when ambiguous)

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;
import '../languages/languages.dart';

// ---------------- Block patterns ----------------

final RegExp latexBlockPattern =
    RegExp(r'^\s*\[\s*latex\s*\]([\s\S]*?)\[\s*\/\s*latex\s*\]');
final RegExp doubleDollarLatexBlockPattern =
    RegExp(r'^\s*\$\$([\s\S]*?)\$\$\s*$', multiLine: true);
final RegExp bracketLatexBlockPattern =
    RegExp(r'^\s*\\\[([\s\S]*?)\\\]\s*$', multiLine: true);

// ---------------- Inline patterns ----------------

// Matches \( ... \) - Claude/OpenAI inline math
final RegExp parenInlineLatexPattern =
    RegExp(r'\\\(([\s\S]+?)\\\)', multiLine: true);

// Matches \[ ... \] - Claude/OpenAI display math (also used inline)
final RegExp bracketInlineLatexPattern =
    RegExp(r'\\\[([\s\S]+?)\\\]', multiLine: true);

// Matches $...$ but only when:
//   - preceded by start-of-line/whitespace/punctuation (not a digit)
//   - not followed by another $ or digit (avoids $$ and $5.99)
// This is intentionally conservative to avoid matching currency.
final RegExp dollarInlineLatexPattern = RegExp(
  r'(?<![A-Za-z0-9_\$])\$(?!\$)([^\$\n]+?)\$(?!\$)',
  multiLine: true,
);

// Custom syntax for LaTeX blocks
class LatexBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => latexBlockPattern;

  const LatexBlockSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    return pattern.hasMatch(parser.current.content);
  }

  @override
  md.Node parse(md.BlockParser parser) {
    final match = pattern.firstMatch(parser.current.content)!;
    final latexContent = match.group(1)?.trim() ?? '';

    parser.advance();
    return md.Element('latex', [md.Text(latexContent)]);
  }
}

// Custom syntax for LaTeX blocks with $$ delimiters
class DoubleDollarLatexBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => doubleDollarLatexBlockPattern;

  const DoubleDollarLatexBlockSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    // Check if the current line starts with $$
    if (!parser.current.content.trim().startsWith(r'$$')) {
      return false;
    }

    // Look ahead to find the closing $$ marker
    String fullText = parser.current.content;
    int lineCount = 1;

    // If $$ is not closed on the same line, look ahead
    if (!fullText.trim().endsWith(r'$$')) {
      while (parser.peek(lineCount) != null) {
        String? nextLine = parser.peek(lineCount)?.content;
        if (nextLine == null) break;

        fullText += '\n$nextLine';
        lineCount++;

        if (nextLine.trim().endsWith(r'$$')) {
          break;
        }
      }
    }

    return pattern.hasMatch(fullText);
  }

  @override
  md.Node parse(md.BlockParser parser) {
    // Start with current line
    String fullText = parser.current.content;
    parser.advance();

    // If $$ is not closed on the first line, collect lines until we find the closing marker
    if (!fullText.trim().endsWith(r'$$')) {
      while (!parser.isDone) {
        String nextLine = parser.current.content;
        fullText += '\n$nextLine';

        if (nextLine.trim().endsWith(r'$$')) {
          parser.advance();
          break;
        }

        parser.advance();
      }
    }

    final match = pattern.firstMatch(fullText);
    if (match == null) {
      return md.Element('p', [md.Text(fullText)]);
    }

    final latexContent = match.group(1)?.trim() ?? '';
    return md.Element('latex', [md.Text(latexContent)]);
  }
}

// Custom element builder for LaTeX blocks
class LatexElementBuilder extends MarkdownElementBuilder {
  final TextStyle? textStyle;

  LatexElementBuilder({this.textStyle});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final textContent = element.textContent;
    if (textContent.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 600,
          ),
          child: Math.tex(
            textContent,
            textStyle: textStyle,
            mathStyle: MathStyle.display,
            onErrorFallback: (error) {
              debugPrint('\x1B[31m${Languages.latexErrorDebug} $error\x1B[0m');
              return Builder(
                builder: (context) => Text(
                  '\x1B[31m${Languages.errorRenderingLatex} ${error.message}\x1B[0m',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool isBlockElement() => true;
}

/// Block syntax for `\[ ... \]` (Claude/OpenAI display math).
class BracketLatexBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => bracketLatexBlockPattern;

  const BracketLatexBlockSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    if (!parser.current.content.trim().startsWith(r'\[')) {
      return false;
    }
    String fullText = parser.current.content;
    int lineCount = 1;
    if (!fullText.trim().endsWith(r'\]')) {
      while (parser.peek(lineCount) != null) {
        String? nextLine = parser.peek(lineCount)?.content;
        if (nextLine == null) break;
        fullText += '\n$nextLine';
        lineCount++;
        if (nextLine.trim().endsWith(r'\]')) break;
      }
    }
    return pattern.hasMatch(fullText);
  }

  @override
  md.Node parse(md.BlockParser parser) {
    String fullText = parser.current.content;
    parser.advance();
    if (!fullText.trim().endsWith(r'\]')) {
      while (!parser.isDone) {
        String nextLine = parser.current.content;
        fullText += '\n$nextLine';
        if (nextLine.trim().endsWith(r'\]')) {
          parser.advance();
          break;
        }
        parser.advance();
      }
    }
    final match = pattern.firstMatch(fullText);
    if (match == null) {
      return md.Element('p', [md.Text(fullText)]);
    }
    final latexContent = match.group(1)?.trim() ?? '';
    return md.Element('latex', [md.Text(latexContent)]);
  }
}

/// Combined inline syntax that recognises `\(...\)`, `\[...\]` and `$...$`.
/// Order matters: \( and \[ are tried first so they don't conflict with the
/// dollar-sign pattern.
class InlineLatexSyntax extends md.InlineSyntax {
  InlineLatexSyntax()
      // super.pattern accepts a single string; combine alternations.
      : super(
          '${parenInlineLatexPattern.pattern}|'
          '${bracketInlineLatexPattern.pattern}|'
          '${dollarInlineLatexPattern.pattern}',
        );

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    // Determine which capture group matched.
    if (match.group(1) != null) {
      // \( ... \)
      final element =
          md.Element('inlineLatex', [md.Text(match.group(1)!.trim())]);
      parser.addNode(element);
      return true;
    }
    if (match.group(2) != null) {
      // \[ ... \] - displayed math but inline context
      final element = md.Element('latex', [md.Text(match.group(2)!.trim())]);
      parser.addNode(element);
      return true;
    }
    if (match.group(3) != null) {
      // $ ... $
      final element =
          md.Element('inlineLatex', [md.Text(match.group(3)!.trim())]);
      parser.addNode(element);
      return true;
    }
    return false;
  }
}

// Custom element builder for inline LaTeX
class InlineLatexElementBuilder extends MarkdownElementBuilder {
  final TextStyle? textStyle;

  InlineLatexElementBuilder({this.textStyle});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final textContent = element.textContent;
    if (textContent.isEmpty) {
      return const SizedBox();
    }

    // Determine if this is a multi-line LaTeX expression by checking for newlines
    final bool isMultiLine = textContent.contains('\n');
    final mathStyle = isMultiLine ? MathStyle.display : MathStyle.text;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 50,
          maxWidth: 500,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: isMultiLine ? 8.0 : 4.0),
          child: Math.tex(
            textContent,
            textStyle: textStyle,
            mathStyle: mathStyle,
            onErrorFallback: (error) {
              debugPrint(
                  '\x1B[31m${Languages.inlineLatexErrorDebug} $error\x1B[0m');
              return Builder(
                builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\x1B[31m${Languages.latexErrorWidget} ${error.message}\x1B[0m',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // Display the original LaTeX code when there's an error
                      '\$\$$textContent\$\$',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Function to extend MarkdownParser with LaTeX support
extension MarkdownExtensions on MarkdownStyleSheet {
  static md.Document createLatexParser() {
    final document = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      blockSyntaxes: const [
        LatexBlockSyntax(),
        DoubleDollarLatexBlockSyntax(),
        BracketLatexBlockSyntax(),
      ],
      inlineSyntaxes: [InlineLatexSyntax()],
    );
    return document;
  }

  static Map<String, MarkdownElementBuilder> createLatexElementBuilders(
      {TextStyle? style}) {
    return {
      'latex': LatexElementBuilder(textStyle: style),
      'inlineLatex': InlineLatexElementBuilder(textStyle: style),
    };
  }
}
