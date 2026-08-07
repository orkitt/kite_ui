import 'dart:io';

import 'package:kite/src/generation/conflict_strategy.dart';
import 'package:kite/src/generation/file_writer.dart';
import 'package:kite/src/generation/generation_plan.dart';
import 'package:kite/src/templates/template_manifest.dart';
import 'package:test/test.dart';

void main() {
  test('resolves conflicts before writing any file', () async {
    final root = await Directory.systemTemp.createTemp('kite_writer_');
    addTearDown(() => root.delete(recursive: true));
    await File('${root.path}/existing.dart').writeAsString('manual');

    const plan = GenerationPlan(
      templateId: 'test',
      templateVersion: '1.0.0',
      variables: <String, Object?>{},
      files: <PlannedFile>[
        PlannedFile(
          relativePath: 'new.dart',
          content: 'new',
          templatePath: 'new.tmpl',
          upgradePolicy: TemplateUpgradePolicy.replace,
        ),
        PlannedFile(
          relativePath: 'existing.dart',
          content: 'generated',
          templatePath: 'existing.tmpl',
          upgradePolicy: TemplateUpgradePolicy.replace,
        ),
      ],
    );

    await expectLater(
      const FileWriter().write(
        root: root,
        plan: plan,
        conflictStrategy: ConflictStrategy.fail,
        dryRun: false,
      ),
      throwsA(isA<GenerationConflictException>()),
    );

    expect(File('${root.path}/new.dart').existsSync(), isFalse);
    expect(
      await File('${root.path}/existing.dart').readAsString(),
      'manual',
    );
  });
}
