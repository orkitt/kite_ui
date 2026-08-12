extension IterableExtensions<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

  T? firstWhereOrNull(
    bool Function(T element) test,
  ) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }

    return null;
  }

  T? lastWhereOrNull(
    bool Function(T element) test,
  ) {
    T? result;

    for (final element in this) {
      if (test(element)) {
        result = element;
      }
    }

    return result;
  }

  int countWhere(
    bool Function(T element) test,
  ) {
    var count = 0;

    for (final element in this) {
      if (test(element)) {
        count++;
      }
    }

    return count;
  }

  Map<K, List<T>> groupBy<K>(
    K Function(T item) keySelector,
  ) {
    final result = <K, List<T>>{};

    for (final item in this) {
      final key = keySelector(item);
      (result[key] ??= <T>[]).add(item);
    }

    return result;
  }

  List<T> distinct() => toSet().toList();

  List<T> distinctBy<K>(
    K Function(T element) selector,
  ) {
    final seen = <K>{};
    final result = <T>[];

    for (final element in this) {
      if (seen.add(selector(element))) {
        result.add(element);
      }
    }

    return result;
  }

  List<List<T>> chunked(int size) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'Must be greater than zero.');
    }

    final source = toList();

    return [
      for (var index = 0; index < source.length; index += size)
        source.sublist(
          index,
          (index + size).clamp(0, source.length).toInt(),
        ),
    ];
  }
}

extension NullableIterableExtensions<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  List<T> get orEmpty => this?.toList() ?? <T>[];
}

extension NullableElementIterableExtensions<T extends Object> on Iterable<T?> {
  Iterable<T> whereNotNull() sync* {
    for (final element in this) {
      if (element != null) {
        yield element;
      }
    }
  }
}
