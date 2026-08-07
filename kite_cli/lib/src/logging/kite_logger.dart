import 'dart:io';

final class KiteLogger {
  const KiteLogger();

  void info(String message) => stdout.writeln(message);

  void success(String message) => stdout.writeln('${_green('✓')} $message');

  void warning(String message) => stderr.writeln('${_yellow('!')} $message');

  void error(String message) => stderr.writeln('${_red('✗')} $message');

  void detail(String message) => stdout.writeln('  $message');

  String _green(String value) => _color(value, 32);

  String _yellow(String value) => _color(value, 33);

  String _red(String value) => _color(value, 31);

  String _color(String value, int code) {
    if (!stdout.supportsAnsiEscapes) {
      return value;
    }

    return '\u001b[${code}m$value\u001b[0m';
  }
}
