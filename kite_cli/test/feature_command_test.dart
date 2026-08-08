import 'package:kite_cli/src/cli/exit_codes.dart';
import 'package:kite_cli/src/cli/kite_command_runner.dart';
import 'package:test/test.dart';

void main() {
  test('--into requires --route', () async {
    final exitCode = await KiteCommandRunner().execute(const <String>[
      'feature',
      'details',
      '--into',
      'blog',
    ]);

    expect(exitCode, ExitCodes.usage);
  });
}
