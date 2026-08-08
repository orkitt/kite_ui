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

final class SyncGenerator {
  const SyncGenerator({
    this.featureGenerator = const FeatureGenerator(),
    this.routeGenerator = const RouteGenerator(),
    this.formatter = const DartFormatter(),
    this.logger = const KiteLogger(),
  });

  final FeatureGenerator featureGenerator;
  final RouteGenerator routeGenerator;
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

    final reconciled = routeGenerator.reconcilePaths(config.routing);
    await _ensureShellRootFeatures(
      project: project,
      config: config.copyWith(routing: reconciled),
      options: options,
    );

    await routeGenerator.syncProject(
      project: project,
      conflictStrategy: options.conflictStrategy,
      dryRun: options.dryRun,
    );

    if (options.format && !options.dryRun) {
      await formatter.format(project.root.path);
    }

    logger.success(
      options.dryRun
          ? 'Kite sync preview completed without modifying the project.'
          : 'Kite project synchronized from kite.yaml.',
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
      final featureDirectory = Directory(
        p.joinAll(<String>[
          project.root.path,
          ...p.posix.split(config.featureDirectory),
          branch.feature,
        ]),
      );
      final screen = File(
        p.joinAll(<String>[
          featureDirectory.path,
          ...p.posix.split(
            branch.architecture == 'mvc'
                ? 'views/screens/${branch.feature}_screen.dart'
                : 'presentation/screens/${branch.feature}_screen.dart',
          ),
        ]),
      );
      if (screen.existsSync()) {
        continue;
      }

      logger.info(
        'Creating shell root feature `${branch.feature}` for `${branch.name}`...',
      );
      await featureGenerator.generate(
        project: project,
        featureName: branch.feature,
        architecture: branch.architecture,
        includeRoute: false,
        includeJsonSerialization: false,
        options: GenerationOptions(
          // Sync owns routing, not feature source. If a partial feature already
          // exists, fill only missing generated files and preserve its code.
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
}
