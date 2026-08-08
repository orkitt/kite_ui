import 'dart:io';

import 'package:path/path.dart' as p;

import '../generation/file_checksum.dart';
import '../generation/project_manifest.dart';
import '../naming/name_converter.dart';
import '../project/kite_config.dart';

final class AppRoutesUpdater {
  const AppRoutesUpdater({
    this.manifestStore = const ProjectManifestStore(),
  });

  static const String startMarker = '// kite:routes:start';
  static const String endMarker = '// kite:routes:end';

  final ProjectManifestStore manifestStore;

  String buildContent({
    required String currentContent,
    required KiteRoutingConfig routing,
  }) {
    final start = currentContent.indexOf(startMarker);
    final end = currentContent.indexOf(endMarker);
    if (start < 0 || end < 0 || end <= start) {
      throw StateError(
        'AppRoutes managed markers are missing. This project uses the legacy '
        'Kite routing layout. Add `$startMarker` and `$endMarker` inside '
        'AppRoutes (or re-run `kite init --force`) before generating new '
        'central routes. Existing feature route files will not be deleted.',
      );
    }

    final managedStart = start + startMarker.length;
    final outsideContent = currentContent.replaceRange(managedStart, end, '');
    final outsideConstants = _readConstants(outsideContent);
    final desired = _buildManagedConstants(routing);

    for (final entry in desired.entries.toList(growable: false)) {
      final existing = outsideConstants[entry.key];
      if (existing == null) {
        continue;
      }
      if (_normalizeExpression(existing) != _normalizeExpression(entry.value)) {
        throw StateError(
          'Route constant `${entry.key}` already exists outside Kite\'s managed '
          'section with a different value.',
        );
      }
      desired.remove(entry.key);
    }

    final lines = desired.entries
        .map(
          (entry) => '  static const String ${entry.key} = ${entry.value};',
        )
        .toList(growable: false);
    final replacement = lines.isEmpty ? '\n  ' : '\n${lines.join('\n')}\n  ';
    return currentContent.replaceRange(managedStart, end, replacement);
  }

  Future<void> update({
    required Directory projectRoot,
    required String sourceDirectory,
    required KiteRoutingConfig routing,
    required bool dryRun,
  }) async {
    final relativePath = p.posix.join(
      _portable(sourceDirectory),
      'app',
      'router',
      'app_routes.dart',
    );
    final file = File(_absolutePath(projectRoot, relativePath));
    if (!file.existsSync()) {
      throw StateError(
        'AppRoutes not found. Run `kite init` before generating routes.',
      );
    }

    final current = await file.readAsString();
    final updated = buildContent(currentContent: current, routing: routing);
    if (dryRun || current == updated) {
      return;
    }

    await file.writeAsString(updated);
    await manifestStore.updateManagedChecksum(
      root: projectRoot,
      relativePath: relativePath,
      checksum: FileChecksum.content(updated),
    );
  }

  Map<String, String> _buildManagedConstants(KiteRoutingConfig routing) {
    final constants = <String, String>{};

    for (final branch in routing.shell.branches) {
      final converter = NameConverter(branch.name);
      _addConstant(
        constants,
        name: converter.camelCase,
        expression: "'${branch.path}'",
        source: 'shell branch `${branch.name}`',
      );
    }

    final branchesByName = <String, KiteShellBranchConfig>{
      for (final branch in routing.shell.branches) branch.name: branch,
    };
    for (final route in routing.routes) {
      final feature = NameConverter(route.feature);
      if (route.branch == 'root') {
        _addConstant(
          constants,
          name: feature.camelCase,
          expression: "'${route.path}'",
          source: 'route `${route.path}`',
        );
        continue;
      }

      final branch = branchesByName[route.branch];
      if (branch == null) {
        throw StateError(
          'Route `${route.path}` references unknown shell branch '
          '`${route.branch}` in kite.yaml.',
        );
      }
      final branchName = NameConverter(branch.name);
      final constantName = '${branchName.camelCase}${feature.pascalCase}';
      final parentConstant = branchName.camelCase;
      final prefix = branch.path == '/'
          ? r'${' + parentConstant + '}'
          : r'$' + parentConstant + '/';
      final expression = branch.path == '/'
          ? "'$prefix${route.segment}'"
          : "'$prefix${route.segment}'";
      _addConstant(
        constants,
        name: constantName,
        expression: expression,
        source: 'route `${route.path}`',
      );
    }

    return constants;
  }

  void _addConstant(
    Map<String, String> constants, {
    required String name,
    required String expression,
    required String source,
  }) {
    final previous = constants[name];
    if (previous != null && _normalizeExpression(previous) != _normalizeExpression(expression)) {
      throw StateError(
        'Route constant `$name` collides while generating $source.',
      );
    }
    constants[name] = expression;
  }

  Map<String, String> _readConstants(String content) {
    final result = <String, String>{};
    final pattern = RegExp(
      r'static\s+const\s+String\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([^;]+);',
    );
    for (final match in pattern.allMatches(content)) {
      result[match.group(1)!] = match.group(2)!.trim();
    }
    return result;
  }

  String _normalizeExpression(String expression) {
    return expression.replaceAll(RegExp(r'\s+'), '');
  }

  String _absolutePath(Directory root, String relativePath) {
    return p.joinAll(<String>[root.path, ...p.posix.split(relativePath)]);
  }

  String _portable(String path) => path.replaceAll('\\', '/');
}
