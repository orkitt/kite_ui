import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/generation_options.dart';
import '../generators/preset_generator.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import 'shared_command_options.dart';

final class StateCommand extends Command<int> {
  StateCommand({
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
  String get name => 'state';

  @override
  String get description => 'Generate production state-management foundations.';

  @override
  Future<int> run() async {
    final results = argResults!;
    if (results.rest.length != 1) {
      throw UsageException(
        'Provide a state preset. Available: riverpod.',
        usage,
      );
    }

    final preset = results.rest.single.toLowerCase();
    if (preset != 'riverpod') {
      throw UsageException(
        'Unsupported state preset: $preset. Available: riverpod.',
        usage,
      );
    }

    try {
      final project = _projectDetector.detect(results.option('path')!);
      await _generator.generate(
        project: project,
        templateIds: const <String>['state.riverpod'],
        label: 'Riverpod foundation',
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
