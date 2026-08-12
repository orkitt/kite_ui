import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/database_generator.dart';
import '../generators/generation_options.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import 'shared_command_options.dart';

final class DatabaseCommand extends Command<int> {
  DatabaseCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    DatabaseGenerator generator = const DatabaseGenerator(),
    KiteLogger logger = const KiteLogger(),
  }) : _projectDetector = projectDetector,
       _generator = generator,
       _logger = logger {
    addProjectPathOption(argParser);
    addGenerationOptions(argParser);
  }

  final ProjectDetector _projectDetector;
  final DatabaseGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'db';

  @override
  String get description => 'Generate an offline database foundation.';

  @override
  Future<int> run() async {
    final results = argResults!;
    if (results.rest.length != 1) {
      throw UsageException('Provide a database preset. Available: isar.', usage);
    }

    final preset = results.rest.single.toLowerCase();
    if (preset != 'isar') {
      throw UsageException(
        'Unsupported database preset: $preset. Available: isar.',
        usage,
      );
    }

    try {
      final project = _projectDetector.detect(results.option('path')!);
      await _generator.generateIsar(
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
