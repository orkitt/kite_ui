import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

abstract final class FileChecksum {
  static String content(String value) =>
      'sha256:${sha256.convert(utf8.encode(value))}';

  static Future<String> file(File file) async =>
      'sha256:${sha256.convert(await file.readAsBytes())}';
}
