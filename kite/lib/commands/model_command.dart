import 'package:args/command_runner.dart';

import '../core/generator.dart';
import '../core/json_loader.dart';

class ModelCommand extends Command {
  @override
  final name = "model";

  @override
  final description = "Generate a model";

  @override
  void run() {
    final model = argResults!.rest.first;

    final template = JsonLoader.load("templates/model/model.json");

    Generator.generate(template, {
      "model": model,
    });

    print("📦 Model $model generated");
  }
}