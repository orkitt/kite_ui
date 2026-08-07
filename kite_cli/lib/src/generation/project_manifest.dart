import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../templates/template_manifest.dart';
import '../version.dart';
import 'generation_plan.dart';
import 'generation_result.dart';

final class ManagedFileRecord {
  const ManagedFileRecord({
    required this.path,
    required this.checksum,
    required this.upgradePolicy,
  });

  final String path;
  final String checksum;
  final TemplateUpgradePolicy upgradePolicy;

  Map<String, Object?> toJson() => <String, Object?>{
    'path': path,
    'checksum': checksum,
    'upgradePolicy': upgradePolicy.name,
  };

  factory ManagedFileRecord.fromJson(Map<String, Object?> json) {
    return ManagedFileRecord(
      path: json['path'] as String,
      checksum: json['checksum'] as String,
      upgradePolicy: TemplateUpgradePolicy.parse(
        json['upgradePolicy'] as String?,
      ),
    );
  }
}

final class GenerationRecord {
  const GenerationRecord({
    required this.id,
    required this.templateId,
    required this.templateVersion,
    required this.variables,
    required this.files,
    required this.generatedAt,
  });

  final String id;
  final String templateId;
  final String templateVersion;
  final Map<String, Object?> variables;
  final List<ManagedFileRecord> files;
  final String generatedAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'templateId': templateId,
    'templateVersion': templateVersion,
    'variables': variables,
    'generatedAt': generatedAt,
    'files': files.map((item) => item.toJson()).toList(growable: false),
  };

  factory GenerationRecord.fromJson(Map<String, Object?> json) {
    return GenerationRecord(
      id: json['id'] as String,
      templateId: json['templateId'] as String,
      templateVersion: json['templateVersion'] as String,
      variables: Map<String, Object?>.from(
        json['variables']! as Map<Object?, Object?>,
      ),
      generatedAt: json['generatedAt'] as String,
      files: (json['files'] as List<Object?>? ?? const <Object?>[])
          .map(
            (item) => ManagedFileRecord.fromJson(
              Map<String, Object?>.from(item! as Map<Object?, Object?>),
            ),
          )
          .toList(growable: false),
    );
  }
}

final class KiteProjectManifest {
  const KiteProjectManifest({
    required this.schemaVersion,
    required this.kiteVersion,
    required this.generations,
  });

  factory KiteProjectManifest.empty() => const KiteProjectManifest(
    schemaVersion: kiteManifestSchemaVersion,
    kiteVersion: kiteCliVersion,
    generations: <GenerationRecord>[],
  );

  final int schemaVersion;
  final String kiteVersion;
  final List<GenerationRecord> generations;

  Map<String, Object?> toJson() => <String, Object?>{
    'schemaVersion': schemaVersion,
    'kiteVersion': kiteVersion,
    'generations': generations
        .map((item) => item.toJson())
        .toList(growable: false),
  };

  factory KiteProjectManifest.fromJson(Map<String, Object?> json) {
    return KiteProjectManifest(
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      kiteVersion: json['kiteVersion'] as String? ?? 'unknown',
      generations: (json['generations'] as List<Object?>? ?? const <Object?>[])
          .map(
            (item) => GenerationRecord.fromJson(
              Map<String, Object?>.from(item! as Map<Object?, Object?>),
            ),
          )
          .toList(growable: false),
    );
  }
}

final class ProjectManifestStore {
  const ProjectManifestStore();

  Future<KiteProjectManifest> read(Directory root) async {
    final file = File(p.join(root.path, '.kite', 'manifest.json'));
    if (!file.existsSync()) {
      return KiteProjectManifest.empty();
    }

    final json = jsonDecode(await file.readAsString());
    return KiteProjectManifest.fromJson(
      Map<String, Object?>.from(json as Map<Object?, Object?>),
    );
  }

  Future<void> record({
    required Directory root,
    required String generationId,
    required GenerationPlan plan,
    required GenerationResult result,
  }) async {
    final current = await read(root);
    final byPath = <String, PlannedFile>{
      for (final item in plan.files) item.relativePath: item,
    };
    final previous = current.generations
        .where((item) => item.id == generationId)
        .firstOrNull;
    final previousByPath = <String, ManagedFileRecord>{
      for (final item in previous?.files ?? const <ManagedFileRecord>[])
        item.path: item,
    };

    final files = result.files
        .map((item) {
          if (item.checksum != null) {
            return ManagedFileRecord(
              path: item.relativePath,
              checksum: item.checksum!,
              upgradePolicy: byPath[item.relativePath]!.upgradePolicy,
            );
          }
          return previousByPath[item.relativePath];
        })
        .whereType<ManagedFileRecord>()
        .toList(growable: false);

    final replacement = GenerationRecord(
      id: generationId,
      templateId: plan.templateId,
      templateVersion: plan.templateVersion,
      variables: plan.variables,
      files: files,
      generatedAt: DateTime.now().toUtc().toIso8601String(),
    );

    final generations = <GenerationRecord>[
      ...current.generations.where((item) => item.id != generationId),
      replacement,
    ]..sort((a, b) => a.id.compareTo(b.id));

    await _write(
      root,
      KiteProjectManifest(
        schemaVersion: kiteManifestSchemaVersion,
        kiteVersion: kiteCliVersion,
        generations: generations,
      ),
    );
  }

  Future<void> updateManagedChecksum({
    required Directory root,
    required String relativePath,
    required String checksum,
  }) async {
    final current = await read(root);
    var changed = false;
    final generations = current.generations
        .map((generation) {
          final files = generation.files
              .map((file) {
                if (file.path != relativePath) {
                  return file;
                }
                changed = true;
                return ManagedFileRecord(
                  path: file.path,
                  checksum: checksum,
                  upgradePolicy: file.upgradePolicy,
                );
              })
              .toList(growable: false);

          return GenerationRecord(
            id: generation.id,
            templateId: generation.templateId,
            templateVersion: generation.templateVersion,
            variables: generation.variables,
            files: files,
            generatedAt: generation.generatedAt,
          );
        })
        .toList(growable: false);

    if (changed) {
      await _write(
        root,
        KiteProjectManifest(
          schemaVersion: current.schemaVersion,
          kiteVersion: kiteCliVersion,
          generations: generations,
        ),
      );
    }
  }

  Future<void> replaceGeneration({
    required Directory root,
    required GenerationRecord record,
  }) async {
    final current = await read(root);
    final generations = <GenerationRecord>[
      ...current.generations.where((item) => item.id != record.id),
      record,
    ]..sort((a, b) => a.id.compareTo(b.id));

    await _write(
      root,
      KiteProjectManifest(
        schemaVersion: kiteManifestSchemaVersion,
        kiteVersion: kiteCliVersion,
        generations: generations,
      ),
    );
  }

  Future<void> _write(Directory root, KiteProjectManifest manifest) async {
    final file = File(p.join(root.path, '.kite', 'manifest.json'));
    await file.parent.create(recursive: true);
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString('${encoder.convert(manifest.toJson())}\n');
  }
}

extension _FirstOrNullGeneration<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
