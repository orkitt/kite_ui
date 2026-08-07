import 'package:kite_cli/kite_cli.dart';
import 'package:test/test.dart';

void main() {
  const renderer = TemplateRenderer();
  final values = <String, Object?>{
    'feature': <String, Object?>{
      'snake': 'user_profile',
      'pascal': 'UserProfile',
    },
    'includeJson': true,
  };

  test('renders nested tokens', () {
    expect(
      renderer.render('{{feature.pascal}} -> {{feature.snake}}', values),
      'UserProfile -> user_profile',
    );
  });

  test('evaluates positive and negated conditions', () {
    expect(renderer.evaluateCondition('includeJson', values), isTrue);
    expect(renderer.evaluateCondition('!includeJson', values), isFalse);
  });

  test('fails for unresolved tokens', () {
    expect(
      () => renderer.render('{{missing.value}}', values),
      throwsFormatException,
    );
  });
}
