// Default location: lib/widgets/markdown_latex_extension.dart
// Extension to enable LaTeX rendering in Markdown

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

// Custom syntax for LaTeX blocks
class LatexBlockSyntax extends md.BlockSyntax {
  static final _latexPattern = RegExp(r'^\s*\[\s*latex\s*\]([\s\S]*?)\[\s*\/\s*latex\s*\]');

  @override
  RegExp get pattern => _latexPattern;

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
  static final _doubleDollarPattern = RegExp(r'^\s*\$\$([\s\S]*?)\$\$\s*$', multiLine: true);

  @override
  RegExp get pattern => _doubleDollarPattern;

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
              debugPrint('LaTeX Error: $error');
              return Text(
                'Error rendering LaTeX: ${error.message}',
                style: TextStyle(color: Colors.red),
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

// Custom syntax for inline LaTeX
class InlineLatexSyntax extends md.InlineSyntax {
  static final _inlineLatexPattern = RegExp(r'\$\$([\s\S]*?)\$\$', multiLine: true);

  InlineLatexSyntax() : super(_inlineLatexPattern.pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final latexContent = match.group(1) ?? '';
    // Trim whitespace but preserve line breaks inside the LaTeX content
    final trimmedContent = latexContent.replaceAll(RegExp(r'^\s+|\s+$', multiLine: true), '');
    
    final element = md.Element('inlineLatex', [md.Text(trimmedContent)]);
    
    // Make sure we're not in a nested situation that could cause the _inlines issue
    parser.addNode(element);
    
    return true;
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
              debugPrint('Inline LaTeX Error: $error');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LaTeX Error: ${error.message}',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // Display the original LaTeX code when there's an error
                    '\$\$$textContent\$\$',
                    style: const TextStyle(
                      fontFamily: 'monospace', 
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
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
      blockSyntaxes: [
        const LatexBlockSyntax(),
        const DoubleDollarLatexBlockSyntax(),
      ],
      inlineSyntaxes: [InlineLatexSyntax()],
    );
    return document;
  }
  
  static Map<String, MarkdownElementBuilder> createLatexElementBuilders({TextStyle? style}) {
    return {
      'latex': LatexElementBuilder(textStyle: style),
      'inlineLatex': InlineLatexElementBuilder(textStyle: style),
    };
  }
} 