import 'dart:io';

import 'package:path/path.dart' as p;

import '../generation/conflict_strategy.dart';
import '../logging/kite_logger.dart';
import '../process/dart_formatter.dart';
import '../project/flutter_project.dart';
import '../project/kite_config.dart';
import '../routing/route_generator.dart';
import 'feature_generator.dart';
import 'generation_options.dart';
import 'preset_generator.dart';

final class SyncGenerator {
  const SyncGenerator({
    this.featureGenerator = const FeatureGenerator(),
    this.routeGenerator = const RouteGenerator(),
    this.presetGenerator = const PresetGenerator(),
    this.formatter = const DartFormatter(),
    this.logger = const KiteLogger(),
  });

  final FeatureGenerator featureGenerator;
  final RouteGenerator routeGenerator;
  final PresetGenerator presetGenerator;
  final DartFormatter formatter;
  final KiteLogger logger;

  Future<void> sync({
    required FlutterProject project,
    required GenerationOptions options,
  }) async {
    final configFile = File(p.join(project.root.path, 'kite.yaml'));
    if (!configFile.existsSync()) {
      throw StateError('kite.yaml not found. Run `kite init` first.');
    }

    final config = KiteConfig.load(project.root);
    if (config.projectPreset == 'vanilla') {
      throw StateError(
        '`kite sync` does not modify vanilla projects. The vanilla template '
        'remains opt-in and independent.',
      );
    }
    if (config.routing.type != 'go_router') {
      throw StateError(
        '`kite sync` currently supports clean GoRouter projects only.',
      );
    }

    // Validate the complete routing topology before creating any missing
    // infrastructure. This keeps sync transaction-like when kite.yaml is invalid.
    final routing = await routeGenerator.syncProject(
      project: project,
      conflictStrategy: options.conflictStrategy,
      dryRun: true,
    );
    final reconciledConfig = config.copyWith(routing: routing);

    await _ensureDatabaseFoundation(
      project: project,
      config: reconciledConfig,
      options: options,
    );
    await _ensureShellRootFeatures(
      project: project,
      config: reconciledConfig,
      options: options,
    );
    await _ensureRouteFeatures(
      project: project,
      config: reconciledConfig,
      options: options,
    );

    if (!options.dryRun) {
      await routeGenerator.syncProject(
        project: project,
        conflictStrategy: options.conflictStrategy,
        dryRun: false,
      );
    }

    if (options.format && !options.dryRun) {
      await formatter.format(project.root.path);
    }

    logger.success(
      options.dryRun
          ? 'Kite sync preview completed without modifying the project.'
          : 'Kite project synchronized from kite.yaml.',
    );
  }

  Future<void> _ensureDatabaseFoundation({
    required FlutterProject project,
    required KiteConfig config,
    required GenerationOptions options,
  }) async {
    if (!config.database.enabled) {
      return;
    }
    if (config.database.type != 'isar') {
      throw StateError(
        'Unsupported configured database `${config.database.type}`. '
        'Available: isar.',
      );
    }

    await presetGenerator.generate(
      project: project,
      templateIds: const <String>['db.isar'],
      label: 'configured Isar database foundation',
      options: GenerationOptions(
        conflictStrategy: options.conflictStrategy,
        dryRun: options.dryRun,
        installDependencies: options.installDependencies,
        format: false,
      ),
    );
  }

  Future<void> _ensureShellRootFeatures({
    required FlutterProject project,
    required KiteConfig config,
    required GenerationOptions options,
  }) async {
    if (!config.routing.shell.enabled) {
      return;
    }

    for (final branch in config.routing.shell.branches) {
      await _ensureFeature(
        project: project,
        config: config,
        featureName: branch.feature,
        architecture: branch.architecture,
        reason: 'shell branch `${branch.name}`',
        options: options,
      );
    }
  }
  Future<void> _ensureRouteFeatures({
    required FlutterProject project,
    required KiteConfig config,
    required GenerationOptions options,
  }) async {
    for (final route in config.routing.routes) {
      await _ensureFeature(
        project: project,
        config: config,
        featureName: route.feature,
        architecture: route.architecture,
        reason: 'route `${route.path}`',
        options: options,
      );
    }
  }

  Future<void> _ensureFeature({
    required FlutterProject project,
    required KiteConfig config,
    required String featureName,
    required String architecture,
    required String reason,
    required GenerationOptions options,
  }) async {
    final featureDirectory = Directory(
      p.joinAll(<String>[
        project.root.path,
        ...p.posix.split(config.featureDirectory),
        featureName,
      ]),
    );
    final expectedScreen = File(
      p.joinAll(<String>[
        featureDirectory.path,
        ...p.posix.split(
          architecture == 'mvc'
              ? 'views/screens/${featureName}_screen.dart'
              : 'presentation/screens/${featureName}_screen.dart',
        ),
      ]),
    );
    if (expectedScreen.existsSync()) {
      return;
    }

    final alternateScreen = File(
      p.joinAll(<String>[
        featureDirectory.path,
        ...p.posix.split(
          architecture == 'mvc'
              ? 'presentation/screens/${featureName}_screen.dart'
              : 'views/screens/${featureName}_screen.dart',
        ),
      ]),
    );
    if (alternateScreen.existsSync()) {
      final existingArchitecture = architecture == 'mvc' ? 'clean' : 'mvc';
      throw StateError(
        'Feature `$featureName` already exists as $existingArchitecture, but '
        '$reason declares architecture `$architecture`. Update kite.yaml or '
        'migrate the feature explicitly before syncing.',
      );
    }

    logger.info('Creating missing `$featureName` feature for $reason...');
    await featureGenerator.generate(
      project: project,
      featureName: featureName,
      architecture: architecture,
      includeRoute: false,
      includeJsonSerialization: false,
      options: GenerationOptions(
        conflictStrategy: featureDirectory.existsSync()
            ? ConflictStrategy.skip
            : options.conflictStrategy,
        dryRun: options.dryRun,
        installDependencies: false,
        format: false,
      ),
    );
  }

}
