extension NullableObjectExtensions<T> on T? {
  R? let<R>(
    R Function(T value) transform,
  ) {
    final value = this;

    if (value == null) return null;

    return transform(value);
  }

  R fold<R>({
    required R Function() ifNull,
    required R Function(T value) ifNotNull,
  }) {
    final value = this;

    if (value == null) {
      return ifNull();
    }

    return ifNotNull(value);
  }

  T orElse(T fallback) => this ?? fallback;
}
