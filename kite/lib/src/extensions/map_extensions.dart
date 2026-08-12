extension JsonMapExtensions on Map<String, dynamic> {
  String? stringOrNull(String key) {
    final value = this[key];

    if (value == null) return null;

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }

  int? intOrNull(String key) {
    final value = this[key];

    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value?.toString() ?? '');
  }

  double? doubleOrNull(String key) {
    final value = this[key];

    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value?.toString() ?? '');
  }

  bool? boolOrNull(String key) {
    final value = this[key];

    if (value is bool) return value;
    if (value is num) return value != 0;

    switch (value?.toString().trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
        return true;
      case 'false':
      case '0':
      case 'no':
        return false;
      default:
        return null;
    }
  }

  Map<String, dynamic>? mapOrNull(String key) {
    final value = this[key];

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  List<dynamic>? listOrNull(String key) {
    final value = this[key];

    return value is List ? value : null;
  }

  List<T> listOf<T>(
    String key, {
    List<T> fallback = const [],
  }) {
    final value = this[key];

    if (value is! List) return fallback;

    return value.whereType<T>().toList();
  }
}

extension MapCompactionExtensions<K, V> on Map<K, V?> {
  Map<K, V> withoutNullValues() {
    return <K, V>{
      for (final entry in entries)
        if (entry.value != null) entry.key: entry.value as V,
    };
  }
}
