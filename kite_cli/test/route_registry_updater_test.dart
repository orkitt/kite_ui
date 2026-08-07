import 'dart:io';

import 'package:kite/src/generators/route_registry_updater.dart';
import 'package:kite/src/naming/name_converter.dart';
import 'package:test/test.dart';

void main() {
  Future<File> createRegistry(Directory root) async {
    final registry = File(
      '${root.path}/lib/app/router/generated_routes.dart',
    );
    await registry.parent.create(recursive: true);
    await registry.writeAsString('''
import 'package:go_router/go_router.dart';

// KITE:IMPORTS:START
// KITE:IMPORTS:END

final List<RouteBase> generatedRoutes = <RouteBase>[
  // KITE:ROUTES:START
  // KITE:ROUTES:END
];
''');
    return registry;
  }

  test('registers a clean feature route idempotently', () async {
    final root = await Directory.systemTemp.createTemp('kite_routes_');
    addTearDown(() => root.delete(recursive: true));
    final registry = await createRegistry(root);

    const updater = RouteRegistryUpdater();
    final feature = NameConverter('User Profile');
    for (var index = 0; index < 2; index++) {
      await updater.addFeatureRoute(
        projectRoot: root,
        feature: feature,
        sourceDirectory: 'lib',
        featureDirectory: 'lib/features',
        architecture: 'clean',
      );
    }

    final output = await registry.readAsString();
    expect(
      RegExp(
        RegExp.escape(
          "import '../../features/user_profile/presentation/routes/"
          "user_profile_routes.dart';",
        ),
      ).allMatches(output).length,
      1,
    );
    expect(
      RegExp(RegExp.escape('  ...userProfileRoutes,'))
          .allMatches(output)
          .length,
      1,
    );
  });

  test('registers an MVC feature route from its route folder', () async {
    final root = await Directory.systemTemp.createTemp('kite_mvc_routes_');
    addTearDown(() => root.delete(recursive: true));
    final registry = await createRegistry(root);

    await const RouteRegistryUpdater().addFeatureRoute(
      projectRoot: root,
      feature: NameConverter('Dashboard'),
      sourceDirectory: 'lib',
      featureDirectory: 'lib/features',
      architecture: 'mvc',
    );

    final output = await registry.readAsString();
    expect(
      output,
      contains("import '../../features/dashboard/routes/dashboard_routes.dart';"),
    );
  });
}
