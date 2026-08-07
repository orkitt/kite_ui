import '../generation/file_writer.dart';
import '../generation/generation_result.dart';
import '../generation/project_manifest.dart';
import '../generation/template_planner.dart';
import '../logging/kite_logger.dart';
import '../naming/name_converter.dart';
import '../process/dart_formatter.dart';
import '../process/dependency_installer.dart';
import '../project/flutter_project.dart';
import '../project/kite_config.dart';
import '../templates/template_store.dart';
import '../version.dart';
import 'generation_options.dart';
import 'route_registry_updater.dart';

final class FeatureGenerator {
  const FeatureGenerator({
    this.templateStore = const TemplateStore(),
    this.planner = const TemplatePlanner(),
    this.fileWriter = const FileWriter(),
    this.manifestStore = const ProjectManifestStore(),
    this.routeRegistryUpdater = const RouteRegistryUpdater(),
    this.dependencyInstaller = const DependencyInstaller(),
    this.formatter = const DartFormatter(),
    this.logger = const KiteLogger(),
  });

  final TemplateStore templateStore;
  final TemplatePlanner planner;
  final FileWriter fileWriter;
  final ProjectManifestStore manifestStore;
  final RouteRegistryUpdater routeRegistryUpdater;
  final DependencyInstaller dependencyInstaller;
  final DartFormatter formatter;
  final KiteLogger logger;

  Future<GenerationResult> generate({
    required FlutterProject project,
    required String featureName,
    required String architecture,
    required bool includeRoute,
    required bool includeJsonSerialization,
    required GenerationOptions options,
  }) async {
    const supportedArchitectures = <String>{'clean', 'mvc'};
    if (!supportedArchitectures.contains(architecture)) {
      throw ArgumentError.value(
        architecture,
        'architecture',
        'Unsupported feature architecture.',
      );
    }

    final feature = NameConverter(featureName);
    final config = KiteConfig.load(project.root);
    if (includeRoute) {
      routeRegistryUpdater.ensureAvailable(
        projectRoot: project.root,
        sourceDirectory: config.sourceDirectory,
      );
    }

    final templateId = 'feature.$architecture';
    final templates = await templateStore.resolve(templateId);
    final variables = <String, Object?>{
      'project': <String, Object?>{
        'name': project.name,
        'package': project.name,
      },
      'feature': <String, Object?>{
        'raw': featureName,
        'snake': feature.snakeCase,
        'camel': feature.camelCase,
        'pascal': feature.pascalCase,
        'kebab': feature.kebabCase,
      },
      'config': config.toTemplateValues(),
      'includeRoute': includeRoute,
      'includeJson': includeJsonSerialization,
      'kite': <String, Object?>{'version': kiteCliVersion},
      'generated': <String, Object?>{
        'date': DateTime.now().toUtc().toIso8601String(),
      },
    };
    final plan = await planner.buildResolved(
      rootTemplateId: templateId,
      templates: templates,
      variables: variables,
    );
    final result = await fileWriter.write(
      root: project.root,
      plan: plan,
      conflictStrategy: options.conflictStrategy,
      dryRun: options.dryRun,
    );

    if (!options.dryRun) {
      await manifestStore.record(
        root: project.root,
        generationId: '$templateId:${feature.snakeCase}',
        plan: plan,
        result: result,
      );
    }

    if (includeRoute && !options.dryRun) {
      await routeRegistryUpdater.addFeatureRoute(
        projectRoot: project.root,
        feature: feature,
        sourceDirectory: config.sourceDirectory,
        featureDirectory: config.featureDirectory,
        architecture: architecture,
      );
    }

    if (options.installDependencies && !options.dryRun) {
      final dependencies = <String>{};
      final devDependencies = <String>{};
      for (final template in templates) {
        dependencies.addAll(template.manifest.dependencies);
        devDependencies.addAll(template.manifest.devDependencies);
      }
      if (includeJsonSerialization) {
        dependencies.add('json_annotation');
        devDependencies
          ..add('build_runner')
          ..add('json_serializable');
      }
      await dependencyInstaller.installPackages(
        projectPath: project.root.path,
        dependencies: dependencies,
        devDependencies: devDependencies,
      );
    }

    if (options.format && !options.dryRun) {
      await formatter.format(project.root.path);
    }

    final prefix = options.dryRun ? 'Would generate' : 'Generated';
    logger.success(
      '$prefix $architecture feature `${feature.snakeCase}`: '
      '${result.count(GeneratedFileStatus.created)} new, '
      '${result.count(GeneratedFileStatus.updated)} updated, '
      '${result.count(GeneratedFileStatus.unchanged)} unchanged, '
      '${result.count(GeneratedFileStatus.skipped)} skipped.',
    );
    return result;
  }
}
