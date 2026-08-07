import '../logging/kite_logger.dart';
import 'process_runner.dart';

final class DartFormatter {
  const DartFormatter({
    this.processRunner = const ProcessRunner(),
    this.logger = const KiteLogger(),
  });

  final ProcessRunner processRunner;
  final KiteLogger logger;

  Future<void> format(String projectPath) async {
    final result = await processRunner.run('dart', const <String>[
      'format',
      'lib',
    ], workingDirectory: projectPath);

    if (result.exitCode != 0) {
      logger.warning('dart format failed; generated files were kept.');
      final stderrText = result.stderr.toString().trim();
      if (stderrText.isNotEmpty) {
        logger.detail(stderrText);
      }
    }
  }
}
