import 'dart:io';

final class FlutterProject {
  const FlutterProject({required this.root, required this.name});

  final Directory root;
  final String name;

  File get pubspecFile =>
      File('${root.path}${Platform.pathSeparator}pubspec.yaml');

  Directory get libDirectory =>
      Directory('${root.path}${Platform.pathSeparator}lib');
}
