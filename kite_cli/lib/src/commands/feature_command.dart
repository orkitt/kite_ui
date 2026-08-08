import 'package:args/command_runner.dart';

import '../cli/exit_codes.dart';
import '../generators/feature_generator.dart';
import '../generators/generation_options.dart';
import '../logging/kite_logger.dart';
import '../project/project_detector.dart';
import '../routing/route_target.dart';
import 'shared_command_options.dart';

final class FeatureCommand extends Command<int> {
  FeatureCommand({
    ProjectDetector projectDetector = const ProjectDetector(),
    FeatureGenerator generator = const FeatureGenerator(),
    KiteLogger logger = const KiteLogger(),
  }) : _projectDetector = projectDetector,
       _generator = generator,
       _logger = logger {
    addProjectPathOption(argParser);
    addGenerationOptions(argParser);
    argParser
      ..addOption(
        'architecture',
        abbr: 'a',
        defaultsTo: 'clean',
        allowed: const <String>['clean', 'mvc'],
        help: 'Feature architecture template.',
      )
      ..addFlag(
        'clean',
        negatable: false,
        help: 'Alias for --architecture clean.',
      )
      ..addFlag('mvc', negatable: false, help: 'Alias for --architecture mvc.')
      ..addFlag(
        'route',
        negatable: false,
        help: 'Generate and centrally register a GoRouter route.',
      )
      ..addOption(
        'into',
        valueHelp: 'branch',
        help: 'Attach the generated route to a configured shell branch.',
      )
      ..addFlag(
        'json',
        negatable: false,
        help: 'Generate json_serializable model/DTO setup.',
      );
  }

  final ProjectDetector _projectDetector;
  final FeatureGenerator _generator;
  final KiteLogger _logger;

  @override
  String get name => 'feature';

  @override
  List<String> get aliases => const <String>['f'];

  @override
  String get description => 'Generate a feature architecture module.';

  @override
  Future<int> run() async {
    final results = argResults!;
    if (results.rest.length != 1) {
      throw UsageException('Provide exactly one feature name.', usage);
    }

    final cleanFlag = results.flag('clean');
    final mvcFlag = results.flag('mvc');
    if (cleanFlag && mvcFlag) {
      throw UsageException('Use either --clean or --mvc, not both.', usage);
    }

    final includeRoute = results.flag('route');
    final into = results.option('into')?.trim();
    if (into != null && !includeRoute) {
      throw UsageException('--into requires --route.', usage);
    }
    if (into != null && into.isEmpty) {
      throw UsageException('--into requires a shell branch name.', usage);
    }

    final architecture = switch ((cleanFlag, mvcFlag)) {
      (_, true) => 'mvc',
      (true, _) => 'clean',
      _ => results.option('architecture')!,
    };
    final routeTarget = into == null
        ? const RouteTarget.root()
        : RouteTarget.branch(into);

    try {
      final project = _projectDetector.detect(results.option('path')!);
      await _generator.generate(
        project: project,
        featureName: results.rest.single,
        architecture: architecture,
        includeRoute: includeRoute,
        routeTarget: routeTarget,
        includeJsonSerialization: results.flag('json'),
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
