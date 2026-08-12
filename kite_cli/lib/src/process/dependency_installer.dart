import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../logging/kite_logger.dart';
import '../templates/template_manifest.dart';
import 'process_runner.dart';

final class DependencyInstaller {
  const DependencyInstaller({
    this.processRunner = const ProcessRunner(),
    this.logger = const KiteLogger(),
  });

  final ProcessRunner processRunner;
  final KiteLogger logger;

  Future<void> install({
    required String projectPath,
    required TemplateManifest manifest,
    List<String> extraDependencies = const <String>[],
    List<String> extraDevDependencies = const <String>[],
  }) {
    return installPackages(
      projectPath: projectPath,
      dependencies: <String>{...manifest.dependencies, ...extraDependencies},
      devDependencies: <String>{
        ...manifest.devDependencies,
        ...extraDevDependencies,
      },
    );
  }

  Future<void> installPackages({
    required String projectPath,
    Iterable<String> dependencies = const <String>[],
    Iterable<String> devDependencies = const <String>[],
  }) async {
    final declared = _readDeclaredDependencies(projectPath);
    final runtimePackages = dependencies
        .where((package) => !declared.dependencies.contains(package))
        .toSet()
        .toList()
      ..sort();
    final developmentPackages = devDependencies
        .where(
          (package) =>
              !declared.dependencies.contains(package) &&
              !declared.devDependencies.contains(package),
        )
        .toSet()
        .toList()
      ..sort();

    if (runtimePackages.isNotEmpty) {
      logger.info('Installing Flutter dependencies...');
      await processRunner.runInherited(
        'flutter',
        <String>['pub', 'add', ...runtimePackages],
        workingDirectory: projectPath,
      );
    }

    if (developmentPackages.isNotEmpty) {
      logger.info('Installing development dependencies...');
      await processRunner.runInherited(
        'flutter',
        <String>['pub', 'add', '--dev', ...developmentPackages],
        workingDirectory: projectPath,
      );
    }
  }

  _DeclaredDependencies _readDeclaredDependencies(String projectPath) {
    final file = File(p.join(projectPath, 'pubspec.yaml'));
    if (!file.existsSync()) {
      return const _DeclaredDependencies();
    }

    final Object? document;
    try {
      document = loadYaml(file.readAsStringSync());
    } on Object {
      return const _DeclaredDependencies();
    }
    if (document is! YamlMap) {
      return const _DeclaredDependencies();
    }

    return _DeclaredDependencies(
      dependencies: _dependencyNames(document['dependencies']),
      devDependencies: _dependencyNames(document['dev_dependencies']),
    );
  }

  Set<String> _dependencyNames(Object? value) {
    if (value is! YamlMap) {
      return const <String>{};
    }
    return Set<String>.unmodifiable(
      value.keys.map((key) => key.toString()),
    );
  }
}

final class _DeclaredDependencies {
  const _DeclaredDependencies({
    this.dependencies = const <String>{},
    this.devDependencies = const <String>{},
  });

  final Set<String> dependencies;
  final Set<String> devDependencies;
}
