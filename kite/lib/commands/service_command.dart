import 'package:args/command_runner.dart';

import '../core/generator.dart';
import '../core/json_loader.dart';
import '../core/path_helper.dart';


// templates/
//  └ service/
//     ├ api_http.json
//     ├ api_dio.json
//     ├ api_retrofit.json
//     ├ firebase.json
//     ├ supabase.json
//     ├ sharedpref.json
//     ├ hive.json
//     └ drift.json


class ServiceCommand extends Command {
  @override
  final name = "service";

  @override
  final description = "Generate a service";

  ServiceCommand() {
    argParser
      ..addFlag("http", negatable: false)
      ..addFlag("dio", negatable: false)
      ..addFlag("retrofit", negatable: false);
  }

  @override
  void run() {
    if (argResults!.rest.isEmpty) {
      print("❌ Please provide a service name.");
      return;
    }

    final service = argResults!.rest.first;

   // final bool http = argResults!["http"] as bool;
    final bool dio = argResults!["dio"] as bool;
    final bool retrofit = argResults!["retrofit"] as bool;

    String templatePath;

    // API services
    if (service == "api") {
      if (dio) {
        templatePath = "templates/service/api_dio.json";
      } else if (retrofit) {
        templatePath = "templates/service/api_retrofit.json";
      } else {
        templatePath = "templates/service/api_http.json";
      }
    } 
    // Other services
    else {
      templatePath = "templates/service/$service.json";
    }

    final resolvedPath = PathHelper.template(templatePath);
    final template = JsonLoader.load(resolvedPath);

    Generator.generate(template, {
      "service": service,
    });

    print("✨ Service $service generated");
  }
}