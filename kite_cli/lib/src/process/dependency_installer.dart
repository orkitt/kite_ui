import '../logging/kite_logger.dart';
import '../templates/template_manifest.dart';
import 'process_runner.dart';

final class DependencyInstaller {
  const DependencyInstaller({
    this.processRunner = const ProcessRunner(),
    this.logger = const KiteLogger(),
  });

  final ProcessRunner processRunner;
  final KiteLogger logger;

  Future<void> install({
    required String projectPath,
    required TemplateManifest manifest,
    List<String> extraDependencies = const <String>[],
    List<String> extraDevDependencies = const <String>[],
  }) {
    return installPackages(
      projectPath: projectPath,
      dependencies: <String>{
        ...manifest.dependencies,
        ...extraDependencies,
      },
      devDependencies: <String>{
        ...manifest.devDependencies,
        ...extraDevDependencies,
      },
    );
  }

  Future<void> installPackages({
    required String projectPath,
    Iterable<String> dependencies = const <String>[],
    Iterable<String> devDependencies = const <String>[],
  }) async {
    final runtimePackages = dependencies.toSet().toList()..sort();
    final developmentPackages = devDependencies.toSet().toList()..sort();

    if (runtimePackages.isNotEmpty) {
      logger.info('Installing Flutter dependencies...');
      await processRunner.runInherited(
        'flutter',
        <String>['pub', 'add', ...runtimePackages],
        workingDirectory: projectPath,
      );
    }

    if (developmentPackages.isNotEmpty) {
      logger.info('Installing development dependencies...');
      await processRunner.runInherited(
        'flutter',
        <String>['pub', 'add', '--dev', ...developmentPackages],
        workingDirectory: projectPath,
      );
    }
  }
}
