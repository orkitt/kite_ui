import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/generation_options.dart';
import '../generators/preset_generator.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import 'shared_command_options.dart';

final class ComponentCommand extends Command<int> {
  ComponentCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    PresetGenerator generator = const PresetGenerator(),
    KiteLogger logger = const KiteLogger(),
  })  : _projectDetector = projectDetector,
        _generator = generator,
        _logger = logger {
    addProjectPathOption(argParser);
    addGenerationOptions(argParser);
  }

  static const _supported = <String>{'button', 'card', 'avatar'};

  final ProjectDetector _projectDetector;
  final PresetGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'component';

  @override
  List<String> get aliases => const <String>['widget', 'components'];

  @override
  String get description =>
      'Generate reusable shared components and their required support files.';

  @override
  Future<int> run() async {
    final results = argResults!;
    final components = _parseComponents(results.rest);
    if (components.isEmpty) {
      throw UsageException(
        'Provide one or more components: button, card, avatar.',
        usage,
      );
    }

    final unsupported = components.where((item) => !_supported.contains(item));
    if (unsupported.isNotEmpty) {
      throw UsageException(
        'Unsupported component(s): ${unsupported.join(', ')}. '
        'Available: ${_supported.join(', ')}.',
        usage,
      );
    }

    try {
      final project = _projectDetector.detect(results.option('path')!);
      await _generator.generate(
        project: project,
        templateIds: components
            .map((component) => 'component.$component')
            .toList(growable: false),
        label: 'components `${components.join(', ')}`',
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

  List<String> _parseComponents(List<String> arguments) {
    final normalized = arguments
        .join(' ')
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('avater', 'avatar');
    final values = normalized
        .split(RegExp(r'[\s,]+'))
        .map((item) => item.trim().toLowerCase())
        .where((item) => item.isNotEmpty);

    return <String>{...values}.toList(growable: false);
  }
}
