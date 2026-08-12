import '../naming/name_converter.dart';

final class ShellDefinition {
  const ShellDefinition({required this.branches});

  final List<ShellBranchDefinition> branches;
}

final class ShellBranchDefinition {
  const ShellBranchDefinition({
    required this.name,
    required this.path,
    required this.camelName,
    required this.pascalName,
    required this.snakeName,
  });

  final String name;
  final String path;
  final String camelName;
  final String pascalName;
  final String snakeName;
}

final class ShellDefinitionParser {
  const ShellDefinitionParser();

  ShellDefinition parse(String input) {
    var normalized = input.trim();
    if (normalized.startsWith('[') || normalized.endsWith(']')) {
      if (!(normalized.startsWith('[') && normalized.endsWith(']'))) {
        throw const FormatException(
          'Invalid --shell value. Use "home,blog,profile" or "[home,blog,profile]".',
        );
      }
      normalized = normalized.substring(1, normalized.length - 1).trim();
    }

    if (normalized.isEmpty) {
      throw const FormatException('--shell requires at least one branch.');
    }

    final rawBranches = normalized.split(',').map((item) => item.trim()).toList();
    if (rawBranches.any((item) => item.isEmpty)) {
      throw const FormatException('Shell branch names cannot be empty.');
    }

    final seen = <String>{};
    final branches = <ShellBranchDefinition>[];
    for (var index = 0; index < rawBranches.length; index++) {
      final raw = rawBranches[index];
      final converter = NameConverter(raw);
      final canonicalName = converter.kebabCase;
      if (canonicalName == 'root') {
        throw const FormatException(
          'Shell branch "root" is reserved for root-level routes.',
        );
      }
      if (!seen.add(canonicalName)) {
        throw FormatException('Duplicate shell branch "$canonicalName".');
      }

      branches.add(
        ShellBranchDefinition(
          name: canonicalName,
          path: index == 0 ? '/' : '/${converter.kebabCase}',
          camelName: converter.camelCase,
          pascalName: converter.pascalCase,
          snakeName: converter.snakeCase,
        ),
      );
    }

    return ShellDefinition(
      branches: List<ShellBranchDefinition>.unmodifiable(branches),
    );
  }
}
