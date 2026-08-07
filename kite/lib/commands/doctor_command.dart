import 'dart:io';
import 'package:args/command_runner.dart';

class DoctorCommand extends Command {
  @override
  final name = "doctor";

  @override
  final description = "Check project health and structure";

  @override
  void run() {
    print("🔎 Running Kite Doctor...\n");

    _checkFlutterProject();
    _checkFolders();
    _checkDependencies();

    print("\n✅ Doctor check completed");
  }

  void _checkFlutterProject() {
    final exists = File("pubspec.yaml").existsSync();

    if (exists) {
      print("✔ Flutter project detected");
    } else {
      print("❌ Not a Flutter project");
    }
  }

  void _checkFolders() {
    final folders = [
      "lib/core",
      "lib/features",
      "lib/services",
      "lib/routes",
      "lib/shared",
    ];

    for (final folder in folders) {
      if (Directory(folder).existsSync()) {
        print("✔ $folder exists");
      } else {
        print("⚠ $folder missing");
      }
    }
  }

  void _checkDependencies() {
    final pubspec = File("pubspec.yaml");

    if (!pubspec.existsSync()) return;

    final content = pubspec.readAsStringSync();

    final packages = [
      "flutter_riverpod",
      "dio",
      "http",
      "hive",
      "drift",
      "supabase_flutter",
      "firebase_core"
    ];

    for (final pkg in packages) {
      if (content.contains(pkg)) {
        print("✔ $pkg installed");
      } else {
        print("⚠ $pkg not installed");
      }
    }
  }
}