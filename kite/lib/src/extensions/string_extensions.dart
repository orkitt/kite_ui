extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => trim().isNotEmpty;

  String get capitalize {
    if (isEmpty) return this;

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeWords {
    return trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.capitalize)
        .join(' ');
  }

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  String get singleSpace => trim().replaceAll(RegExp(r'\s+'), ' ');

  String get initials {
    final words = trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '';

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  String truncate(
    int maxLength, {
    String suffix = '...',
  }) {
    if (maxLength <= 0) return '';

    if (length <= maxLength) return this;

    if (maxLength <= suffix.length) {
      return substring(0, maxLength);
    }

    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');

  bool get isNumeric => double.tryParse(trim()) != null;

  int? get toIntOrNull => int.tryParse(trim());

  double? get toDoubleOrNull => double.tryParse(trim());

  bool? get toBoolOrNull {
    switch (trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
      case 'y':
        return true;
      case 'false':
      case '0':
      case 'no':
      case 'n':
        return false;
      default:
        return null;
    }
  }

  DateTime? get toDateTimeOrNull => DateTime.tryParse(trim());

  bool get isEmail {
    return RegExp(
      r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)*$",
    ).hasMatch(trim());
  }

  bool get isUrl {
    final uri = Uri.tryParse(trim());

    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  bool get isPhoneNumber {
    final value = replaceAll(RegExp(r'[\s\-()]'), '');

    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
  }

  String get snakeCaseToWords => replaceAll('_', ' ').singleSpace;

  String get kebabCaseToWords => replaceAll('-', ' ').singleSpace;

  String get camelCaseToWords {
    return replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    ).singleSpace;
  }

  String get maskEmail {
    final parts = split('@');

    if (parts.length != 2 || parts.first.isEmpty) return this;

    final name = parts.first;

    if (name.length <= 2) {
      return '${name.substring(0, 1)}***@${parts.last}';
    }

    return '${name.substring(0, 2)}***@${parts.last}';
  }

  String maskPhone({
    int visibleStart = 3,
    int visibleEnd = 3,
  }) {
    if (visibleStart < 0 || visibleEnd < 0) return this;
    if (length <= visibleStart + visibleEnd) return this;

    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final hiddenCount = length - visibleStart - visibleEnd;

    return '$start${'*' * hiddenCount}$end';
  }
}

extension NullableStringExtensions on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrBlank => !isNullOrBlank;

  String get orEmpty => this ?? '';

  String orDefault(String fallback) {
    if (isNullOrBlank) return fallback;

    return this!;
  }
}
