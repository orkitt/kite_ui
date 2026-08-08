import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/generation_options.dart';
import '../generators/project_generator.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import '../project/project_preset.dart';
import 'shared_command_options.dart';

final class InitCommand extends Command<int> {
  InitCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    ProjectGenerator generator = const ProjectGenerator(),
    KiteLogger logger = const KiteLogger(),
  }) : _projectDetector = projectDetector,
       _generator = generator,
       _logger = logger {
    addProjectPathOption(argParser);
    addGenerationOptions(argParser);
    argParser
      ..addFlag(
        'vanilla',
        negatable: false,
        help:
            'Initialize a lightweight Material3 vanilla Flutter project foundation.',
      )
      ..addFlag('vanila', negatable: false, hide: true);
  }

  final ProjectDetector _projectDetector;
  final ProjectGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'init';

  @override
  String get description =>
      'Initialize theme, routing, shared components, and project foundations.';

  @override
  Future<int> run() async {
    final results = argResults!;
    try {
      final project = _projectDetector.detect(results.option('path')!);
      final useVanilla = results.flag('vanilla') || results.flag('vanila');
      final preset = useVanilla ? ProjectPreset.vanilla : ProjectPreset.clean;

      _logger.info(
        'Initializing Kite ${preset.name} foundation in ${project.name}...',
      );

      await _generator.generate(
        project: project,
        preset: preset,
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
