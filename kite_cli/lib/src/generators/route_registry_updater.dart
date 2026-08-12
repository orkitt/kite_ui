import 'dart:io';

import 'package:path/path.dart' as p;

import '../naming/name_converter.dart';
import '../project/flutter_project.dart';
import '../routing/route_generator.dart';
import '../routing/route_target.dart';

/// Backward-compatible adapter for the pre-0.2 route registry API.
///
/// New generator code should depend on [RouteGenerator] directly. This adapter
/// intentionally delegates to the central routing topology and never writes
/// feature-owned route files.
@Deprecated('Use RouteGenerator instead.')
final class RouteRegistryUpdater {
  const RouteRegistryUpdater({
    this.routeGenerator = const RouteGenerator(),
  });

  final RouteGenerator routeGenerator;

  void ensureAvailable({
    required Directory projectRoot,
    required String sourceDirectory,
  }) {
    routeGenerator.ensureAvailable(
      projectRoot: projectRoot,
      sourceDirectory: sourceDirectory,
    );
  }

  Future<void> addFeatureRoute({
    required Directory projectRoot,
    required NameConverter feature,
    required String sourceDirectory,
    required String featureDirectory,
    required String architecture,
  }) async {
    ensureAvailable(
      projectRoot: projectRoot,
      sourceDirectory: sourceDirectory,
    );

    await routeGenerator.registerFeature(
      project: FlutterProject(
        root: projectRoot,
        name: p.basename(projectRoot.path),
      ),
      feature: feature,
      architecture: architecture,
      target: const RouteTarget.root(),
      dryRun: false,
    );
  }
}
