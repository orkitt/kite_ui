final class InvalidNameException implements Exception {
  const InvalidNameException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class NameConverter {
  NameConverter(String input) : words = _parseWords(input) {
    if (words.isEmpty) {
      throw const InvalidNameException(
        'The name must contain at least one letter.',
      );
    }

    if (RegExp(r'^[0-9]').hasMatch(words.first)) {
      throw const InvalidNameException('The name cannot start with a number.');
    }

    if (_reservedWords.contains(camelCase)) {
      throw InvalidNameException('"$camelCase" is a reserved Dart keyword.');
    }
  }

  final List<String> words;

  String get snakeCase => words.join('_');

  String get kebabCase => words.join('-');

  String get camelCase => words.first + words.skip(1).map(_capitalize).join();

  String get pascalCase => words.map(_capitalize).join();

  String get titleCase => words.map(_capitalize).join(' ');

  static List<String> _parseWords(String input) {
    final separated = input
        .trim()
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '')
        .toLowerCase();

    if (separated.isEmpty) {
      return const <String>[];
    }

    return List<String>.unmodifiable(separated.split('_'));
  }

  static String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static const Set<String> _reservedWords = <String>{
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'of',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };
}
