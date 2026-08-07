import 'dart:io';
import 'package:args/command_runner.dart';

class RunCommand extends Command {
  @override
  final name = "run";

  @override
  final description = "Run Flutter application";

  @override
  Future<void> run() async {
    print("🚀 Running Flutter app...");

    await Process.start(
      "flutter",
      ["run"],
      mode: ProcessStartMode.inheritStdio,
    );
  }
}