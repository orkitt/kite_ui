import 'dart:io';
import 'package:args/command_runner.dart';

class BuildCommand extends Command {
  @override
  final name = "build";

  @override
  final description = "Build Flutter application";

  @override
  Future<void> run() async {
    print("📦 Building Flutter app...");

    await Process.start(
      "flutter",
      ["build", "apk"],
      mode: ProcessStartMode.inheritStdio,
    );
  }
}