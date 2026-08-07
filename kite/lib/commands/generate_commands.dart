import 'dart:io';
import 'package:args/command_runner.dart';

class GenerateCommand extends Command {
  @override
  final name = "generate";

  @override
  final description = "Install dev dependencies";

  @override
  Future<void> run() async {
    print("🧪 Running build_runner...");

    final result = await Process.run(
      "dart",
      ["pub", "run", "build_runner", "build", "--delete-conflicting-outputs"],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      print("❌ Failed to generate files");
      print(result.stderr);
      return;
    }

    print("✅ Code generation completed");
  }
}