final class TemplateRenderer {
  const TemplateRenderer();

  String render(String template, Map<String, Object?> values) {
    var output = template;
    final flattened = <String, String>{};
    _flatten('', values, flattened);

    for (final entry in flattened.entries) {
      output = output.replaceAll('{{${entry.key}}}', entry.value);
    }

    final unresolved = RegExp(r'\{\{[^}]+\}\}').firstMatch(output);
    if (unresolved != null) {
      throw FormatException(
        'Unresolved template token: ${unresolved.group(0)}',
      );
    }

    return output;
  }

  bool evaluateCondition(String? condition, Map<String, Object?> values) {
    if (condition == null || condition.trim().isEmpty) {
      return true;
    }

    final trimmed = condition.trim();
    final negated = trimmed.startsWith('!');
    final key = negated ? trimmed.substring(1) : trimmed;
    final value = _lookup(key, values);
    final result = value == true;
    return negated ? !result : result;
  }

  Object? _lookup(String path, Map<String, Object?> values) {
    Object? current = values;
    for (final segment in path.split('.')) {
      if (current is! Map<Object?, Object?>) {
        return null;
      }
      current = current[segment];
    }
    return current;
  }

  void _flatten(
    String prefix,
    Map<Object?, Object?> input,
    Map<String, String> output,
  ) {
    for (final entry in input.entries) {
      final segment = entry.key.toString();
      final key = prefix.isEmpty ? segment : '$prefix.$segment';
      final value = entry.value;
      if (value is Map<Object?, Object?>) {
        _flatten(key, value, output);
      } else if (value != null) {
        output[key] = value.toString();
      }
    }
  }
}
