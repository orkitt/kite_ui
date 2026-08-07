import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;

import 'template_descriptor.dart';
import 'template_manifest.dart';

final class LoadedTemplate {
  const LoadedTemplate({
    required this.descriptor,
    required this.manifest,
    required this.directory,
  });

  final TemplateDescriptor descriptor;
  final TemplateManifest manifest;
  final Directory directory;
}

final class TemplateStore {
  const TemplateStore();

  Future<List<TemplateDescriptor>> list() async {
    final root = await _root();
    final registry = File(p.join(root.path, 'registry.json'));
    final json = jsonDecode(await registry.readAsString());
    final map = Map<String, Object?>.from(json as Map<Object?, Object?>);

    return (map['templates'] as List<Object?>? ?? const <Object?>[])
        .map(
          (item) => TemplateDescriptor.fromJson(
            Map<String, Object?>.from(item! as Map<Object?, Object?>),
          ),
        )
        .toList(growable: false);
  }

  Future<LoadedTemplate> load(String id) async {
    final root = await _root();
    final descriptors = await list();
    final descriptor = descriptors.where((item) => item.id == id).firstOrNull;

    if (descriptor == null) {
      throw ArgumentError.value(id, 'id', 'Unknown Kite template');
    }

    final manifestFile = File(p.join(root.path, descriptor.manifestPath));
    final json = jsonDecode(await manifestFile.readAsString());
    final manifest = TemplateManifest.fromJson(
      Map<String, Object?>.from(json as Map<Object?, Object?>),
    );

    return LoadedTemplate(
      descriptor: descriptor,
      manifest: manifest,
      directory: manifestFile.parent,
    );
  }

  Future<List<LoadedTemplate>> resolve(String id) async {
    final resolved = <LoadedTemplate>[];
    final visited = <String>{};
    final visiting = <String>{};

    Future<void> visit(String templateId) async {
      if (visited.contains(templateId)) {
        return;
      }
      if (!visiting.add(templateId)) {
        throw StateError('Circular template dependency detected: $templateId');
      }

      final template = await load(templateId);
      for (final dependencyId in template.manifest.requires) {
        await visit(dependencyId);
      }

      visiting.remove(templateId);
      visited.add(templateId);
      resolved.add(template);
    }

    await visit(id);
    return List<LoadedTemplate>.unmodifiable(resolved);
  }

  Future<Directory> _root() async {
    final uri = await Isolate.resolvePackageUri(
      Uri.parse('package:kite/src/templates/registry.json'),
    );

    if (uri == null || uri.scheme != 'file') {
      throw StateError('Unable to locate Kite bundled templates.');
    }

    return File.fromUri(uri).parent;
  }
}

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
