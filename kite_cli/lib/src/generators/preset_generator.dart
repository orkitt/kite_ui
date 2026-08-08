import '../generation/file_writer.dart';
import '../generation/generation_plan.dart';
import '../generation/generation_result.dart';
import '../generation/managed_template_filter.dart';
import '../generation/project_manifest.dart';
import '../generation/template_planner.dart';
import '../logging/kite_logger.dart';
import '../process/dart_formatter.dart';
import '../process/dependency_installer.dart';
import '../project/flutter_project.dart';
import '../project/kite_config.dart';
import '../templates/template_store.dart';
import '../version.dart';
import 'generation_options.dart';

// usecase
// PresetGenerator
// │
// ├── kite --state riverpod
// ├── kite --api:dio
// ├── kite --widget ...
// └── future reusable preset/bundle commands
final class PresetGenerator {
  const PresetGenerator({
    this.templateStore = const TemplateStore(),
    this.planner = const TemplatePlanner(),
    this.fileWriter = const FileWriter(),
    this.manifestStore = const ProjectManifestStore(),
    this.managedTemplateFilter = const ManagedTemplateFilter(),
    this.dependencyInstaller = const DependencyInstaller(),
    this.formatter = const DartFormatter(),
    this.logger = const KiteLogger(),
  });

  final TemplateStore templateStore;
  final TemplatePlanner planner;
  final FileWriter fileWriter;
  final ProjectManifestStore manifestStore;
  final ManagedTemplateFilter managedTemplateFilter;
  final DependencyInstaller dependencyInstaller;
  final DartFormatter formatter;
  final KiteLogger logger;

  Future<GenerationResult> generate({
    required FlutterProject project,
    required List<String> templateIds,
    required String label,
    required GenerationOptions options,
  }) async {
    if (templateIds.isEmpty) {
      throw ArgumentError.value(templateIds, 'templateIds', 'Cannot be empty.');
    }

    final config = KiteConfig.load(project.root);
    final variables = <String, Object?>{
      'project': <String, Object?>{
        'name': project.name,
        'package': project.name,
      },
      'config': config.toTemplateValues(),
      'kite': <String, Object?>{'version': kiteCliVersion},
      'generated': <String, Object?>{
        'date': DateTime.now().toUtc().toIso8601String(),
      },
    };

    final rootPlans = <GenerationPlan>[];
    final dependencies = <String>{};
    final devDependencies = <String>{};

    for (final templateId in templateIds.toSet()) {
      final templates = await templateStore.resolve(templateId);
      final generationTemplates = await managedTemplateFilter
          .excludeInstalledDependencies(
            projectRoot: project.root,
            rootTemplateId: templateId,
            templates: templates,
            variables: variables,
          );
      rootPlans.add(
        await planner.buildResolved(
          rootTemplateId: templateId,
          templates: generationTemplates,
          variables: variables,
        ),
      );
      for (final template in generationTemplates) {
        dependencies.addAll(template.manifest.dependencies);
        devDependencies.addAll(template.manifest.devDependencies);
      }
    }

    final filesByPath = <String, PlannedFile>{};
    for (final plan in rootPlans) {
      for (final file in plan.files) {
        final existing = filesByPath[file.relativePath];
        if (existing == null) {
          filesByPath[file.relativePath] = file;
          continue;
        }
        if (existing.content != file.content ||
            existing.upgradePolicy != file.upgradePolicy) {
          throw StateError(
            'Selected templates conflict at ${file.relativePath}.',
          );
        }
      }
    }

    final combinedPlan = GenerationPlan(
      templateId: 'bundle.${templateIds.join('+')}',
      templateVersion: kiteCliVersion,
      variables: Map<String, Object?>.unmodifiable(variables),
      files: List<PlannedFile>.unmodifiable(filesByPath.values),
    );
    final result = await fileWriter.write(
      root: project.root,
      plan: combinedPlan,
      conflictStrategy: options.conflictStrategy,
      dryRun: options.dryRun,
    );

    if (!options.dryRun) {
      final resultByPath = <String, GeneratedFileResult>{
        for (final file in result.files) file.relativePath: file,
      };
      for (final plan in rootPlans) {
        final planResult = GenerationResult(
          plan.files
              .map((file) => resultByPath[file.relativePath])
              .whereType<GeneratedFileResult>()
              .toList(growable: false),
        );
        await manifestStore.record(
          root: project.root,
          generationId: plan.templateId,
          plan: plan,
          result: planResult,
        );
      }
    }

    if (options.installDependencies && !options.dryRun) {
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
      '$prefix $label: '
      '${result.count(GeneratedFileStatus.created)} new, '
      '${result.count(GeneratedFileStatus.updated)} updated, '
      '${result.count(GeneratedFileStatus.unchanged)} unchanged, '
      '${result.count(GeneratedFileStatus.skipped)} skipped.',
    );
    return result;
  }
}
