import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../logging/kite_logger.dart';
import '../templates/template_store.dart';

final class TemplatesCommand extends Command<int> {
  TemplatesCommand({
    TemplateStore templateStore = const TemplateStore(),
    KiteLogger logger = const KiteLogger(),
  })  : _templateStore = templateStore,
        _logger = logger {
    argParser.addFlag(
      'all',
      negatable: false,
      help: 'Include internal dependency templates.',
    );
  }

  final TemplateStore _templateStore;
  final KiteLogger _logger;

  @override
  String get name => 'templates';

  @override
  String get description => 'List bundled Kite templates.';

  @override
  Future<int> run() async {
    try {
      final includeInternal = argResults!.flag('all');
      final templates = await _templateStore.list();
      for (final template in templates) {
        if (template.internal && !includeInternal) {
          continue;
        }
        _logger.info(
          '${template.id.padRight(22)} ${template.version.padRight(8)} '
          '${template.name}',
        );
      }
      return ExitCodes.success;
    } on Object catch (error) {
      _logger.error(error.toString());
      return ExitCodes.software;
    }
  }
}
