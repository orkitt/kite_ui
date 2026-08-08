import 'dart:io';

import 'package:kite_cli/src/generation/conflict_strategy.dart';
import 'package:kite_cli/src/generators/generation_options.dart';
import 'package:kite_cli/src/generators/project_generator.dart';
import 'package:kite_cli/src/generators/sync_generator.dart';
import 'package:kite_cli/src/project/flutter_project.dart';
import 'package:kite_cli/src/project/kite_config.dart';
import 'package:kite_cli/src/routing/shell_definition.dart';
import 'package:test/test.dart';

void main() {
  const options = GenerationOptions(
    conflictStrategy: ConflictStrategy.overwrite,
    dryRun: false,
    installDependencies: false,
    format: false,
  );

  Future<FlutterProject> createShellProject() async {
    final root = await Directory.systemTemp.createTemp('kite_sync_');
    addTearDown(() => root.delete(recursive: true));
    await Directory('${root.path}/lib').create(recursive: true);
    await File('${root.path}/pubspec.yaml').writeAsString('''
name: my_kite_app
environment:
  sdk: '>=3.8.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
''');
    final project = FlutterProject(root: root, name: 'my_kite_app');
    await const ProjectGenerator().generate(
      project: project,
      shellDefinition: const ShellDefinitionParser().parse(
        '[home,blog,settings]',
      ),
      options: options,
    );
    return project;
  }

  test('shell init bootstraps branch root features', () async {
    final project = await createShellProject();

    for (final feature in <String>['home', 'blog', 'settings']) {
      expect(
        File(
          '${project.root.path}/lib/features/$feature/presentation/screens/'
          '${feature}_screen.dart',
        ).existsSync(),
        isTrue,
      );
    }

    final homeBranch = await File(
      '${project.root.path}/lib/app/router/generated/branches/home_branch.dart',
    ).readAsString();
    expect(homeBranch, contains('HomeScreen'));
    expect(
      homeBranch,
      contains('features/home/presentation/screens/home_screen.dart'),
    );
    expect(homeBranch, isNot(contains('AppStartupView')));

    final config = KiteConfig.load(project.root);
    expect(config.routing.routes, isEmpty);
    expect(config.routing.shell.branches.first.feature, 'home');
  });

  test('project name is rendered into AppConstants', () async {
    final project = await createShellProject();
    final constants = await File(
      '${project.root.path}/lib/core/constants/app_constants.dart',
    ).readAsString();

    expect(constants, contains("static const String appName = 'My Kite App';"));
    expect(
      constants,
      contains("static const String packageName = 'my_kite_app';"),
    );
  });

  test(
    'clean foundation includes preferences theme provider and changer',
    () async {
      final project = await createShellProject();

      expect(
        File(
          '${project.root.path}/lib/core/constants/app_storage_keys.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/core/constants/app_environment.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/core/preferences/app_preferences.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/core/preferences/shared_preferences_app_preferences.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/core/preferences/app_preferences_provider.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/core/theme/theme_mode_provider.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/shared/widgets/theme_changer.dart',
        ).existsSync(),
        isTrue,
      );
    },
  );

  test(
    'sync creates a YAML-added hidden branch feature without navbar item',
    () async {
      final project = await createShellProject();
      final yaml = File('${project.root.path}/kite.yaml');
      final before = await yaml.readAsString();
      final updated = before.replaceFirst(
        '  routes: []',
        '''      - name: checkout
        path: /checkout
        feature: checkout
        architecture: clean
        navigation:
          visible: false
          label: Checkout
  routes: []''',
      );
      await yaml.writeAsString(updated);

      await const SyncGenerator().sync(project: project, options: options);

      expect(
        File(
          '${project.root.path}/lib/features/checkout/presentation/screens/'
          'checkout_screen.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${project.root.path}/lib/app/router/generated/branches/'
          'checkout_branch.dart',
        ).existsSync(),
        isTrue,
      );

      final shell = await File(
        '${project.root.path}/lib/app/router/app_shell.dart',
      ).readAsString();
      expect(shell, isNot(contains("label: 'Checkout'")));
      expect(shell, contains('visibleBranchIndexes'));
      expect(shell, contains('selectedNavigationIndex < 0'));
    },
  );

  test(
    'sync fills a partial branch feature without overwriting its code',
    () async {
      final project = await createShellProject();
      final yaml = File('${project.root.path}/kite.yaml');
      final before = await yaml.readAsString();
      await yaml.writeAsString(
        before.replaceFirst('  routes: []', '''      - name: checkout
        path: /checkout
        feature: checkout
        architecture: clean
        navigation:
          visible: false
  routes: []'''),
      );

      final feature = Directory('${project.root.path}/lib/features/checkout');
      await feature.create(recursive: true);
      final developerFile = File('${feature.path}/developer_notes.dart');
      await developerFile.writeAsString('const keepMe = true;\n');

      await const SyncGenerator().sync(project: project, options: options);

      expect(await developerFile.readAsString(), 'const keepMe = true;\n');
      expect(
        File(
          '${feature.path}/presentation/screens/checkout_screen.dart',
        ).existsSync(),
        isTrue,
      );
    },
  );

  test(
    'sync updates derived child route paths after branch path change',
    () async {
      final project = await createShellProject();
      final configStore = const KiteConfigStore();
      final config = KiteConfig.load(project.root);
      await configStore.writeRouting(
        projectRoot: project.root,
        routing: config.routing.copyWith(
          routes: const <KiteRouteConfig>[
            KiteRouteConfig(
              feature: 'details',
              path: '/blog/details',
              segment: 'details',
              branch: 'blog',
            ),
          ],
        ),
      );

      await Directory(
        '${project.root.path}/lib/features/details/presentation/screens',
      ).create(recursive: true);
      await File(
        '${project.root.path}/lib/features/details/presentation/screens/details_screen.dart',
      ).writeAsString('class DetailsScreen { const DetailsScreen(); }\n');

      final yaml = File('${project.root.path}/kite.yaml');
      await yaml.writeAsString(
        (await yaml.readAsString()).replaceFirst(
          'path: /blog',
          'path: /articles',
        ),
      );

      await const SyncGenerator().sync(project: project, options: options);

      final synced = KiteConfig.load(project.root);
      expect(synced.routing.routes.single.path, '/articles/details');
      final appRoutes = await File(
        '${project.root.path}/lib/app/router/app_routes.dart',
      ).readAsString();
      expect(appRoutes, contains("static const String blog = '/articles';"));
      expect(
        appRoutes,
        contains("static const String blogDetails = '\$blog/details';"),
      );
    },
  );

  test('sync removes stale generated branch but preserves its feature', () async {
    final project = await createShellProject();
    final yaml = File('${project.root.path}/kite.yaml');
    final initial = await yaml.readAsString();
    await yaml.writeAsString(
      initial.replaceFirst('  routes: []', '''      - name: checkout
        path: /checkout
        feature: checkout
        architecture: clean
        navigation:
          visible: false
  routes: []'''),
    );
    await const SyncGenerator().sync(project: project, options: options);

    final checkoutFeature = Directory(
      '${project.root.path}/lib/features/checkout',
    );
    final checkoutBranch = File(
      '${project.root.path}/lib/app/router/generated/branches/checkout_branch.dart',
    );
    expect(checkoutFeature.existsSync(), isTrue);
    expect(checkoutBranch.existsSync(), isTrue);

    await yaml.writeAsString(initial);
    await const SyncGenerator().sync(project: project, options: options);

    expect(checkoutFeature.existsSync(), isTrue);
    expect(checkoutBranch.existsSync(), isFalse);
  });

  test(
    'sync dry run leaves YAML routes and generated files untouched',
    () async {
      final project = await createShellProject();
      final yaml = File('${project.root.path}/kite.yaml');
      final generated = File(
        '${project.root.path}/lib/app/router/generated/generated_routes.dart',
      );
      final beforeYaml = await yaml.readAsString();
      final beforeGenerated = await generated.readAsString();

      await const SyncGenerator().sync(
        project: project,
        options: GenerationOptions(
          conflictStrategy: ConflictStrategy.overwrite,
          dryRun: true,
          installDependencies: false,
          format: false,
        ),
      );

      expect(await yaml.readAsString(), beforeYaml);
      expect(await generated.readAsString(), beforeGenerated);
    },
  );

  test('sync is idempotent', () async {
    final project = await createShellProject();
    await const SyncGenerator().sync(project: project, options: options);

    final yaml = File('${project.root.path}/kite.yaml');
    final routes = File(
      '${project.root.path}/lib/app/router/generated/generated_routes.dart',
    );
    final shell = File('${project.root.path}/lib/app/router/app_shell.dart');
    final before = <String>[
      await yaml.readAsString(),
      await routes.readAsString(),
      await shell.readAsString(),
    ];

    await const SyncGenerator().sync(project: project, options: options);

    expect(<String>[
      await yaml.readAsString(),
      await routes.readAsString(),
      await shell.readAsString(),
    ], before);
  });
}
