import 'dart:convert';
import 'dart:io';

class JsonLoader {
  static Map<String, dynamic> load(String path) {
    final file = File(path);

    if (!file.existsSync()) {
      throw Exception("Template not found: $path");
    }

    final content = file.readAsStringSync();
    return jsonDecode(content);
  }
}