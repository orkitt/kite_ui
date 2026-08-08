import 'dart:io';

import '../templates/template_store.dart';
import 'project_manifest.dart';
import 'template_planner.dart';

final class ManagedTemplateFilter {
  const ManagedTemplateFilter({
    this.manifestStore = const ProjectManifestStore(),
    this.planner = const TemplatePlanner(),
  });

  final ProjectManifestStore manifestStore;
  final TemplatePlanner planner;

  Future<List<LoadedTemplate>> excludeInstalledDependencies({
    required Directory projectRoot,
    required String rootTemplateId,
    required List<LoadedTemplate> templates,
    required Map<String, Object?> variables,
  }) async {
    final manifest = await manifestStore.read(projectRoot);
    final managedPaths = <String>{
      for (final generation in manifest.generations)
        for (final file in generation.files) file.path,
    };
    if (managedPaths.isEmpty) {
      return templates;
    }

    final result = <LoadedTemplate>[];
    for (final template in templates) {
      if (template.manifest.id == rootTemplateId) {
        result.add(template);
        continue;
      }

      final plan = await planner.build(template, variables);
      final alreadyManaged =
          plan.files.isNotEmpty &&
          plan.files.every((file) => managedPaths.contains(file.relativePath));
      if (!alreadyManaged) {
        result.add(template);
      }
    }

    return List<LoadedTemplate>.unmodifiable(result);
  }
}
