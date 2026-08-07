import 'package:kite/src/templates/template_store.dart';
import 'package:test/test.dart';

void main() {
  test('loads bundled template registry', () async {
    const store = TemplateStore();
    final templates = await store.list();
    final ids = templates.map((item) => item.id);

    expect(ids, contains('project.clean'));
    expect(ids, contains('feature.clean'));
    expect(ids, contains('feature.mvc'));
    expect(ids, contains('component.button'));
    expect(ids, contains('state.riverpod'));
    expect(ids, contains('api.dio'));
  });

  test('resolves template dependencies before the root template', () async {
    const store = TemplateStore();
    final templates = await store.resolve('api.dio');

    expect(
      templates.map((item) => item.manifest.id),
      const <String>['api.core', 'state.riverpod', 'api.dio'],
    );
  });
}
