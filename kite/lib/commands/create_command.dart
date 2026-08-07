import 'dart:io';
import 'package:args/command_runner.dart';
import '../core/json_loader.dart';
import '../core/generator.dart';
import '../core/path_helper.dart';

class CreateCommand extends Command {
  @override
  final name = "create";

  @override
  final description = "Create a new Flutter project structure";

  CreateCommand() {
    argParser.addFlag(
      "riverpod",
      negatable: false,
      help: "Use Riverpod architecture",
    );

    argParser.addOption(
      "org",
      help: "Organization identifier (e.g. dev.kite)",
      defaultsTo: "dev.kite",
    );
  }

  @override
  Future<void> run() async {
    final args = argResults!.rest;

    if (args.isEmpty) {
      print("❌ Please provide a project name:");
      print("lite create my_app --org com.example --riverpod");
      return;
    }

    final projectName = args.first;
   final useRiverpod = argResults!.wasParsed('riverpod') 
    ? argResults!['riverpod'] as bool 
    : false;
    final org = argResults!["org"];

    // 1️⃣ Run flutter create
    print("🚀 Loading boosters for $projectName ...");

    final result = await Process.run("flutter", [
      "create",
      projectName,
      "--org",
      org,
    ], runInShell: true);

    if (result.exitCode != 0) {
      print("❌ Flutter create failed:\n${result.stderr}");
      return;
    }

    logStep("Flutter project $projectName created.");

    // 2️⃣ Load template JSON
   final templateDir = useRiverpod
    ? "templates/app/riverpod.json"
    : "templates/app/default.json";

    final templatePath = PathHelper.template(templateDir);
    final template = JsonLoader.load(templatePath);

    // 3️⃣ Generate additional folders/files
    final projectPath = "${Directory.current.path}/$projectName";

    Directory.current = Directory(projectPath);

    Generator.generate(template, {"app": projectName, "org": org});

    logStep("$projectName is ready with Kite scaffolding! 🪁");

    /// 2️⃣ Move into project directory
    Directory.current = Directory(projectPath);

    /// 3️⃣ Add dependencies
    await _addDependencies(useRiverpod);

    /// 4️⃣ Add dev dependencies
    await _addDevDependencies();

      /// Open the project in VS Code
    logStep("Opening project in VS Code...");
    await Process.run(
      "code",
      [projectPath],
      runInShell: true,
    );
  }

  Future<void> _addDependencies(bool riverpod) async {
    logStep("Adding dependencies...");

    final deps = ["flutter_addons", "shared_preferences", "go_router"];

    if (riverpod) {
      deps.addAll(["flutter_riverpod", "hooks_riverpod"]);
    }

    // print("➜ flutter pub add ${deps.join(" ")}");
    logStep(  "Installing dependencies [${deps.length}]...");

    final result = await Process.run("flutter", [
      "pub",
      "add",
      ...deps,
    ], runInShell: true);

    if (result.exitCode != 0) {
      print("❌ Failed to add dependencies");
      print(result.stderr);
      return;
    }

    logStep("Dependencies added");
  }

  Future<void> _addDevDependencies() async {
    logStep("Adding dev dependencies...");

    final devDeps = ["build_runner", "json_serializable", "freezed"];

    //print("➜ flutter pub add --dev ${devDeps.join(" ")}");
    logStep("Installing dev dependencies [${devDeps.length}]...");

    final result = await Process.run("flutter", [
      "pub",
      "add",
      "--dev",
      ...devDeps,
    ], runInShell: true);

    if (result.exitCode != 0) {
      print("❌ Failed to add dev dependencies");
      print(result.stderr);
      return;
    }

    logStep("Dev dependencies added");



  }

  void logStep(String message) {
    stdout.writeln("🔹 $message");
  }
}
