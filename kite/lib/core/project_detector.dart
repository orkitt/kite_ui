import 'dart:io';

class ProjectDetector {
  static bool isFlutterProject() {
    return File("pubspec.yaml").existsSync();
  }
}