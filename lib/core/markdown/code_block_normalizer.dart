// lib/core/markdown/code_block_normalizer.dart
// Normalizes code blocks from different AI model formats

/// Normalizes code block formats from different sources
///
/// Handles:
/// - Missing language tags (adds 'text' as default)
/// - Incorrect closing markers
/// - XML-style code blocks from Claude
/// - Nested code blocks
class CodeBlockNormalizer {
  // Regex patterns
  static final RegExp _codeBlockWithLang = RegExp(
    r'```(\w+)?\n([\s\S]*?)```',
    multiLine: true,
  );
  static final RegExp _xmlCodeBlock = RegExp(
    r'<code(?:\s+lang="(\w+)")?>(.+?)</code>',
    dotAll: true,
  );
  static final RegExp _preBlock = RegExp(
    r'<pre>(.+?)</pre>',
    dotAll: true,
  );
  static final RegExp _unclosedCodeBlock = RegExp(
    r'```(\w+)?\n([\s\S]*)$',
  );

  /// Common language aliases mapping
  static const Map<String, String> _languageAliases = {
    'js': 'javascript',
    'ts': 'typescript',
    'py': 'python',
    'rb': 'ruby',
    'cs': 'csharp',
    'cpp': 'cpp',
    'c++': 'cpp',
    'sh': 'bash',
    'shell': 'bash',
    'yml': 'yaml',
    'md': 'markdown',
  };

  /// Normalize all code block formats
  String normalize(String content) {
    String result = content;

    // Fix code blocks without language specification
    result = _addMissingLanguageTags(result);

    // Convert XML-style code blocks
    result = _convertXmlCodeBlocks(result);

    // Convert <pre> blocks
    result = _convertPreBlocks(result);

    // Fix unclosed code blocks
    result = _fixUnclosedCodeBlocks(result);

    // Normalize language names
    result = _normalizeLanguageNames(result);

    return result;
  }

  /// Add 'text' language tag to code blocks without language specification
  String _addMissingLanguageTags(String content) {
    // Match code blocks that start with ``` followed by newline (no language)
    return content.replaceAllMapped(
      RegExp(r'```\n([\s\S]*?)```', multiLine: true),
      (match) {
        final code = match.group(1) ?? '';
        final detectedLang = _detectLanguage(code);
        return '```$detectedLang\n$code```';
      },
    );
  }

  /// Convert XML-style <code> blocks to markdown code blocks
  String _convertXmlCodeBlocks(String content) {
    return content.replaceAllMapped(_xmlCodeBlock, (match) {
      final lang = match.group(1) ?? 'text';
      final code = match.group(2) ?? '';
      return '```$lang\n$code\n```';
    });
  }

  /// Convert <pre> blocks to markdown code blocks
  String _convertPreBlocks(String content) {
    return content.replaceAllMapped(_preBlock, (match) {
      final code = match.group(1) ?? '';
      final detectedLang = _detectLanguage(code);
      return '```$detectedLang\n$code\n```';
    });
  }

  /// Fix unclosed code blocks by adding closing markers
  String _fixUnclosedCodeBlocks(String content) {
    if (_unclosedCodeBlock.hasMatch(content)) {
      // Check if we have an odd number of ``` markers
      final matches = '```'.allMatches(content).length;
      if (matches % 2 != 0) {
        // Add closing marker
        return '$content\n```';
      }
    }
    return content;
  }

  /// Normalize language names to standard format
  String _normalizeLanguageNames(String content) {
    return content.replaceAllMapped(_codeBlockWithLang, (match) {
      final lang = match.group(1)?.toLowerCase() ?? 'text';
      final code = match.group(2) ?? '';
      final normalizedLang = _languageAliases[lang] ?? lang;
      return '```$normalizedLang\n$code```';
    });
  }

  /// Try to detect language from code content
  String _detectLanguage(String code) {
    final trimmed = code.trim();

    // Python indicators
    if (trimmed.contains('def ') ||
        trimmed.contains('import ') ||
        trimmed.contains('print(')) {
      return 'python';
    }

    // JavaScript/TypeScript indicators
    if (trimmed.contains('const ') ||
        trimmed.contains('let ') ||
        trimmed.contains('=>') ||
        trimmed.contains('function ')) {
      return 'javascript';
    }

    // Dart indicators
    if (trimmed.contains('void main') ||
        trimmed.contains('Widget ') ||
        trimmed.contains('@override')) {
      return 'dart';
    }

    // JSON
    if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
      return 'json';
    }

    // HTML
    if (trimmed.contains('<html') ||
        trimmed.contains('<div') ||
        trimmed.contains('</')) {
      return 'html';
    }

    // CSS
    if (trimmed.contains('{') &&
        (trimmed.contains('color:') ||
            trimmed.contains('margin:') ||
            trimmed.contains('padding:'))) {
      return 'css';
    }

    // Shell/Bash
    if (trimmed.startsWith(r'$') ||
        trimmed.startsWith('#!') ||
        trimmed.contains('echo ')) {
      return 'bash';
    }

    // SQL
    if (trimmed.toUpperCase().contains('SELECT ') ||
        trimmed.toUpperCase().contains('INSERT ') ||
        trimmed.toUpperCase().contains('CREATE TABLE')) {
      return 'sql';
    }

    return 'text';
  }

  /// Check if content contains code blocks that need normalization
  bool needsNormalization(String content) {
    return _xmlCodeBlock.hasMatch(content) ||
        _preBlock.hasMatch(content) ||
        content.contains('```\n'); // Code block without language
  }
}
