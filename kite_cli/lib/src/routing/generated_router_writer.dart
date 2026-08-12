import 'dart:io';

import 'package:path/path.dart' as p;

import '../generation/conflict_strategy.dart';
import '../generation/file_checksum.dart';
import '../generation/file_writer.dart';
import '../generation/generation_plan.dart';
import '../generation/generation_result.dart';
import '../generation/project_manifest.dart';
import '../naming/name_converter.dart';
import '../project/kite_config.dart';
import '../templates/template_manifest.dart';
import '../templates/template_renderer.dart';
import '../templates/template_store.dart';

final class GeneratedRouterWriter {
  const GeneratedRouterWriter({
    this.fileWriter = const FileWriter(),
    this.manifestStore = const ProjectManifestStore(),
    this.templateStore = const TemplateStore(),
    this.templateRenderer = const TemplateRenderer(),
  });

  final FileWriter fileWriter;
  final ProjectManifestStore manifestStore;
  final TemplateStore templateStore;
  final TemplateRenderer templateRenderer;

  Future<GenerationResult> writeGeneratedRoutes({
    required Directory projectRoot,
    required KiteConfig config,
    required KiteRoutingConfig routing,
    required bool dryRun,
  }) async {
    final template = await templateStore.load('routing.go_router');
    final files = await buildGeneratedFiles(config: config, routing: routing);
    final plan = GenerationPlan(
      templateId: template.manifest.id,
      templateVersion: template.manifest.version,
      variables: <String, Object?>{
        'routing': <String, Object?>{
          'shell': routing.shell.enabled,
          'branches': routing.shell.branches.map((item) => item.name).toList(),
          'routes': routing.routes.map((item) => item.path).toList(),
        },
      },
      files: files.entries
          .map(
            (entry) => PlannedFile(
              relativePath: entry.key,
              content: entry.value,
              templatePath: 'routing.go_router:${entry.key}',
              upgradePolicy: TemplateUpgradePolicy.replace,
            ),
          )
          .toList(growable: false),
    );

    final previousManifest = await manifestStore.read(projectRoot);
    final previous = previousManifest.generations
        .where((item) => item.id == 'routing.generated')
        .firstOrNull;

    final result = await fileWriter.write(
      root: projectRoot,
      plan: plan,
      conflictStrategy: ConflictStrategy.overwrite,
      dryRun: dryRun,
    );

    if (!dryRun) {
      final currentPaths = files.keys.toSet();
      for (final stale in previous?.files ?? const <ManagedFileRecord>[]) {
        if (currentPaths.contains(stale.path)) {
          continue;
        }
        final file = File(_absolutePath(projectRoot, stale.path));
        if (file.existsSync()) {
          await file.delete();
          await _deleteEmptyGeneratedParents(file.parent, projectRoot, config);
        }
      }

      await manifestStore.record(
        root: projectRoot,
        generationId: 'routing.generated',
        plan: plan,
        result: result,
      );
      for (final file in result.files) {
        if (file.checksum == null) {
          continue;
        }
        await manifestStore.updateManagedChecksum(
          root: projectRoot,
          relativePath: file.relativePath,
          checksum: file.checksum!,
        );
      }
    }
    return result;
  }

  Future<GenerationResult> writeShell({
    required Directory projectRoot,
    required String sourceDirectory,
    required KiteShellConfig shell,
    required ConflictStrategy conflictStrategy,
    required bool dryRun,
  }) async {
    if (!shell.enabled || shell.branches.isEmpty) {
      return const GenerationResult(<GeneratedFileResult>[]);
    }
    final template = await templateStore.load('routing.go_router');
    final relativePath = p.posix.join(
      _portable(sourceDirectory),
      'app',
      'router',
      'app_shell.dart',
    );
    final content = await buildAppShell(shell);
    final plan = GenerationPlan(
      templateId: 'routing.shell',
      templateVersion: template.manifest.version,
      variables: <String, Object?>{
        'branches': shell.branches.map((item) => item.name).toList(),
      },
      files: <PlannedFile>[
        PlannedFile(
          relativePath: relativePath,
          content: content,
          templatePath: 'routing.go_router:files/app_shell.dart.tmpl',
          upgradePolicy: TemplateUpgradePolicy.preserve,
        ),
      ],
    );

    final effectiveStrategy = await _safeShellConflictStrategy(
      projectRoot: projectRoot,
      relativePath: relativePath,
      requested: conflictStrategy,
    );
    final result = await fileWriter.write(
      root: projectRoot,
      plan: plan,
      conflictStrategy: effectiveStrategy,
      dryRun: dryRun,
    );
    if (!dryRun) {
      await manifestStore.record(
        root: projectRoot,
        generationId: 'routing.shell',
        plan: plan,
        result: result,
      );
    }
    return result;
  }

  Future<Map<String, String>> buildGeneratedFiles({
    required KiteConfig config,
    required KiteRoutingConfig routing,
  }) async {
    if (routing.shell.enabled && routing.shell.branches.isEmpty) {
      throw StateError(
        'routing.shell.enabled is true but no shell branches are configured.',
      );
    }

    final template = await templateStore.load('routing.go_router');
    final source = _portable(config.sourceDirectory);
    final base = p.posix.join(source, 'app', 'router', 'generated');
    final files = <String, String>{};

    for (final route in routing.routes) {
      final feature = NameConverter(route.feature);
      files[p.posix.join(base, 'features', '${feature.snakeCase}_route.dart')] =
          await _buildFeatureRoute(template, config, route, feature);
    }

    files[p.posix.join(base, 'root_routes.dart')] =
        await _buildRootRoutes(template, routing);

    if (routing.shell.enabled) {
      for (final branch in routing.shell.branches) {
        final branchName = NameConverter(branch.name);
        files[p.posix.join(
          base,
          'branches',
          '${branchName.snakeCase}_branch.dart',
        )] = await _buildBranch(
          template,
          config,
          routing,
          branch,
          branchName,
        );
      }
    }

    files[p.posix.join(base, 'generated_routes.dart')] =
        await _buildGeneratedRoutes(template, routing);
    return Map<String, String>.unmodifiable(files);
  }

  Future<String> buildAppShell(KiteShellConfig shell) async {
    final template = await templateStore.load('routing.go_router');
    final visible = <MapEntry<int, KiteShellBranchConfig>>[
      for (var index = 0; index < shell.branches.length; index++)
        if (shell.branches[index].navigation.visible)
          MapEntry<int, KiteShellBranchConfig>(index, shell.branches[index]),
    ];
    final visibleIndexes = visible.map((entry) => '    ${entry.key},').join('\n');
    final navigationDestinations = <String>[];
    final railDestinations = <String>[];
    for (final entry in visible) {
      final branch = entry.value;
      final label = _dartString(
        branch.navigation.label ?? NameConverter(branch.name).titleCase,
      );
      navigationDestinations.add(
        await _render(
          template,
          'files/partials/navigation_destination.dart.tmpl',
          <String, Object?>{
            'navigation': <String, Object?>{'label': label},
          },
        ),
      );
      railDestinations.add(
        await _render(
          template,
          'files/partials/navigation_rail_destination.dart.tmpl',
          <String, Object?>{
            'navigation': <String, Object?>{'label': label},
          },
        ),
      );
    }

    return _render(
      template,
      'files/app_shell.dart.tmpl',
      <String, Object?>{
        'shell': <String, Object?>{
          'visibleIndexes': visibleIndexes,
          'showNavigation': visible.length >= 2,
          'navigationDestinations': navigationDestinations.join(),
          'railDestinations': railDestinations.join(),
        },
      },
    );
  }

  Future<String> _buildFeatureRoute(
    LoadedTemplate template,
    KiteConfig config,
    KiteRouteConfig route,
    NameConverter feature,
  ) async {
    final featureRoutePath = p.posix.join(
      _portable(config.sourceDirectory),
      'app',
      'router',
      'generated',
      'features',
      '${feature.snakeCase}_route.dart',
    );
    final screenPath = _featureScreenPath(
      config: config,
      feature: feature,
      architecture: route.architecture,
    );
    final importPath = _relativeImport(featureRoutePath, screenPath);

    return _render(
      template,
      'files/feature_route.dart.tmpl',
      <String, Object?>{
        'route': <String, Object?>{
          'screenImport': importPath,
          'functionName': '${feature.camelCase}Route',
          'screenClass': '${feature.pascalCase}Screen',
        },
      },
    );
  }

  Future<String> _buildRootRoutes(
    LoadedTemplate template,
    KiteRoutingConfig routing,
  ) {
    final routes = routing.routes
        .where((route) => route.branch == 'root')
        .toList(growable: false);
    final imports = routes.map((route) {
      final feature = NameConverter(route.feature);
      return "import 'features/${feature.snakeCase}_route.dart';";
    }).join('\n');
    final entries = routes.map((route) {
      final feature = NameConverter(route.feature);
      return '  ${feature.camelCase}Route(path: AppRoutes.${feature.camelCase}),';
    }).join('\n');

    return _render(
      template,
      'files/root_routes.dart.tmpl',
      <String, Object?>{
        'routes': <String, Object?>{
          'imports': imports.isEmpty ? '' : '$imports\n',
          'entries': entries.isEmpty ? '' : '$entries\n',
        },
      },
    );
  }

  Future<String> _buildBranch(
    LoadedTemplate template,
    KiteConfig config,
    KiteRoutingConfig routing,
    KiteShellBranchConfig branch,
    NameConverter branchName,
  ) async {
    final routes = routing.routes
        .where((route) => route.branch == branch.name)
        .toList(growable: false);
    final imports = routes.map((route) {
      final feature = NameConverter(route.feature);
      return "import '../features/${feature.snakeCase}_route.dart';";
    }).join('\n');
    final children = <String>[];
    for (final route in routes) {
      final feature = NameConverter(route.feature);
      children.add(
        await _render(
          template,
          'files/partials/branch_child.dart.tmpl',
          <String, Object?>{
            'child': <String, Object?>{
              'routeFunction': '${feature.camelCase}Route',
              'parentConstant': branchName.camelCase,
              'routeConstant':
                  '${branchName.camelCase}${feature.pascalCase}',
            },
          },
        ),
      );
    }

    final branchFeature = NameConverter(branch.feature);
    final branchFilePath = p.posix.join(
      _portable(config.sourceDirectory),
      'app',
      'router',
      'generated',
      'branches',
      '${branchName.snakeCase}_branch.dart',
    );
    final screenPath = _featureScreenPath(
      config: config,
      feature: branchFeature,
      architecture: branch.architecture,
    );

    return _render(
      template,
      'files/branch.dart.tmpl',
      <String, Object?>{
        'branch': <String, Object?>{
          'screenImport': _relativeImport(branchFilePath, screenPath),
          'screenClass': '${branchFeature.pascalCase}Screen',
          'childImports': imports.isEmpty ? '' : '$imports\n',
          'variableName': '${branchName.camelCase}Branch',
          'routeConstant': branchName.camelCase,
          'children': children.join(),
        },
      },
    );
  }

  Future<String> _buildGeneratedRoutes(
    LoadedTemplate template,
    KiteRoutingConfig routing,
  ) {
    if (!routing.shell.enabled) {
      return _render(
        template,
        'files/generated_root_routes.dart.tmpl',
        const <String, Object?>{},
      );
    }

    final branches = routing.shell.branches;
    final imports = branches.map((branch) {
      final name = NameConverter(branch.name);
      return "import 'branches/${name.snakeCase}_branch.dart';";
    }).join('\n');
    final entries = branches.map((branch) {
      final name = NameConverter(branch.name);
      return '      ${name.camelCase}Branch,';
    }).join('\n');
    final firstBranch = NameConverter(branches.first.name);

    return _render(
      template,
      'files/generated_shell_routes.dart.tmpl',
      <String, Object?>{
        'shell': <String, Object?>{
          'imports': imports,
          'entries': entries,
          'initialRouteConstant': firstBranch.camelCase,
        },
      },
    );
  }

  String _featureScreenPath({
    required KiteConfig config,
    required NameConverter feature,
    required String architecture,
  }) {
    return switch (architecture) {
      'clean' => p.posix.join(
          _portable(config.featureDirectory),
          feature.snakeCase,
          'presentation',
          'screens',
          '${feature.snakeCase}_screen.dart',
        ),
      'mvc' => p.posix.join(
          _portable(config.featureDirectory),
          feature.snakeCase,
          'views',
          'screens',
          '${feature.snakeCase}_screen.dart',
        ),
      _ => throw StateError(
          'Unsupported route architecture `$architecture` for '
          '`${feature.snakeCase}`.',
        ),
    };
  }

  Future<String> _render(
    LoadedTemplate template,
    String templatePath,
    Map<String, Object?> values,
  ) async {
    final file = File(p.join(template.directory.path, templatePath));
    if (!file.existsSync()) {
      throw StateError('Missing bundled routing template: ${file.path}');
    }
    return templateRenderer.render(await file.readAsString(), values);
  }

  Future<ConflictStrategy> _safeShellConflictStrategy({
    required Directory projectRoot,
    required String relativePath,
    required ConflictStrategy requested,
  }) async {
    final target = File(_absolutePath(projectRoot, relativePath));
    if (!target.existsSync()) {
      return requested;
    }
    final manifest = await manifestStore.read(projectRoot);
    final generation = manifest.generations
        .where((item) => item.id == 'routing.shell')
        .firstOrNull;
    final managed = generation?.files
        .where((item) => item.path == relativePath)
        .firstOrNull;
    if (managed == null) {
      return requested;
    }
    final currentChecksum = FileChecksum.content(await target.readAsString());
    return currentChecksum == managed.checksum
        ? ConflictStrategy.overwrite
        : requested;
  }

  Future<void> _deleteEmptyGeneratedParents(
    Directory directory,
    Directory projectRoot,
    KiteConfig config,
  ) async {
    final generatedRoot = Directory(
      _absolutePath(
        projectRoot,
        p.posix.join(
          _portable(config.sourceDirectory),
          'app',
          'router',
          'generated',
        ),
      ),
    );
    var current = directory;
    while (current.path != generatedRoot.path &&
        current.path.startsWith(generatedRoot.path) &&
        current.existsSync() &&
        current.listSync().isEmpty) {
      final parent = current.parent;
      await current.delete();
      current = parent;
    }
  }

  String _relativeImport(String fromFile, String targetFile) {
    var importPath = p.posix.relative(
      targetFile,
      from: p.posix.dirname(fromFile),
    );
    if (!importPath.startsWith('.')) {
      importPath = './$importPath';
    }
    return importPath;
  }

  String _absolutePath(Directory root, String relativePath) {
    return p.joinAll(<String>[root.path, ...p.posix.split(relativePath)]);
  }

  String _dartString(String value) {
    final escaped = value
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll(r'$', r'\$');
    return "'$escaped'";
  }

  String _portable(String path) => path.replaceAll('\\', '/');
}

extension _FirstOrNullGeneratedRouter<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
