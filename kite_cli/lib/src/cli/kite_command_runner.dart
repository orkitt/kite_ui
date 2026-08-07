import 'package:args/command_runner.dart';

import '../commands/api_command.dart';
import '../commands/component_command.dart';
import '../commands/doctor_command.dart';
import '../commands/feature_command.dart';
import '../commands/init_command.dart';
import '../commands/state_command.dart';
import '../commands/templates_command.dart';
import '../commands/upgrade_command.dart';
import '../logging/kite_logger.dart';
import '../version.dart';
import 'argument_normalizer.dart';
import 'exit_codes.dart';

final class KiteCommandRunner extends CommandRunner<int> {
  KiteCommandRunner({KiteLogger logger = const KiteLogger()})
    : _logger = logger,
      super(
        'kite',
        'Initialize professional Flutter foundations and generate '
            'features, components, state, and API infrastructure.',
      ) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the installed Kite version.',
    );
    addCommand(InitCommand(logger: logger));
    addCommand(FeatureCommand(logger: logger));
    addCommand(ComponentCommand(logger: logger));
    addCommand(StateCommand(logger: logger));
    addCommand(ApiCommand(logger: logger));
    addCommand(DoctorCommand(logger: logger));
    addCommand(TemplatesCommand(logger: logger));
    addCommand(UpgradeCommand(logger: logger));
  }

  final KiteLogger _logger;

  Future<int> execute(List<String> arguments) async {
    final normalized = normalizeArguments(arguments);

    if (normalized.contains('--version') || normalized.contains('-v')) {
      _logger.info('kite $kiteCliVersion');
      return ExitCodes.success;
    }

    if (normalized.isEmpty) {
      _logger.info(usage);
      return ExitCodes.usage;
    }

    try {
      return await run(normalized) ?? ExitCodes.success;
    } on UsageException catch (error) {
      _logger.error(error.message);
      _logger.info(error.usage);
      return ExitCodes.usage;
    } on Object catch (error) {
      _logger.error(error.toString());
      return ExitCodes.software;
    }
  }
}
