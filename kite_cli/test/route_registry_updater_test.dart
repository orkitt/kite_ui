import 'dart:io';

import 'package:kite_cli/src/generators/route_registry_updater.dart';
import 'package:test/test.dart';

void main() {
  test('legacy route layout receives a non-destructive migration message', () async {
    final root = await Directory.systemTemp.createTemp('kite_legacy_routes_');
    addTearDown(() => root.delete(recursive: true));
    final legacy = File('${root.path}/lib/app/router/generated_routes.dart');
    await legacy.parent.create(recursive: true);
    await legacy.writeAsString('// legacy generated route registry\n');

    expect(
      () => const RouteRegistryUpdater().ensureAvailable(
        projectRoot: root,
        sourceDirectory: 'lib',
      ),
      throwsA(
        predicate(
          (error) =>
              error.toString().contains('legacy feature-owned routing layout') &&
              error.toString().contains('will not delete existing'),
        ),
      ),
    );
  });
}
