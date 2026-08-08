import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/generation_options.dart';
import '../generators/sync_generator.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import 'shared_command_options.dart';

final class SyncCommand extends Command<int> {
  SyncCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    SyncGenerator generator = const SyncGenerator(),
    KiteLogger logger = const KiteLogger(),
  }) : _projectDetector = projectDetector,
       _generator = generator,
       _logger = logger {
    addProjectPathOption(argParser);
    addGenerationOptions(argParser);
  }

  final ProjectDetector _projectDetector;
  final SyncGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'sync';

  @override
  String get description =>
      'Reconcile Kite-owned project infrastructure from kite.yaml.';

  @override
  Future<int> run() async {
    final results = argResults!;
    try {
      final project = _projectDetector.detect(results.option('path')!);
      await _generator.sync(
        project: project,
        options: GenerationOptions(
          conflictStrategy: resolveConflictStrategy(results),
          dryRun: results.flag('dry-run'),
          installDependencies: results.flag('dependencies'),
          format: results.flag('format'),
        ),
      );
      return ExitCodes.success;
    } on ProjectDetectionException catch (error) {
      _logger.error(error.message);
      return ExitCodes.configuration;
    } on Object catch (error) {
      _logger.error(error.toString());
      return ExitCodes.software;
    }
  }
}
