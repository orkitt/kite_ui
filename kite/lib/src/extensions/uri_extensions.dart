extension UriExtensions on Uri {
  /// Returns a copy with the supplied query parameters merged into the
  /// existing query parameters.
  ///
  /// Passing `null` removes a key.
  Uri withQueryParameters(
    Map<String, Object?> parameters,
  ) {
    final merged = <String, String>{
      ...queryParameters,
    };

    for (final entry in parameters.entries) {
      final value = entry.value;

      if (value == null) {
        merged.remove(entry.key);
      } else {
        merged[entry.key] = value.toString();
      }
    }

    return replace(
      queryParameters: merged.isEmpty ? null : merged,
    );
  }

  bool get isHttp => scheme == 'http';

  bool get isHttps => scheme == 'https';

  bool get isWebUrl => isHttp || isHttps;
}
