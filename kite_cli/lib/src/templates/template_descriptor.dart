final class TemplateDescriptor {
  const TemplateDescriptor({
    required this.id,
    required this.name,
    required this.type,
    required this.version,
    required this.manifestPath,
    this.internal = false,
  });

  final String id;
  final String name;
  final String type;
  final String version;
  final String manifestPath;
  final bool internal;

  factory TemplateDescriptor.fromJson(Map<String, Object?> json) {
    return TemplateDescriptor(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      version: json['version'] as String,
      manifestPath: json['manifest'] as String,
      internal: json['internal'] as bool? ?? false,
    );
  }
}
