import 'package:kite_cli/kite_cli.dart';
import 'package:test/test.dart';

void main() {
  group('NameConverter', () {
    test('converts mixed feature names', () {
      final name = NameConverter('User Profile');

      expect(name.snakeCase, 'user_profile');
      expect(name.camelCase, 'userProfile');
      expect(name.pascalCase, 'UserProfile');
      expect(name.kebabCase, 'user-profile');
    });

    test('converts camel case input', () {
      final name = NameConverter('studentAttendance');
      expect(name.snakeCase, 'student_attendance');
    });

    test('rejects invalid input', () {
      expect(() => NameConverter('---'), throwsA(isA<InvalidNameException>()));
    });
  });
}
