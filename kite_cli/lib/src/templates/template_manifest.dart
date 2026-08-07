final class TemplateManifest {
  const TemplateManifest({
    required this.schemaVersion,
    required this.id,
    required this.version,
    required this.description,
    required this.files,
    this.requires = const <String>[],
    this.dependencies = const <String>[],
    this.devDependencies = const <String>[],
  });

  final int schemaVersion;
  final String id;
  final String version;
  final String description;
  final List<TemplateFileDefinition> files;
  final List<String> requires;
  final List<String> dependencies;
  final List<String> devDependencies;

  factory TemplateManifest.fromJson(Map<String, Object?> json) {
    return TemplateManifest(
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      id: json['id'] as String,
      version: json['version'] as String,
      description: json['description'] as String? ?? '',
      files: (json['files'] as List<Object?>? ?? const <Object?>[])
          .map(
            (item) => TemplateFileDefinition.fromJson(
              Map<String, Object?>.from(item! as Map<Object?, Object?>),
            ),
          )
          .toList(growable: false),
      requires: _strings(json['requires']),
      dependencies: _strings(json['dependencies']),
      devDependencies: _strings(json['devDependencies']),
    );
  }

  static List<String> _strings(Object? value) {
    return (value as List<Object?>? ?? const <Object?>[])
        .whereType<String>()
        .toList(growable: false);
  }
}

enum TemplateUpgradePolicy {
  replace,
  preserve;

  static TemplateUpgradePolicy parse(String? value) {
    return value == 'preserve' ? preserve : replace;
  }
}

final class TemplateFileDefinition {
  const TemplateFileDefinition({
    required this.template,
    required this.target,
    this.condition,
    this.upgradePolicy = TemplateUpgradePolicy.replace,
  });

  final String template;
  final String target;
  final String? condition;
  final TemplateUpgradePolicy upgradePolicy;

  factory TemplateFileDefinition.fromJson(Map<String, Object?> json) {
    return TemplateFileDefinition(
      template: json['template'] as String,
      target: json['target'] as String,
      condition: json['condition'] as String?,
      upgradePolicy: TemplateUpgradePolicy.parse(
        json['upgradePolicy'] as String?,
      ),
    );
  }
}
