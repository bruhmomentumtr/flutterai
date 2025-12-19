// lib/core/markdown/markdown_normalizer.dart
// Main normalizer pipeline for markdown content

import 'latex_normalizer.dart';
import 'code_block_normalizer.dart';

/// Main normalizer that processes markdown content through multiple normalizers
///
/// Pipeline order:
/// 1. Code block normalization (to protect code from other transformations)
/// 2. LaTeX normalization
/// 3. Bold/Italic normalization
/// 4. Table normalization
/// 5. List normalization
class MarkdownNormalizer {
  final LatexNormalizer _latexNormalizer = LatexNormalizer();
  final CodeBlockNormalizer _codeBlockNormalizer = CodeBlockNormalizer();

  /// Normalize markdown content through the full pipeline
  String normalize(String content) {
    if (content.isEmpty) return content;

    String result = content;

    // Step 1: Protect and normalize code blocks first
    final codeBlocks = <String, String>{};
    result = _extractCodeBlocks(result, codeBlocks);

    // Step 2: Normalize LaTeX
    result = _latexNormalizer.normalize(result);

    // Step 3: Normalize bold/italic formats
    result = _normalizeBoldItalic(result);

    // Step 4: Normalize tables
    result = _normalizeTables(result);

    // Step 5: Normalize lists
    result = _normalizeLists(result);

    // Step 6: Clean up thinking tags from Claude
    result = _cleanThinkingTags(result);

    // Step 7: Restore code blocks
    result = _restoreCodeBlocks(result, codeBlocks);

    // Step 8: Apply code block normalization to restored blocks
    result = _codeBlockNormalizer.normalize(result);

    return result;
  }

  /// Extract code blocks and replace with placeholders
  String _extractCodeBlocks(String content, Map<String, String> codeBlocks) {
    int index = 0;
    return content.replaceAllMapped(
      RegExp(r'```[\s\S]*?```', multiLine: true),
      (match) {
        final placeholder = '___CODE_BLOCK_${index}_PLACEHOLDER___';
        codeBlocks[placeholder] = match.group(0)!;
        index++;
        return placeholder;
      },
    );
  }

  /// Restore code blocks from placeholders
  String _restoreCodeBlocks(String content, Map<String, String> codeBlocks) {
    String result = content;
    codeBlocks.forEach((placeholder, code) {
      result = result.replaceAll(placeholder, code);
    });
    return result;
  }

  /// Normalize bold and italic formats
  /// Handles Gemini's *text* format which should be **text** for bold
  String _normalizeBoldItalic(String content) {
    String result = content;

    // Don't touch content that's already using ** for bold
    if (result.contains('**')) {
      return result;
    }

    // Convert single asterisk bold to double asterisk (Gemini style)
    // Be careful not to convert list items
    result = result.replaceAllMapped(
      RegExp(r'(?<!\*)\*([^\*\n]+)\*(?!\*)', multiLine: true),
      (match) {
        final text = match.group(1) ?? '';
        // Don't convert if it looks like a list item or already has emphasis
        if (text.trim().isEmpty) return match.group(0)!;
        return '**$text**';
      },
    );

    return result;
  }

  /// Normalize table formats
  String _normalizeTables(String content) {
    // Fix tables without proper header separators
    final lines = content.split('\n');
    final result = <String>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      result.add(line);

      // Check if this looks like a table header row
      if (line.contains('|') && !line.contains('---')) {
        // Check if next line exists and is not a separator
        if (i + 1 < lines.length) {
          final nextLine = lines[i + 1];
          if (nextLine.contains('|') && !nextLine.contains('---')) {
            // Count columns in header
            final columns = '|'.allMatches(line).length - 1;
            if (columns > 0) {
              // Insert separator row
              final separator = '|${List.filled(columns, ' --- ').join('|')}|';
              result.add(separator);
            }
          }
        }
      }
    }

    return result.join('\n');
  }

  /// Normalize list formats
  String _normalizeLists(String content) {
    String result = content;

    // Convert various bullet styles to standard -
    result = result.replaceAllMapped(
      RegExp(r'^(\s*)[•●○◦▪▸►]\s+', multiLine: true),
      (match) {
        final indent = match.group(1) ?? '';
        return '$indent- ';
      },
    );

    // Ensure proper spacing after list markers
    result = result.replaceAllMapped(
      RegExp(r'^(\s*[-*+])(\S)', multiLine: true),
      (match) {
        final marker = match.group(1) ?? '-';
        final text = match.group(2) ?? '';
        return '$marker $text';
      },
    );

    return result;
  }

  /// Remove Claude's thinking tags
  String _cleanThinkingTags(String content) {
    // Remove <thinking>...</thinking> blocks (Claude internal reasoning)
    String result = content.replaceAll(
      RegExp(r'<thinking>[\s\S]*?</thinking>', caseSensitive: false),
      '',
    );

    // Remove <antThinking>...</antThinking> blocks
    result = result.replaceAll(
      RegExp(r'<antThinking>[\s\S]*?</antThinking>', caseSensitive: false),
      '',
    );

    // Clean up any resulting double newlines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return result.trim();
  }

  /// Check if content needs normalization
  bool needsNormalization(String content) {
    return _latexNormalizer.needsNormalization(content) ||
        _codeBlockNormalizer.needsNormalization(content) ||
        content.contains('<thinking>') ||
        content.contains('•') ||
        content.contains('●');
  }
}
