import '../templates/template_manifest.dart';

final class PlannedFile {
  const PlannedFile({
    required this.relativePath,
    required this.content,
    required this.templatePath,
    required this.upgradePolicy,
  });

  final String relativePath;
  final String content;
  final String templatePath;
  final TemplateUpgradePolicy upgradePolicy;
}

final class GenerationPlan {
  const GenerationPlan({
    required this.templateId,
    required this.templateVersion,
    required this.variables,
    required this.files,
  });

  final String templateId;
  final String templateVersion;
  final Map<String, Object?> variables;
  final List<PlannedFile> files;
}
