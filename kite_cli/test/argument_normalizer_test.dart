import 'package:kite/src/cli/argument_normalizer.dart';
import 'package:test/test.dart';

void main() {
  group('normalizeArguments', () {
    test('normalizes clean feature shorthand', () {
      expect(
        normalizeArguments(const <String>['--feat:clean', 'dashboard']),
        const <String>[
          'feature',
          'dashboard',
          '--architecture',
          'clean',
        ],
      );
    });

    test('normalizes mvc feature shorthand', () {
      expect(
        normalizeArguments(
          const <String>['--feat:mvc', 'user-profile', '--route'],
        ),
        const <String>[
          'feature',
          'user-profile',
          '--architecture',
          'mvc',
          '--route',
        ],
      );
    });

    test('normalizes widget shorthand', () {
      expect(
        normalizeArguments(
          const <String>['--widget', '[button,card,avater]'],
        ),
        const <String>['component', '[button,card,avater]'],
      );
    });

    test('normalizes Riverpod state shorthand', () {
      expect(
        normalizeArguments(const <String>['--state', 'riverpod']),
        const <String>['state', 'riverpod'],
      );
    });

    test('normalizes Dio API shorthand', () {
      expect(
        normalizeArguments(const <String>['--api:dio']),
        const <String>['api', 'dio'],
      );
    });

    test('normalizes generate feature shorthand', () {
      expect(
        normalizeArguments(const <String>['g', 'feat', 'user-profile']),
        const <String>['feature', 'user-profile'],
      );
    });
  });
}
