import 'package:kite_cli/src/routing/shell_definition.dart';
import 'package:test/test.dart';

void main() {
  const parser = ShellDefinitionParser();

  group('ShellDefinitionParser', () {
    test('parses bracketed branch list', () {
      final definition = parser.parse('[home,blog,profile]');

      expect(definition.branches.map((item) => item.name), <String>[
        'home',
        'blog',
        'profile',
      ]);
      expect(definition.branches.map((item) => item.path), <String>[
        '/',
        '/blog',
        '/profile',
      ]);
    });

    test('parses plain comma-separated branch list', () {
      final definition = parser.parse('home,blog,profile');

      expect(definition.branches.map((item) => item.name), <String>[
        'home',
        'blog',
        'profile',
      ]);
    });

    test('rejects duplicate normalized branches', () {
      expect(
        () => parser.parse('[home,blog,home]'),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects invalid branch names', () {
      expect(() => parser.parse('[home,123-blog]'), throwsA(anything));
      expect(
        () => parser.parse('[home,root]'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
