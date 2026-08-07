import 'package:args/args.dart';

import '../generation/conflict_strategy.dart';

void addProjectPathOption(ArgParser parser) {
  parser.addOption(
    'path',
    abbr: 'p',
    defaultsTo: '.',
    help: 'Flutter project directory.',
  );
}

void addGenerationOptions(ArgParser parser) {
  parser
    ..addFlag(
      'dry-run',
      negatable: false,
      help: 'Preview changes without writing files.',
    )
    ..addFlag(
      'force',
      negatable: false,
      help: 'Overwrite conflicting generated files.',
    )
    ..addFlag(
      'skip-existing',
      negatable: false,
      help: 'Skip files that already exist.',
    )
    ..addFlag(
      'dependencies',
      defaultsTo: true,
      help: 'Install dependencies required by generated code.',
    )
    ..addFlag(
      'format',
      defaultsTo: true,
      help: 'Run dart format after generation.',
    );
}

ConflictStrategy resolveConflictStrategy(ArgResults results) {
  if (results.flag('force')) {
    return ConflictStrategy.overwrite;
  }
  if (results.flag('skip-existing')) {
    return ConflictStrategy.skip;
  }
  return ConflictStrategy.ask;
}
