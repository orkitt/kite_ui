import 'dart:io';

import 'package:path/path.dart' as p;

import '../generation/conflict_strategy.dart';
import '../generation/file_checksum.dart';
import '../generation/project_manifest.dart';
import '../naming/name_converter.dart';
import '../project/flutter_project.dart';
import '../project/kite_config.dart';
import 'app_routes_updater.dart';
import 'generated_router_writer.dart';
import 'route_target.dart';
import 'shell_definition.dart';

final class RouteGenerator {
  const RouteGenerator({
    this.configStore = const KiteConfigStore(),
    this.appRoutesUpdater = const AppRoutesUpdater(),
    this.routerWriter = const GeneratedRouterWriter(),
    this.manifestStore = const ProjectManifestStore(),
  });

  final KiteConfigStore configStore;
  final AppRoutesUpdater appRoutesUpdater;
  final GeneratedRouterWriter routerWriter;
  final ProjectManifestStore manifestStore;

  Future<void> initializeProject({
    required FlutterProject project,
    required ShellDefinition? shellDefinition,
    required ConflictStrategy conflictStrategy,
    required bool dryRun,
  }) async {
    if (dryRun) {
      return;
    }

    final config = KiteConfig.load(project.root);
    if (config.routing.type != 'go_router') {
      if (shellDefinition != null) {
        throw StateError(
          '`--shell` requires a GoRouter project. Use the default `kite init` '
          'preset instead of the vanilla material-router preset.',
        );
      }
      return;
    }

    final shell = shellDefinition == null
        ? config.routing.shell
        : KiteShellConfig(
            enabled: true,
            branches: shellDefinition.branches
                .map(
                  (branch) => KiteShellBranchConfig(
                    name: branch.name,
                    path: branch.path,
                    feature: NameConverter(branch.name).snakeCase,
                    architecture: config.architecture,
                    navigation: KiteShellNavigationConfig(
                      label: NameConverter(branch.name).titleCase,
                    ),
                  ),
                )
                .toList(growable: false),
          );
    final routing = reconcilePaths(config.routing.copyWith(shell: shell));
    await _validateTopology(routing, config: config);

    final updatedConfig = config.copyWith(routing: routing);
    await appRoutesUpdater.update(
      projectRoot: project.root,
      sourceDirectory: config.sourceDirectory,
      routing: routing,
      dryRun: false,
    );
    await routerWriter.writeGeneratedRoutes(
      projectRoot: project.root,
      config: updatedConfig,
      routing: routing,
      dryRun: false,
    );
    if (shell.enabled) {
      await routerWriter.writeShell(
        projectRoot: project.root,
        sourceDirectory: config.sourceDirectory,
        shell: shell,
        conflictStrategy: conflictStrategy,
        dryRun: false,
      );
    }
    await _writeRoutingConfig(project.root, routing);
  }

  Future<KiteRoutingConfig> syncProject({
    required FlutterProject project,
    required ConflictStrategy conflictStrategy,
    required bool dryRun,
  }) async {
    final config = KiteConfig.load(project.root);
    if (config.projectPreset == 'vanilla' ||
        config.routing.type != 'go_router') {
      throw StateError(
        '`kite sync` currently supports Kite clean GoRouter projects only.',
      );
    }

    final routing = reconcilePaths(config.routing);
    await _validateTopology(routing, config: config);

    final appRoutesFile = File(
      _absolutePath(
        project.root,
        p.posix.join(
          _portable(config.sourceDirectory),
          'app',
          'router',
          'app_routes.dart',
        ),
      ),
    );
    if (!appRoutesFile.existsSync()) {
      throw StateError('AppRoutes not found. Run `kite init` first.');
    }
    appRoutesUpdater.buildContent(
      currentContent: appRoutesFile.readAsStringSync(),
      routing: routing,
    );
    await routerWriter.buildGeneratedFiles(config: config, routing: routing);
    if (routing.shell.enabled) {
      await routerWriter.buildAppShell(routing.shell);
    }

    if (dryRun) {
      return routing;
    }

    await appRoutesUpdater.update(
      projectRoot: project.root,
      sourceDirectory: config.sourceDirectory,
      routing: routing,
      dryRun: false,
    );
    await routerWriter.writeGeneratedRoutes(
      projectRoot: project.root,
      config: config.copyWith(routing: routing),
      routing: routing,
      dryRun: false,
    );
    if (routing.shell.enabled) {
      await routerWriter.writeShell(
        projectRoot: project.root,
        sourceDirectory: config.sourceDirectory,
        shell: routing.shell,
        conflictStrategy: conflictStrategy,
        dryRun: false,
      );
    }
    await _writeRoutingConfig(project.root, routing);
    return routing;
  }

  KiteRoutingConfig reconcilePaths(KiteRoutingConfig routing) {
    final branches = <String, KiteShellBranchConfig>{
      if (routing.shell.enabled)
        for (final branch in routing.shell.branches) branch.name: branch,
    };
    final routes = routing.routes
        .map((route) {
          if (route.branch == 'root') {
            return route.copyWith(path: '/${route.segment}');
          }
          final branch = branches[route.branch];
          if (branch == null) {
            return route;
          }
          final path = branch.path == '/'
              ? '/${route.segment}'
              : '${branch.path}/${route.segment}';
          return route.copyWith(path: path);
        })
        .toList(growable: false);
    return routing.copyWith(routes: routes);
  }

  void ensureAvailable({
    required Directory projectRoot,
    required String sourceDirectory,
  }) {
    final config = KiteConfig.load(projectRoot);
    if (config.routing.type != 'go_router') {
      throw StateError(
        'Generated feature routes require `routing.type: go_router` in '
        'kite.yaml.',
      );
    }

    final routerFile = File(
      _absolutePath(
        projectRoot,
        p.posix.join(
          _portable(sourceDirectory),
          'app',
          'router',
          'generated',
          'generated_routes.dart',
        ),
      ),
    );
    if (!routerFile.existsSync()) {
      final legacyFile = File(
        _absolutePath(
          projectRoot,
          p.posix.join(
            _portable(sourceDirectory),
            'app',
            'router',
            'generated_routes.dart',
          ),
        ),
      );
      if (legacyFile.existsSync()) {
        throw StateError(
          'This project uses Kite\'s legacy feature-owned routing layout. '
          'Re-run `kite init --force` to install the central router, then '
          'regenerate routes as needed. Kite will not delete existing '
          '`features/*/presentation/routes` or `features/*/routes` files.',
        );
      }
      throw StateError(
        'Generated router not found. Run `kite init` before using --route.',
      );
    }
  }

  Future<void> validateFeatureRegistration({
    required FlutterProject project,
    required NameConverter feature,
    required String architecture,
    required RouteTarget target,
  }) async {
    final config = KiteConfig.load(project.root);
    ensureAvailable(
      projectRoot: project.root,
      sourceDirectory: config.sourceDirectory,
    );
    final routing = _routingWithFeature(
      reconcilePaths(config.routing),
      feature: feature,
      architecture: architecture,
      target: target,
    );
    await _validateTopology(routing, config: config);
    final appRoutesFile = File(
      _absolutePath(
        project.root,
        p.posix.join(
          _portable(config.sourceDirectory),
          'app',
          'router',
          'app_routes.dart',
        ),
      ),
    );
    if (!appRoutesFile.existsSync()) {
      throw StateError('AppRoutes not found. Run `kite init` first.');
    }
    appRoutesUpdater.buildContent(
      currentContent: appRoutesFile.readAsStringSync(),
      routing: routing,
    );
    await routerWriter.buildGeneratedFiles(config: config, routing: routing);
  }

  Future<void> registerFeature({
    required FlutterProject project,
    required NameConverter feature,
    required String architecture,
    required RouteTarget target,
    required bool dryRun,
  }) async {
    final config = KiteConfig.load(project.root);
    ensureAvailable(
      projectRoot: project.root,
      sourceDirectory: config.sourceDirectory,
    );
    final routing = _routingWithFeature(
      reconcilePaths(config.routing),
      feature: feature,
      architecture: architecture,
      target: target,
    );
    await _validateTopology(routing, config: config);

    final appRoutesFile = File(
      _absolutePath(
        project.root,
        p.posix.join(
          _portable(config.sourceDirectory),
          'app',
          'router',
          'app_routes.dart',
        ),
      ),
    );
    if (!appRoutesFile.existsSync()) {
      throw StateError('AppRoutes not found. Run `kite init` first.');
    }
    appRoutesUpdater.buildContent(
      currentContent: appRoutesFile.readAsStringSync(),
      routing: routing,
    );
    await routerWriter.buildGeneratedFiles(config: config, routing: routing);

    if (dryRun) {
      return;
    }

    await appRoutesUpdater.update(
      projectRoot: project.root,
      sourceDirectory: config.sourceDirectory,
      routing: routing,
      dryRun: false,
    );
    await routerWriter.writeGeneratedRoutes(
      projectRoot: project.root,
      config: config.copyWith(routing: routing),
      routing: routing,
      dryRun: false,
    );
    await _writeRoutingConfig(project.root, routing);
  }

  KiteRoutingConfig _routingWithFeature(
    KiteRoutingConfig routing, {
    required NameConverter feature,
    required String architecture,
    required RouteTarget target,
  }) {
    if (architecture != 'clean' && architecture != 'mvc') {
      throw ArgumentError.value(
        architecture,
        'architecture',
        'Unsupported feature architecture.',
      );
    }

    final segment = feature.kebabCase;
    String branchName;
    String path;
    if (target.isRoot) {
      branchName = 'root';
      path = '/$segment';
    } else {
      if (!routing.shell.enabled) {
        throw StateError(
          '`--into` requires a shell project. Initialize routing with '
          '`kite init --shell "[home,blog,profile]"` first.',
        );
      }
      final requested = NameConverter(target.branch!).kebabCase;
      final branch = routing.shell.branches
          .where((item) => item.name == requested)
          .firstOrNull;
      if (branch == null) {
        final available = routing.shell.branches
            .map((item) => '  ${item.name}')
            .join('\n');
        throw StateError(
          'Shell branch "$requested" does not exist.\n\n'
          'Available branches:\n$available',
        );
      }
      branchName = branch.name;
      path = branch.path == '/' ? '/$segment' : '${branch.path}/$segment';
    }

    final candidate = KiteRouteConfig(
      feature: feature.snakeCase,
      path: path,
      segment: segment,
      branch: branchName,
      architecture: architecture,
    );

    final sameFeature = routing.routes
        .where((route) => route.feature == candidate.feature)
        .firstOrNull;
    if (sameFeature != null) {
      if (sameFeature.path == candidate.path &&
          sameFeature.branch == candidate.branch &&
          sameFeature.segment == candidate.segment &&
          sameFeature.architecture == candidate.architecture) {
        return routing;
      }
      throw StateError(
        'Feature `${candidate.feature}` already has generated route '
        '`${sameFeature.path}` in `${sameFeature.branch}`.',
      );
    }

    final pathOwner = routing.routes
        .where((route) => route.path == candidate.path)
        .firstOrNull;
    if (pathOwner != null) {
      throw StateError(
        'Route path `${candidate.path}` is already used by feature '
        '`${pathOwner.feature}`.',
      );
    }

    return routing.copyWith(
      routes: <KiteRouteConfig>[...routing.routes, candidate],
    );
  }

  Future<void> _validateTopology(
    KiteRoutingConfig routing, {
    required KiteConfig config,
  }) async {
    final branchNames = <String>{};
    final branchPaths = <String>{};
    final branchFeatures = <String>{};
    final branchesByName = <String, KiteShellBranchConfig>{};
    for (final branch in routing.shell.branches) {
      final normalizedName = NameConverter(branch.name).kebabCase;
      final normalizedFeature = NameConverter(branch.feature).snakeCase;
      if (normalizedName == 'root') {
        throw StateError(
          'Shell branch `root` is reserved for root-level routes.',
        );
      }
      if (normalizedName != branch.name) {
        throw StateError(
          'Shell branch `${branch.name}` is not normalized. Use '
          '`$normalizedName` in kite.yaml.',
        );
      }
      if (normalizedFeature != branch.feature) {
        throw StateError(
          'Shell root feature `${branch.feature}` is not normalized. Use '
          '`$normalizedFeature` in kite.yaml.',
        );
      }
      if (!branch.path.startsWith('/') ||
          (branch.path.length > 1 && branch.path.endsWith('/'))) {
        throw StateError('Invalid shell branch path `${branch.path}`.');
      }
      if (!branchNames.add(branch.name)) {
        throw StateError('Duplicate shell branch `${branch.name}`.');
      }
      if (!branchPaths.add(branch.path)) {
        throw StateError('Duplicate shell branch path `${branch.path}`.');
      }
      if (!branchFeatures.add(branch.feature)) {
        throw StateError(
          'Shell root feature `${branch.feature}` is used by more than one branch.',
        );
      }
      if (branch.architecture != 'clean' && branch.architecture != 'mvc') {
        throw StateError(
          'Unsupported architecture `${branch.architecture}` for shell branch '
          '`${branch.name}`.',
        );
      }
      if (routing.shell.enabled) {
        branchesByName[branch.name] = branch;
      }
    }

    if (routing.shell.enabled && routing.shell.branches.isEmpty) {
      throw StateError(
        'Shell routing is enabled but no branches are configured.',
      );
    }

    final activeBranchPaths = routing.shell.enabled
        ? branchPaths
        : const <String>{};
    final activeBranchFeatures = routing.shell.enabled
        ? branchFeatures
        : const <String>{};

    final routePaths = <String>{};
    final routeFeatures = <String>{};
    for (final route in routing.routes) {
      if (activeBranchFeatures.contains(route.feature)) {
        throw StateError(
          'Feature `${route.feature}` is already used as a shell branch root '
          'and cannot also be registered as a generated child/root route.',
        );
      }
      if (activeBranchPaths.contains(route.path)) {
        throw StateError(
          'Generated route `${route.path}` collides with a shell branch root.',
        );
      }
      if (!routePaths.add(route.path)) {
        throw StateError('Duplicate generated route path `${route.path}`.');
      }
      if (!routeFeatures.add(route.feature)) {
        throw StateError(
          'Feature `${route.feature}` is registered more than once.',
        );
      }
      if (route.architecture != 'clean' && route.architecture != 'mvc') {
        throw StateError(
          'Unsupported architecture `${route.architecture}` for '
          '`${route.feature}`.',
        );
      }
      if (route.branch == 'root') {
        final expected = '/${route.segment}';
        if (route.path != expected) {
          throw StateError(
            'Root route `${route.feature}` must use path `$expected`.',
          );
        }
        continue;
      }
      if (!routing.shell.enabled) {
        throw StateError(
          'Route `${route.feature}` targets shell branch `${route.branch}`, '
          'but shell routing is disabled.',
        );
      }
      final branch = branchesByName[route.branch];
      if (branch == null) {
        throw StateError(
          'Route `${route.feature}` references missing shell branch '
          '`${route.branch}`.',
        );
      }
      final expected = branch.path == '/'
          ? '/${route.segment}'
          : '${branch.path}/${route.segment}';
      if (route.path != expected) {
        throw StateError(
          'Route `${route.feature}` must use path `$expected` for branch '
          '`${route.branch}`.',
        );
      }
    }

    await routerWriter.buildGeneratedFiles(config: config, routing: routing);
  }

  Future<void> _writeRoutingConfig(
    Directory projectRoot,
    KiteRoutingConfig routing,
  ) async {
    await configStore.writeRouting(projectRoot: projectRoot, routing: routing);
    final file = File(p.join(projectRoot.path, 'kite.yaml'));
    await manifestStore.updateManagedChecksum(
      root: projectRoot,
      relativePath: 'kite.yaml',
      checksum: FileChecksum.content(await file.readAsString()),
    );
  }

  String _absolutePath(Directory root, String relativePath) {
    return p.joinAll(<String>[root.path, ...p.posix.split(relativePath)]);
  }

  String _portable(String path) => path.replaceAll('\\', '/');
}

extension _FirstOrNullRoute<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
