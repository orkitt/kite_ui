import 'dart:io';

import 'package:path/path.dart' as p;

import '../generation/file_checksum.dart';
import '../generation/project_manifest.dart';
import '../naming/name_converter.dart';

final class RouteRegistryUpdater {
  const RouteRegistryUpdater({
    this.manifestStore = const ProjectManifestStore(),
  });

  final ProjectManifestStore manifestStore;

  void ensureAvailable({
    required Directory projectRoot,
    required String sourceDirectory,
  }) {
    final relativePath = _registryPath(sourceDirectory);
    final file = File(_absolutePath(projectRoot, relativePath));
    if (!file.existsSync()) {
      throw StateError(
        'Route registry not found. Run `kite init` before using --route.',
      );
    }
  }

  Future<void> addFeatureRoute({
    required Directory projectRoot,
    required NameConverter feature,
    required String sourceDirectory,
    required String featureDirectory,
    required String architecture,
  }) async {
    final registryRelativePath = _registryPath(sourceDirectory);
    final file = File(_absolutePath(projectRoot, registryRelativePath));
    if (!file.existsSync()) {
      throw StateError(
        'Route registry not found. Run `kite init` before using --route.',
      );
    }

    final routeDirectory = switch (architecture) {
      'clean' => const <String>['presentation', 'routes'],
      'mvc' => const <String>['routes'],
      _ => throw ArgumentError.value(
        architecture,
        'architecture',
        'Unsupported route architecture.',
      ),
    };
    final featureRoutePath = p.posix.joinAll(<String>[
      _portable(featureDirectory),
      feature.snakeCase,
      ...routeDirectory,
      '${feature.snakeCase}_routes.dart',
    ]);
    var importPath = p.posix.relative(
      featureRoutePath,
      from: p.posix.dirname(registryRelativePath),
    );
    if (!importPath.startsWith('.')) {
      importPath = './$importPath';
    }

    final importLine = "import '$importPath';";
    final routeLine = '  ...${feature.camelCase}Routes,';
    var content = await file.readAsString();
    content = _insertSorted(
      content,
      startMarker: '// KITE:IMPORTS:START',
      endMarker: '// KITE:IMPORTS:END',
      line: importLine,
    );
    content = _insertSorted(
      content,
      startMarker: '// KITE:ROUTES:START',
      endMarker: '// KITE:ROUTES:END',
      line: routeLine,
    );
    await file.writeAsString(content);

    await manifestStore.updateManagedChecksum(
      root: projectRoot,
      relativePath: registryRelativePath,
      checksum: FileChecksum.content(content),
    );
  }

  String _registryPath(String sourceDirectory) {
    return p.posix.join(
      _portable(sourceDirectory),
      'app',
      'router',
      'generated_routes.dart',
    );
  }

  String _absolutePath(Directory root, String relativePath) {
    return p.joinAll(<String>[root.path, ...p.posix.split(relativePath)]);
  }

  String _portable(String path) => path.replaceAll('\\', '/');

  String _insertSorted(
    String content, {
    required String startMarker,
    required String endMarker,
    required String line,
  }) {
    final start = content.indexOf(startMarker);
    final end = content.indexOf(endMarker);
    if (start < 0 || end < 0 || end <= start) {
      throw StateError('Kite route registry markers are missing.');
    }

    final bodyStart = start + startMarker.length;
    final currentBody = content.substring(bodyStart, end);
    final lines =
        currentBody
            .split('\n')
            .map((item) => item.trimRight())
            .where((item) => item.trim().isNotEmpty)
            .toSet()
          ..add(line);
    final sorted = lines.toList()..sort();
    final replacement = '\n${sorted.join('\n')}\n';
    return content.replaceRange(bodyStart, end, replacement);
  }
}
