import 'dart:io';

import 'package:path/path.dart' as p;

import '../generation/conflict_strategy.dart';
import '../generation/file_checksum.dart';
import '../generation/file_writer.dart';
import '../generation/generation_plan.dart';
import '../generation/generation_result.dart';
import '../generation/project_manifest.dart';
import '../generation/template_planner.dart';
import '../logging/kite_logger.dart';
import '../project/flutter_project.dart';
import '../templates/template_manifest.dart';
import '../templates/template_store.dart';
import '../version.dart';

final class UpgradeGenerator {
  const UpgradeGenerator({
    this.templateStore = const TemplateStore(),
    this.planner = const TemplatePlanner(),
    this.fileWriter = const FileWriter(),
    this.manifestStore = const ProjectManifestStore(),
    this.logger = const KiteLogger(),
  });

  final TemplateStore templateStore;
  final TemplatePlanner planner;
  final FileWriter fileWriter;
  final ProjectManifestStore manifestStore;
  final KiteLogger logger;

  Future<void> upgrade({
    required FlutterProject project,
    required bool dryRun,
    required bool force,
  }) async {
    final manifest = await manifestStore.read(project.root);
    if (manifest.generations.isEmpty) {
      throw StateError('No Kite manifest found. Run `kite init` first.');
    }

    var changedFiles = 0;
    var preservedFiles = 0;

    for (final generation in manifest.generations) {
      final templates = await templateStore.resolve(generation.templateId);
      final currentPlan = await planner.buildResolved(
        rootTemplateId: generation.templateId,
        templates: templates,
        variables: generation.variables,
      );
      final oldFiles = <String, ManagedFileRecord>{
        for (final file in generation.files) file.path: file,
      };
      final safeFiles = <PlannedFile>[];
      final carriedRecords = <ManagedFileRecord>[];

      for (final planned in currentPlan.files) {
        final existingRecord = oldFiles[planned.relativePath];
        final target = File(p.join(project.root.path, planned.relativePath));

        if (planned.upgradePolicy == TemplateUpgradePolicy.preserve) {
          preservedFiles++;
          if (target.existsSync()) {
            carriedRecords.add(
              ManagedFileRecord(
                path: planned.relativePath,
                checksum: await FileChecksum.file(target),
                upgradePolicy: planned.upgradePolicy,
              ),
            );
          }
          continue;
        }

        if (!target.existsSync()) {
          safeFiles.add(planned);
          continue;
        }

        final currentChecksum = await FileChecksum.file(target);
        final isUnmodified =
            existingRecord != null &&
            currentChecksum == existingRecord.checksum;
        final isAlreadyCurrent =
            currentChecksum == FileChecksum.content(planned.content);

        if (force || isUnmodified || isAlreadyCurrent) {
          safeFiles.add(planned);
        } else {
          preservedFiles++;
          logger.warning('Preserved modified file: ${planned.relativePath}');
          if (existingRecord != null) {
            carriedRecords.add(existingRecord);
          }
        }
      }

      final safePlan = GenerationPlan(
        templateId: currentPlan.templateId,
        templateVersion: currentPlan.templateVersion,
        variables: currentPlan.variables,
        files: safeFiles,
      );
      final result = await fileWriter.write(
        root: project.root,
        plan: safePlan,
        conflictStrategy: ConflictStrategy.overwrite,
        dryRun: dryRun,
      );
      changedFiles +=
          result.count(GeneratedFileStatus.created) +
          result.count(GeneratedFileStatus.updated);

      if (!dryRun) {
        final plannedByPath = <String, PlannedFile>{
          for (final item in currentPlan.files) item.relativePath: item,
        };
        final records = <String, ManagedFileRecord>{
          for (final item in carriedRecords) item.path: item,
        };
        for (final file in result.files.where(
          (item) => item.checksum != null,
        )) {
          records[file.relativePath] = ManagedFileRecord(
            path: file.relativePath,
            checksum: file.checksum!,
            upgradePolicy: plannedByPath[file.relativePath]!.upgradePolicy,
          );
        }

        await manifestStore.replaceGeneration(
          root: project.root,
          record: GenerationRecord(
            id: generation.id,
            templateId: currentPlan.templateId,
            templateVersion: currentPlan.templateVersion,
            variables: currentPlan.variables,
            files: records.values.toList(growable: false),
            generatedAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
      }
    }

    final action = dryRun ? 'Would upgrade' : 'Upgraded';
    logger.success(
      '$action $changedFiles files; preserved $preservedFiles files.',
    );
    if (!dryRun) {
      logger.detail('Project manifest updated for Kite $kiteCliVersion.');
    }
  }
}
