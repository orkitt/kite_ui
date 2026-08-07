import 'dart:io';

final class ProcessExecutionException implements Exception {
  const ProcessExecutionException({
    required this.executable,
    required this.arguments,
    required this.exitCode,
  });

  final String executable;
  final List<String> arguments;
  final int exitCode;

  @override
  String toString() =>
      '$executable ${arguments.join(' ')} failed with exit code $exitCode.';
}

final class ProcessRunner {
  const ProcessRunner();

  Future<void> runInherited(
    String executable,
    List<String> arguments, {
    required String workingDirectory,
  }) async {
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
    );
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw ProcessExecutionException(
        executable: executable,
        arguments: arguments,
        exitCode: exitCode,
      );
    }
  }

  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    required String workingDirectory,
  }) {
    return Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      runInShell: Platform.isWindows,
    );
  }
}
