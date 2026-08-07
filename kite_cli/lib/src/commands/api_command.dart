import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/generation_options.dart';
import '../generators/preset_generator.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import 'shared_command_options.dart';

final class ApiCommand extends Command<int> {
  ApiCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    PresetGenerator generator = const PresetGenerator(),
    KiteLogger logger = const KiteLogger(),
  }) : _projectDetector = projectDetector,
       _generator = generator,
       _logger = logger {
    addProjectPathOption(argParser);
    addGenerationOptions(argParser);
  }

  final ProjectDetector _projectDetector;
  final PresetGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'api';

  @override
  String get description => 'Generate a production API client foundation.';

  @override
  Future<int> run() async {
    final results = argResults!;
    if (results.rest.length != 1) {
      throw UsageException('Provide an API preset. Available: dio.', usage);
    }

    final preset = results.rest.single.toLowerCase();
    if (preset != 'dio') {
      throw UsageException(
        'Unsupported API preset: $preset. Available: dio.',
        usage,
      );
    }

    try {
      final project = _projectDetector.detect(results.option('path')!);
      await _generator.generate(
        project: project,
        templateIds: const <String>['api.dio'],
        label: 'Dio API foundation',
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
