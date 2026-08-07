import 'dart:io';

import 'package:kite_cli/kite_cli.dart';

Future<void> main(List<String> arguments) async {
  final runner = KiteCommandRunner();
  final exitCode = await runner.execute(arguments);
  exit(exitCode);
}
