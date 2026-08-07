import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/upgrade_generator.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import 'shared_command_options.dart';

final class UpgradeCommand extends Command<int> {
  UpgradeCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    UpgradeGenerator generator = const UpgradeGenerator(),
    KiteLogger logger = const KiteLogger(),
  }) : _projectDetector = projectDetector,
       _generator = generator,
       _logger = logger {
    addProjectPathOption(argParser);
    argParser
      ..addFlag(
        'dry-run',
        negatable: false,
        help: 'Preview template upgrades without writing files.',
      )
      ..addFlag(
        'force',
        negatable: false,
        help: 'Replace manually modified Kite-managed files.',
      );
  }

  final ProjectDetector _projectDetector;
  final UpgradeGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'upgrade';

  @override
  String get description => 'Upgrade safe Kite-managed files from templates.';

  @override
  Future<int> run() async {
    try {
      final project = _projectDetector.detect(argResults!.option('path')!);
      await _generator.upgrade(
        project: project,
        dryRun: argResults!.flag('dry-run'),
        force: argResults!.flag('force'),
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
