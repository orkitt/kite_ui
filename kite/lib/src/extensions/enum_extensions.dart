extension EnumExtensions on Enum {
  /// Returns a human-readable label from the enum case name.
  ///
  /// Example: `pendingPayment` -> `Pending Payment`.
  String get label {
    if (name.isEmpty) return '';

    final words = name.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    return '${words[0].toUpperCase()}${words.substring(1)}';
  }
}

extension EnumIterableExtensions<T extends Enum> on Iterable<T> {
  T? byNameOrNull(
    String? value, {
    bool caseSensitive = true,
  }) {
    if (value == null) return null;

    for (final item in this) {
      if (caseSensitive) {
        if (item.name == value) return item;
      } else {
        if (item.name.toLowerCase() == value.toLowerCase()) {
          return item;
        }
      }
    }

    return null;
  }
}
