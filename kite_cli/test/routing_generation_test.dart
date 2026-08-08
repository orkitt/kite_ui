import 'dart:io';

import 'package:kite_cli/src/generation/conflict_strategy.dart';
import 'package:kite_cli/src/generators/feature_generator.dart';
import 'package:kite_cli/src/generators/generation_options.dart';
import 'package:kite_cli/src/generators/project_generator.dart';
import 'package:kite_cli/src/project/flutter_project.dart';
import 'package:kite_cli/src/project/kite_config.dart';
import 'package:kite_cli/src/routing/route_target.dart';
import 'package:kite_cli/src/routing/shell_definition.dart';
import 'package:test/test.dart';

void main() {
  const generationOptions = GenerationOptions(
    conflictStrategy: ConflictStrategy.overwrite,
    dryRun: false,
    installDependencies: false,
    format: false,
  );

  Future<FlutterProject> createProject({bool shell = true}) async {
    final root = await Directory.systemTemp.createTemp('kite_routing_');
    addTearDown(() => root.delete(recursive: true));
    await Directory('${root.path}/lib').create(recursive: true);
    await File('${root.path}/pubspec.yaml').writeAsString('''
name: routing_test
environment:
  sdk: '>=3.8.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
''');
    final project = FlutterProject(root: root, name: 'routing_test');
    await const ProjectGenerator().generate(
      project: project,
      shellDefinition: shell
          ? const ShellDefinitionParser().parse('[home,blog,profile]')
          : null,
      options: generationOptions,
    );
    return project;
  }

  test('shell init persists branches and generates StatefulShellRoute', () async {
    final project = await createProject();
    final config = KiteConfig.load(project.root);

    expect(config.routing.shell.enabled, isTrue);
    expect(config.routing.shell.branches.map((item) => item.path), <String>[
      '/',
      '/blog',
      '/profile',
    ]);

    final generated = File(
      '${project.root.path}/lib/app/router/generated/generated_routes.dart',
    );
    expect(
      await generated.readAsString(),
      contains('StatefulShellRoute.indexedStack'),
    );
    expect(
      File(
        '${project.root.path}/lib/app/router/generated/branches/blog_branch.dart',
      ).existsSync(),
      isTrue,
    );
    expect(
      File('${project.root.path}/lib/app/router/app_shell.dart').existsSync(),
      isTrue,
    );
  });

  test('generates root route centrally without feature-owned routes', () async {
    final project = await createProject(shell: false);

    await const FeatureGenerator().generate(
      project: project,
      featureName: 'about',
      architecture: 'clean',
      includeRoute: true,
      includeJsonSerialization: false,
      options: generationOptions,
    );

    final config = KiteConfig.load(project.root);
    expect(config.routing.routes.single.path, '/about');
    expect(config.routing.routes.single.branch, 'root');
    expect(
      File(
        '${project.root.path}/lib/app/router/generated/features/about_route.dart',
      ).existsSync(),
      isTrue,
    );
    expect(
      File(
        '${project.root.path}/lib/features/about/presentation/routes',
      ).existsSync(),
      isFalse,
    );
    final rootRoutes = await File(
      '${project.root.path}/lib/app/router/generated/root_routes.dart',
    ).readAsString();
    expect(rootRoutes, contains('aboutRoute(path: AppRoutes.about)'));
  });

  test('generates clean feature route inside configured branch', () async {
    final project = await createProject();

    await const FeatureGenerator().generate(
      project: project,
      featureName: 'details',
      architecture: 'clean',
      includeRoute: true,
      routeTarget: RouteTarget.branch('blog'),
      includeJsonSerialization: false,
      options: generationOptions,
    );

    final config = KiteConfig.load(project.root);
    final route = config.routing.routes.single;
    expect(route.path, '/blog/details');
    expect(route.segment, 'details');
    expect(route.branch, 'blog');

    final appRoutes = await File(
      '${project.root.path}/lib/app/router/app_routes.dart',
    ).readAsString();
    expect(
      RegExp(
        RegExp.escape("static const String blogDetails = '\$blog/details';"),
      ).allMatches(appRoutes).length,
      1,
    );

    final branch = await File(
      '${project.root.path}/lib/app/router/generated/branches/blog_branch.dart',
    ).readAsString();
    expect(branch, contains('AppRoutes.blogDetails'));
    expect(branch, contains('detailsRoute('));
    expect(branch, isNot(contains("path: '/blog/details'")));
  });

  test('unknown branch fails before generating the feature', () async {
    final project = await createProject();

    await expectLater(
      const FeatureGenerator().generate(
        project: project,
        featureName: 'details',
        architecture: 'clean',
        includeRoute: true,
        routeTarget: RouteTarget.branch('missing'),
        includeJsonSerialization: false,
        options: generationOptions,
      ),
      throwsA(
        predicate(
          (error) =>
              error.toString().contains(
                'Shell branch "missing" does not exist',
              ) &&
              error.toString().contains('home') &&
              error.toString().contains('blog') &&
              error.toString().contains('profile'),
        ),
      ),
    );
    expect(
      Directory('${project.root.path}/lib/features/details').existsSync(),
      isFalse,
    );
  });

  test('MVC uses the same central branch routing flow', () async {
    final project = await createProject();

    await const FeatureGenerator().generate(
      project: project,
      featureName: 'account',
      architecture: 'mvc',
      includeRoute: true,
      routeTarget: RouteTarget.branch('profile'),
      includeJsonSerialization: false,
      options: generationOptions,
    );

    final config = KiteConfig.load(project.root);
    expect(config.routing.routes.single.path, '/profile/account');
    final routeFile = await File(
      '${project.root.path}/lib/app/router/generated/features/account_route.dart',
    ).readAsString();
    expect(
      routeFile,
      contains('features/account/views/screens/account_screen.dart'),
    );
    expect(
      Directory(
        '${project.root.path}/lib/features/account/routes',
      ).existsSync(),
      isFalse,
    );
  });

  test('dry run does not modify routing files or kite.yaml', () async {
    final project = await createProject();
    final yamlFile = File('${project.root.path}/kite.yaml');
    final appRoutesFile = File(
      '${project.root.path}/lib/app/router/app_routes.dart',
    );
    final generatedFile = File(
      '${project.root.path}/lib/app/router/generated/generated_routes.dart',
    );
    final beforeYaml = await yamlFile.readAsString();
    final beforeAppRoutes = await appRoutesFile.readAsString();
    final beforeGenerated = await generatedFile.readAsString();

    await const FeatureGenerator().generate(
      project: project,
      featureName: 'preview',
      architecture: 'clean',
      includeRoute: true,
      routeTarget: RouteTarget.branch('blog'),
      includeJsonSerialization: false,
      options: GenerationOptions(
        conflictStrategy: ConflictStrategy.overwrite,
        dryRun: true,
        installDependencies: false,
        format: false,
      ),
    );

    expect(await yamlFile.readAsString(), beforeYaml);
    expect(await appRoutesFile.readAsString(), beforeAppRoutes);
    expect(await generatedFile.readAsString(), beforeGenerated);
    expect(
      Directory('${project.root.path}/lib/features/preview').existsSync(),
      isFalse,
    );
  });

  test('route registration is idempotent', () async {
    final project = await createProject();

    for (var index = 0; index < 2; index++) {
      await const FeatureGenerator().generate(
        project: project,
        featureName: 'details',
        architecture: 'clean',
        includeRoute: true,
        routeTarget: RouteTarget.branch('blog'),
        includeJsonSerialization: false,
        options: generationOptions,
      );
    }

    final config = KiteConfig.load(project.root);
    expect(config.routing.routes.length, 1);
    final appRoutes = await File(
      '${project.root.path}/lib/app/router/app_routes.dart',
    ).readAsString();
    expect(RegExp('blogDetails').allMatches(appRoutes).length, 1);
    final branch = await File(
      '${project.root.path}/lib/app/router/generated/branches/blog_branch.dart',
    ).readAsString();
    expect(RegExp('detailsRoute\\(').allMatches(branch).length, 1);
    expect(
      Directory(
        '${project.root.path}/lib/features/details/presentation/routes',
      ).existsSync(),
      isFalse,
    );
  });
  test('route constant collisions fail before writing a new feature', () async {
    final project = await createProject();

    await const FeatureGenerator().generate(
      project: project,
      featureName: 'details',
      architecture: 'clean',
      includeRoute: true,
      routeTarget: RouteTarget.branch('blog'),
      includeJsonSerialization: false,
      options: generationOptions,
    );

    await expectLater(
      const FeatureGenerator().generate(
        project: project,
        featureName: 'blog-details',
        architecture: 'clean',
        includeRoute: true,
        includeJsonSerialization: false,
        options: generationOptions,
      ),
      throwsA(
        predicate(
          (error) => error.toString().contains('Route constant `blogDetails`'),
        ),
      ),
    );
    expect(
      Directory('${project.root.path}/lib/features/blog_details').existsSync(),
      isFalse,
    );
  });

  test(
    'installed template dependencies are not regenerated by features',
    () async {
      final project = await createProject(shell: false);
      final observer = File(
        '${project.root.path}/lib/core/state/app_provider_observer.dart',
      );
      await observer.writeAsString('// developer customization\n');

      await const FeatureGenerator().generate(
        project: project,
        featureName: 'settings',
        architecture: 'clean',
        includeRoute: false,
        includeJsonSerialization: false,
        options: GenerationOptions(
          conflictStrategy: ConflictStrategy.fail,
          dryRun: false,
          installDependencies: false,
          format: false,
        ),
      );

      expect(await observer.readAsString(), '// developer customization\n');
      expect(
        File(
          '${project.root.path}/lib/features/settings/presentation/screens/'
          'settings_screen.dart',
        ).existsSync(),
        isTrue,
      );
    },
  );
}
