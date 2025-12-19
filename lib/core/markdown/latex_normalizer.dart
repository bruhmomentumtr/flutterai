// lib/core/markdown/latex_normalizer.dart
// Normalizes different LaTeX formats to a standard format

/// Normalizes various LaTeX formats from different AI models to a standard format
///
/// Supported input formats:
/// - \( x \) → $ x $ (inline)
/// - \[ x \] → $$ x $$ (block)
/// - \begin{equation} ... \end{equation} → $$ ... $$
/// - \begin{align} ... \end{align} → $$ ... $$
/// - \begin{math} ... \end{math} → $ ... $
/// - [latex] ... [/latex] → $$ ... $$
class LatexNormalizer {
  // Regex patterns for different LaTeX formats
  static final RegExp _inlineParenLatex =
      RegExp(r'\\\((.+?)\\\)', dotAll: true);
  static final RegExp _blockBracketLatex =
      RegExp(r'\\\[(.+?)\\\]', dotAll: true);
  static final RegExp _equationLatex = RegExp(
    r'\\begin\{equation\}(.+?)\\end\{equation\}',
    dotAll: true,
  );
  static final RegExp _alignLatex = RegExp(
    r'\\begin\{align\*?\}(.+?)\\end\{align\*?\}',
    dotAll: true,
  );
  static final RegExp _mathLatex = RegExp(
    r'\\begin\{math\}(.+?)\\end\{math\}',
    dotAll: true,
  );
  static final RegExp _latexTag = RegExp(
    r'\[latex\](.+?)\[/latex\]',
    caseSensitive: false,
    dotAll: true,
  );
  static final RegExp _displayMathLatex = RegExp(
    r'\\begin\{displaymath\}(.+?)\\end\{displaymath\}',
    dotAll: true,
  );
  static final RegExp _gatherLatex = RegExp(
    r'\\begin\{gather\*?\}(.+?)\\end\{gather\*?\}',
    dotAll: true,
  );

  /// Normalize all LaTeX formats to standard $ and $$ delimiters
  String normalize(String content) {
    String result = content;

    // Convert \( x \) to $ x $ (inline math)
    result = result.replaceAllMapped(_inlineParenLatex, (match) {
      final latex = match.group(1)?.trim() ?? '';
      return '\$ $latex \$';
    });

    // Convert \[ x \] to $$ x $$ (display math)
    result = result.replaceAllMapped(_blockBracketLatex, (match) {
      final latex = match.group(1)?.trim() ?? '';
      return '\$\$ $latex \$\$';
    });

    // Convert \begin{equation} to $$
    result = result.replaceAllMapped(_equationLatex, (match) {
      final latex = _cleanLatexContent(match.group(1) ?? '');
      return '\$\$\n$latex\n\$\$';
    });

    // Convert \begin{align} to $$
    result = result.replaceAllMapped(_alignLatex, (match) {
      final latex = _cleanLatexContent(match.group(1) ?? '');
      return '\$\$\n$latex\n\$\$';
    });

    // Convert \begin{math} to $ (inline)
    result = result.replaceAllMapped(_mathLatex, (match) {
      final latex = match.group(1)?.trim() ?? '';
      return '\$ $latex \$';
    });

    // Convert \begin{displaymath} to $$
    result = result.replaceAllMapped(_displayMathLatex, (match) {
      final latex = _cleanLatexContent(match.group(1) ?? '');
      return '\$\$\n$latex\n\$\$';
    });

    // Convert \begin{gather} to $$
    result = result.replaceAllMapped(_gatherLatex, (match) {
      final latex = _cleanLatexContent(match.group(1) ?? '');
      return '\$\$\n$latex\n\$\$';
    });

    // Convert [latex] tags to $$
    result = result.replaceAllMapped(_latexTag, (match) {
      final latex = match.group(1)?.trim() ?? '';
      return '\$\$\n$latex\n\$\$';
    });

    return result;
  }

  /// Clean LaTeX content by removing unnecessary commands and whitespace
  String _cleanLatexContent(String latex) {
    String result = latex.trim();

    // Remove \nonumber commands
    result = result.replaceAll(RegExp(r'\\nonumber'), '');

    // Remove \label commands
    result = result.replaceAll(RegExp(r'\\label\{[^}]*\}'), '');

    // Clean up excessive whitespace but preserve line breaks
    result = result.replaceAll(RegExp(r'[ \t]+'), ' ');
    result = result.replaceAll(RegExp(r'\n\s*\n'), '\n');

    return result.trim();
  }

  /// Check if content contains any LaTeX that needs normalization
  bool needsNormalization(String content) {
    return _inlineParenLatex.hasMatch(content) ||
        _blockBracketLatex.hasMatch(content) ||
        _equationLatex.hasMatch(content) ||
        _alignLatex.hasMatch(content) ||
        _mathLatex.hasMatch(content) ||
        _latexTag.hasMatch(content) ||
        _displayMathLatex.hasMatch(content) ||
        _gatherLatex.hasMatch(content);
  }
}
