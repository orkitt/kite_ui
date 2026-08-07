import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

import '../cli/exit_codes.dart';
import '../logging/kite_logger.dart';
import '../process/process_runner.dart';
import '../project/project_detector.dart';
import '../templates/template_store.dart';
import 'shared_command_options.dart';

final class DoctorCommand extends Command<int> {
  DoctorCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    TemplateStore templateStore = const TemplateStore(),
    ProcessRunner processRunner = const ProcessRunner(),
    KiteLogger logger = const KiteLogger(),
  })  : _projectDetector = projectDetector,
        _templateStore = templateStore,
        _processRunner = processRunner,
        _logger = logger {
    addProjectPathOption(argParser);
  }

  final ProjectDetector _projectDetector;
  final TemplateStore _templateStore;
  final ProcessRunner _processRunner;
  final KiteLogger _logger;

  @override
  String get name => 'doctor';

  @override
  String get description => 'Validate the Flutter and Kite environment.';

  @override
  Future<int> run() async {
    var healthy = true;
    _logger.success('Dart ${Platform.version.split(' ').first}');

    final path = p.normalize(p.absolute(argResults!.option('path')!));
    try {
      final flutter = await _processRunner.run(
        'flutter',
        const <String>['--version'],
        workingDirectory: Directory.current.path,
      );
      if (flutter.exitCode == 0) {
        final firstLine = flutter.stdout.toString().split('\n').first.trim();
        _logger.success(firstLine.isEmpty ? 'Flutter available' : firstLine);
      } else {
        healthy = false;
        _logger.error('Flutter executable was not found or failed.');
      }
    } on ProcessException {
      healthy = false;
      _logger.error('Flutter executable was not found.');
    }

    try {
      final project = _projectDetector.detect(path);
      _logger.success('Flutter project: ${project.name}');
      final manifest = File(p.join(project.root.path, '.kite', 'manifest.json'));
      if (manifest.existsSync()) {
        _logger.success('Kite project manifest found');
      } else {
        _logger.warning('Kite is not initialized in this project');
      }
    } on Object catch (error) {
      healthy = false;
      _logger.error(error.toString());
    }

    try {
      final templates = await _templateStore.list();
      _logger.success('${templates.length} bundled templates available');
    } on Object catch (error) {
      healthy = false;
      _logger.error(error.toString());
    }

    return healthy ? ExitCodes.success : ExitCodes.unavailable;
  }
}
