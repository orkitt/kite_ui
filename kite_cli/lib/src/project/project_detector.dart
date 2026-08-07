import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'flutter_project.dart';

final class ProjectDetectionException implements Exception {
  const ProjectDetectionException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class ProjectDetector {
  const ProjectDetector();

  FlutterProject detect(String path) {
    final root = Directory(p.normalize(p.absolute(path)));
    final pubspec = File(p.join(root.path, 'pubspec.yaml'));

    if (!root.existsSync() || !pubspec.existsSync()) {
      throw const ProjectDetectionException(
        'Kite must run inside a Flutter project containing pubspec.yaml.',
      );
    }

    final Object? document = loadYaml(pubspec.readAsStringSync());
    if (document is! YamlMap) {
      throw const ProjectDetectionException('pubspec.yaml is not valid YAML.');
    }

    final Object? nameValue = document['name'];
    final Object? dependenciesValue = document['dependencies'];

    if (nameValue is! String || nameValue.trim().isEmpty) {
      throw const ProjectDetectionException(
        'pubspec.yaml must contain a valid package name.',
      );
    }

    if (dependenciesValue is! YamlMap ||
        !dependenciesValue.containsKey('flutter')) {
      throw const ProjectDetectionException(
        'The detected package is not a Flutter application.',
      );
    }

    return FlutterProject(root: root, name: nameValue.trim());
  }
}
