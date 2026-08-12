import 'dart:io';

import '../generation/file_checksum.dart';
import '../generation/project_manifest.dart';
import '../project/flutter_project.dart';
import '../project/kite_config.dart';
import 'generation_options.dart';
import 'preset_generator.dart';

final class DatabaseGenerator {
  const DatabaseGenerator({
    this.presetGenerator = const PresetGenerator(),
    this.configStore = const KiteConfigStore(),
    this.manifestStore = const ProjectManifestStore(),
  });

  final PresetGenerator presetGenerator;
  final KiteConfigStore configStore;
  final ProjectManifestStore manifestStore;

  Future<void> generateIsar({
    required FlutterProject project,
    required GenerationOptions options,
  }) async {
    final configFile = File('${project.root.path}/kite.yaml');
    if (!configFile.existsSync()) {
      throw StateError('kite.yaml not found. Run `kite init` first.');
    }

    final config = KiteConfig.load(project.root);
    if (config.projectPreset == 'vanilla') {
      throw StateError(
        '`kite --db:isar` is not available for the vanilla preset. '
        'The vanilla template is intentionally kept independent.',
      );
    }

    await presetGenerator.generate(
      project: project,
      templateIds: const <String>['db.isar'],
      label: 'Isar offline database foundation',
      options: options,
    );

    if (options.dryRun) {
      return;
    }

    await configStore.writeDatabase(
      projectRoot: project.root,
      database: const KiteDatabaseConfig(enabled: true, type: 'isar'),
    );
    await manifestStore.updateManagedChecksum(
      root: project.root,
      relativePath: 'kite.yaml',
      checksum: FileChecksum.content(await configFile.readAsString()),
    );
  }
}
