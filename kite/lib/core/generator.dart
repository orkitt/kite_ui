import 'dart:io';
import 'dart:async';
import 'variable_resolver.dart';

class Generator {
  // Spinner characters
  static const _spinnerFrames = ['|', '/', '-', '\\'];

  // Animate a single-line spinner while executing a callback
  static Future<void> _withSpinner(
      String message, Future<void> Function() task) async {
    int i = 0;
    bool done = false;

    // Timer updates the spinner every 80ms
    final timer = Timer.periodic(Duration(milliseconds: 80), (_) {
      if (!done) {
        stdout.write('\r$message ${_spinnerFrames[i % _spinnerFrames.length]}');
        i++;
      }
    });

    // Run the actual task
    await task();

    // Mark done and cancel timer
    done = true;
    timer.cancel();

    // Print final message
    stdout.writeln('\r$message ✓ done');
  }

  // Main generate function
  static Future<void> generate(
      Map<String, dynamic> template, Map<String, String> vars) async {
    final folders = template['folders'] ?? [];
    final files = template['files'] ?? [];

    // 1️⃣ Create folders with spinner
    await _withSpinner('🔹 Creating folders', () async {
      for (final folder in folders) {
        final path = VariableResolver.resolve(folder, vars);
        Directory("lib/src/$path").createSync(recursive: true);
        await Future.delayed(Duration(milliseconds: 50)); // smooth effect
      }
    });

    // 2️⃣ Create files with spinner
    await _withSpinner('🔹 Creating files', () async {
      for (final file in files) {
        final path = VariableResolver.resolve(file['path'], vars);
        final content = VariableResolver.resolve(file['content'], vars);

        final fullPath = "lib/src/$path";

        File(fullPath).createSync(recursive: true);
        File(fullPath).writeAsStringSync(content);
        await Future.delayed(Duration(milliseconds: 30)); // smooth effect
      }
    });

    // 3️⃣ Final success message
    stdout.writeln('🎉 All files generated successfully!');
  }
}