import '../generation/conflict_strategy.dart';

final class GenerationOptions {
  const GenerationOptions({
    required this.conflictStrategy,
    required this.dryRun,
    required this.installDependencies,
    required this.format,
  });

  final ConflictStrategy conflictStrategy;
  final bool dryRun;
  final bool installDependencies;
  final bool format;
}
