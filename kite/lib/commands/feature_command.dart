import 'package:args/command_runner.dart';
import '../core/generator.dart';
import '../core/json_loader.dart';

import '../core/path_helper.dart';
class FeatureCommand extends Command {
  @override
  final name = "feature";

  @override
  final description = "Generate a feature";

  FeatureCommand() {
    argParser.addFlag("clean");
  }

  @override
  void run() {
    final feature = argResults!.rest.first;

    final clean = argResults!["clean"];

    final templatedir = clean
        ? "templates/feature/clean.json"
        : "templates/feature/simple.json";
    final templatePath = PathHelper.template(templatedir);
    final template = JsonLoader.load(templatePath);

    Generator.generate(template, {
      "feature": feature,
    });

    print("✨ Feature $feature generated");
  }
}