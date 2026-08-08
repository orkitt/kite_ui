import 'dart:io';

import 'package:kite_cli/src/project/kite_config.dart';
import 'package:test/test.dart';

void main() {
  test('loads typed shell and route configuration', () async {
    final root = await Directory.systemTemp.createTemp('kite_config_');
    addTearDown(() => root.delete(recursive: true));
    await File('${root.path}/kite.yaml').writeAsString('''
schema_version: 1
project:
  preset: clean
  source_directory: lib
architecture:
  type: clean
  feature_directory: lib/features
routing:
  type: go_router
  auto_register_features: true
  shell:
    enabled: true
    branches:
      - name: home
        path: /
      - name: blog
        path: /blog
  routes:
    - feature: details
      path: /blog/details
      segment: details
      branch: blog
      architecture: clean
''');

    final config = KiteConfig.load(root);
    expect(config.routing.shell.enabled, isTrue);
    expect(config.routing.shell.branches.length, 2);
    expect(config.routing.routes.single.path, '/blog/details');
    expect(config.routing.routes.single.branch, 'blog');
  });

  test('rejects invalid shell branch paths', () async {
    final root = await Directory.systemTemp.createTemp('kite_bad_config_');
    addTearDown(() => root.delete(recursive: true));
    await File('${root.path}/kite.yaml').writeAsString('''
routing:
  shell:
    enabled: true
    branches:
      - name: blog
        path: blog
''');

    expect(() => KiteConfig.load(root), throwsA(isA<FormatException>()));
  });
}
