import 'dart:io';
import 'package:path/path.dart' as p;

class PathHelper {
  /// Get absolute path for a template file inside the CLI
  static String template(String relativePath) {
    // Path to the script being executed (bin/kite.dart)
    final scriptDir = p.dirname(Platform.script.toFilePath());

    // Join with the relative path
    final fullPath = p.normalize(p.join(scriptDir, "../$relativePath"));

    if (!File(fullPath).existsSync()) {
      throw Exception("Template not found: $relativePath\nChecked: $fullPath");
    }

    return fullPath;
  }

  /// Optional: project root path
  static String projectRoot() {
    return Directory.current.path;
  }
}