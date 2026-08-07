import 'dart:io';

import 'package:path/path.dart' as p;

import '../templates/template_renderer.dart';
import '../templates/template_store.dart';
import 'generation_plan.dart';

final class TemplatePlanner {
  const TemplatePlanner({
    this.renderer = const TemplateRenderer(),
  });

  final TemplateRenderer renderer;

  Future<GenerationPlan> build(
    LoadedTemplate template,
    Map<String, Object?> variables,
  ) async {
    final files = <PlannedFile>[];

    for (final definition in template.manifest.files) {
      if (!renderer.evaluateCondition(definition.condition, variables)) {
        continue;
      }

      final source = File(p.join(template.directory.path, definition.template));
      if (!source.existsSync()) {
        throw StateError('Missing bundled template: ${source.path}');
      }

      final target = renderer.render(definition.target, variables);
      _validateTarget(target);

      files.add(
        PlannedFile(
          relativePath: target,
          content: renderer.render(await source.readAsString(), variables),
          templatePath: '${template.manifest.id}:${definition.template}',
          upgradePolicy: definition.upgradePolicy,
        ),
      );
    }

    return GenerationPlan(
      templateId: template.manifest.id,
      templateVersion: template.manifest.version,
      variables: Map<String, Object?>.unmodifiable(variables),
      files: List<PlannedFile>.unmodifiable(files),
    );
  }

  Future<GenerationPlan> buildResolved({
    required String rootTemplateId,
    required List<LoadedTemplate> templates,
    required Map<String, Object?> variables,
  }) async {
    final root = templates
        .where((item) => item.manifest.id == rootTemplateId)
        .firstOrNull;
    if (root == null) {
      throw StateError('Resolved template bundle is missing $rootTemplateId.');
    }

    final filesByPath = <String, PlannedFile>{};
    for (final template in templates) {
      final plan = await build(template, variables);
      for (final file in plan.files) {
        final existing = filesByPath[file.relativePath];
        if (existing == null) {
          filesByPath[file.relativePath] = file;
          continue;
        }

        if (existing.content != file.content ||
            existing.upgradePolicy != file.upgradePolicy) {
          throw StateError(
            'Templates produce conflicting content for ${file.relativePath}.',
          );
        }
      }
    }

    return GenerationPlan(
      templateId: root.manifest.id,
      templateVersion: root.manifest.version,
      variables: Map<String, Object?>.unmodifiable(variables),
      files: List<PlannedFile>.unmodifiable(filesByPath.values),
    );
  }

  void _validateTarget(String target) {
    final normalized = p.normalize(target);
    if (target.trim().isEmpty ||
        p.isAbsolute(normalized) ||
        p.split(normalized).contains('..')) {
      throw FormatException('Unsafe template target path: $target');
    }
  }
}

extension _FirstOrNullPlanned<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
