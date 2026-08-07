import 'package:args/command_runner.dart';

import '../core/generator.dart';
import '../core/json_loader.dart';

class RouteCommand extends Command {
  @override
  final name = "route";

  @override
  final description = "Generate a route";

  @override
  void run() {
    final route = argResults!.rest.first;

    final template = JsonLoader.load("templates/route/route.json");

    Generator.generate(template, {
      "route": route,
    });

    print("🛣 Route $route generated");
  }
}