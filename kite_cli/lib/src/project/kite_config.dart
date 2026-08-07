import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

final class KiteConfig {
  const KiteConfig({
    this.sourceDirectory = 'lib',
    this.featureDirectory = 'lib/features',
    this.architecture = 'clean',
    this.router = 'go_router',
    this.stateManagement = 'riverpod',
    this.formatAfterGeneration = true,
    this.installDependencies = true,
  });

  final String sourceDirectory;
  final String featureDirectory;
  final String architecture;
  final String router;
  final String stateManagement;
  final bool formatAfterGeneration;
  final bool installDependencies;

  factory KiteConfig.load(Directory projectRoot) {
    final file = File(p.join(projectRoot.path, 'kite.yaml'));
    if (!file.existsSync()) {
      return const KiteConfig();
    }

    final Object? document = loadYaml(file.readAsStringSync());
    if (document is! YamlMap) {
      throw const FormatException('kite.yaml is not valid YAML.');
    }

    final project = _map(document['project']);
    final architecture = _map(document['architecture']);
    final routing = _map(document['routing']);
    final stateManagement = _map(document['state_management']);
    final generation = _map(document['generation']);

    return KiteConfig(
      sourceDirectory: _string(project['source_directory'], 'lib'),
      featureDirectory: _string(
        architecture['feature_directory'],
        'lib/features',
      ),
      architecture: _string(architecture['type'], 'clean'),
      router: _string(routing['type'], 'go_router'),
      stateManagement: _string(stateManagement['type'], 'riverpod'),
      formatAfterGeneration: _boolean(
        generation['format_after_generation'],
        true,
      ),
      installDependencies: _boolean(generation['install_dependencies'], true),
    );
  }

  Map<String, Object?> toTemplateValues() => <String, Object?>{
    'sourceDirectory': sourceDirectory,
    'featureDirectory': featureDirectory,
    'architecture': architecture,
    'router': router,
    'stateManagement': stateManagement,
  };

  static Map<Object?, Object?> _map(Object? value) {
    return value is YamlMap ? value : const <Object?, Object?>{};
  }

  static String _string(Object? value, String fallback) {
    return value is String && value.trim().isNotEmpty ? value.trim() : fallback;
  }

  static bool _boolean(Object? value, bool fallback) {
    return value is bool ? value : fallback;
  }
}
