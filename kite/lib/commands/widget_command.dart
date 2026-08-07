import 'package:args/command_runner.dart';

import '../core/generator.dart';
import '../core/json_loader.dart';

class WidgetCommand extends Command {
  @override
  final name = "widget";

  @override
  final description = "Generate a reusable widget";

  @override
  void run() {
    final widget = argResults!.rest.first;

    final template = JsonLoader.load("templates/widget/widget.json");

    Generator.generate(template, {
      "widget": widget,
    });

    print("🧩 Widget $widget generated");
  }
}