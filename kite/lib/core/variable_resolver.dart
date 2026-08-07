class VariableResolver {
  static String resolve(String input, Map<String, String> vars) {
    String result = input;

    vars.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value);

      final capitalized =
          value.substring(0, 1).toUpperCase() + value.substring(1);

      result = result.replaceAll('{{${key.capitalize()}}}', capitalized);
    });

    return result;
  }
}

extension on String {
  String capitalize() {
    return substring(0, 1).toUpperCase() + substring(1);
  }
}