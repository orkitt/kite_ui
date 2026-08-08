import '../generation/file_writer.dart';
import '../generation/generation_result.dart';
import '../generation/project_manifest.dart';
import '../generation/template_planner.dart';
import '../logging/kite_logger.dart';
import '../process/dart_formatter.dart';
import '../process/dependency_installer.dart';
import '../project/flutter_project.dart';
import '../project/project_preset.dart';
import '../templates/template_store.dart';
import '../version.dart';
import 'generation_options.dart';

// usecase
// ProjectGenerator
// │
// ├── kite init
// └── kite init --vanilla
final class ProjectGenerator {
  const ProjectGenerator({
    this.templateStore = const TemplateStore(),
    this.planner = const TemplatePlanner(),
    this.fileWriter = const FileWriter(),
    this.manifestStore = const ProjectManifestStore(),
    this.dependencyInstaller = const DependencyInstaller(),
    this.formatter = const DartFormatter(),
    this.logger = const KiteLogger(),
  });

  final TemplateStore templateStore;
  final TemplatePlanner planner;
  final FileWriter fileWriter;
  final ProjectManifestStore manifestStore;
  final DependencyInstaller dependencyInstaller;
  final DartFormatter formatter;
  final KiteLogger logger;

  Future<GenerationResult> generate({
    required FlutterProject project,
    ProjectPreset preset = ProjectPreset.clean,
    required GenerationOptions options,
  }) async {
    final templateId = preset.templateId;
    logger.info('Using template: $templateId');
    final templates = await templateStore.resolve(templateId);
    final variables = <String, Object?>{
      'project': <String, Object?>{
        'name': project.name,
        'package': project.name,
      },
      'config': <String, Object?>{
        'sourceDirectory': 'lib',
        'featureDirectory': 'lib/features',
        'architecture': 'clean',
        'router': 'go_router',
        'stateManagement': 'riverpod',
      },
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
        generationId: templateId,
        plan: plan,
        result: result,
      );
    }

    if (options.installDependencies && !options.dryRun) {
      final dependencies = <String>{};
      final devDependencies = <String>{};
      for (final template in templates) {
        dependencies.addAll(template.manifest.dependencies);
        devDependencies.addAll(template.manifest.devDependencies);
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

    _printResult(result, options.dryRun);
    return result;
  }

  void _printResult(GenerationResult result, bool dryRun) {
    final prefix = dryRun ? 'Would generate' : 'Generated';
    logger.success(
      '$prefix ${result.count(GeneratedFileStatus.created)} new files, '
      '${result.count(GeneratedFileStatus.updated)} updated, '
      '${result.count(GeneratedFileStatus.unchanged)} unchanged, '
      '${result.count(GeneratedFileStatus.skipped)} skipped.',
    );
  }
}
