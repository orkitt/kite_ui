import 'dart:io';

import 'package:kite/src/generation/conflict_strategy.dart';
import 'package:kite/src/generation/file_writer.dart';
import 'package:kite/src/generation/generation_result.dart';
import 'package:kite/src/generation/template_planner.dart';
import 'package:kite/src/templates/template_store.dart';
import 'package:test/test.dart';

void main() {
  final variables = <String, Object?>{
    'project': <String, Object?>{
      'name': 'sample_app',
      'package': 'sample_app',
    },
    'feature': <String, Object?>{
      'raw': 'dashboard',
      'snake': 'dashboard',
      'camel': 'dashboard',
      'pascal': 'Dashboard',
      'kebab': 'dashboard',
    },
    'config': <String, Object?>{
      'sourceDirectory': 'lib',
      'featureDirectory': 'lib/features',
      'architecture': 'clean',
      'router': 'go_router',
      'stateManagement': 'riverpod',
    },
    'includeRoute': false,
    'includeJson': false,
    'kite': <String, Object?>{'version': 'test'},
    'generated': <String, Object?>{'date': 'test'},
  };

  test('generates a clean feature and required Riverpod files', () async {
    final root = await Directory.systemTemp.createTemp('kite_clean_test_');
    addTearDown(() => root.delete(recursive: true));

    const store = TemplateStore();
    const planner = TemplatePlanner();
    const writer = FileWriter();
    final templates = await store.resolve('feature.clean');
    final plan = await planner.buildResolved(
      rootTemplateId: 'feature.clean',
      templates: templates,
      variables: variables,
    );
    final result = await writer.write(
      root: root,
      plan: plan,
      conflictStrategy: ConflictStrategy.fail,
      dryRun: false,
    );

    expect(result.count(GeneratedFileStatus.created), 12);
    expect(
      File(
        '${root.path}/lib/features/dashboard/domain/entities/'
        'dashboard_entity.dart',
      ).existsSync(),
      isTrue,
    );
    expect(
      File('${root.path}/lib/core/state/riverpod_bootstrap.dart').existsSync(),
      isTrue,
    );
  });

  test('generates an MVC feature', () async {
    final root = await Directory.systemTemp.createTemp('kite_mvc_test_');
    addTearDown(() => root.delete(recursive: true));

    const store = TemplateStore();
    const planner = TemplatePlanner();
    const writer = FileWriter();
    final templates = await store.resolve('feature.mvc');
    final plan = await planner.buildResolved(
      rootTemplateId: 'feature.mvc',
      templates: templates,
      variables: <String, Object?>{
        ...variables,
        'config': <String, Object?>{
          ...(variables['config']! as Map<String, Object?>),
          'architecture': 'mvc',
        },
      },
    );
    final result = await writer.write(
      root: root,
      plan: plan,
      conflictStrategy: ConflictStrategy.fail,
      dryRun: false,
    );

    expect(result.count(GeneratedFileStatus.created), 8);
    expect(
      File(
        '${root.path}/lib/features/dashboard/controllers/'
        'dashboard_controller.dart',
      ).existsSync(),
      isTrue,
    );
    expect(
      File(
        '${root.path}/lib/features/dashboard/views/screens/'
        'dashboard_screen.dart',
      ).existsSync(),
      isTrue,
    );
  });

  test('deduplicates shared component dependencies', () async {
    const store = TemplateStore();
    const planner = TemplatePlanner();
    final buttonTemplates = await store.resolve('component.button');
    final cardTemplates = await store.resolve('component.card');
    final buttonPlan = await planner.buildResolved(
      rootTemplateId: 'component.button',
      templates: buttonTemplates,
      variables: variables,
    );
    final cardPlan = await planner.buildResolved(
      rootTemplateId: 'component.card',
      templates: cardTemplates,
      variables: variables,
    );

    final paths = <String>{
      ...buttonPlan.files.map((item) => item.relativePath),
      ...cardPlan.files.map((item) => item.relativePath),
    };
    expect(paths.length, 3);
    expect(paths, contains('lib/shared/components/kite_component_size.dart'));
    expect(paths, contains('lib/shared/components/kite_button.dart'));
    expect(paths, contains('lib/shared/components/kite_card.dart'));
  });
}
