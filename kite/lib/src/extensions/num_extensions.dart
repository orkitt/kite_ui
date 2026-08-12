import 'dart:math' as math;

import 'package:intl/intl.dart';

extension NumExtensions on num {
  String formatted({
    String? locale,
    int? decimalDigits,
  }) {
    final formatter = NumberFormat.decimalPattern(locale);

    if (decimalDigits != null) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }

    return formatter.format(this);
  }

  String currency({
    String symbol = '৳',
    String? locale,
    int decimalDigits = 0,
  }) {
    return NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  String get bdt {
    return NumberFormat.currency(
      symbol: '৳',
      decimalDigits: 0,
    ).format(this);
  }

  String percent({
    int decimalDigits = 0,
  }) {
    return '${toStringAsFixed(decimalDigits)}%';
  }

  num clampBetween(
    num minimum,
    num maximum,
  ) {
    assert(minimum <= maximum, 'minimum must be <= maximum');
    return math.max(minimum, math.min(maximum, this));
  }

  bool isBetween(
    num minimum,
    num maximum, {
    bool inclusive = true,
  }) {
    if (inclusive) {
      return this >= minimum && this <= maximum;
    }

    return this > minimum && this < maximum;
  }

  String get compact => NumberFormat.compact().format(this);

  String compactCurrency({
    String symbol = '৳',
    String? locale,
    int decimalDigits = 1,
  }) {
    return NumberFormat.compactCurrency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  /// Formats this number as a binary file size.
  ///
  /// Treats the current numeric value as bytes.
  String fileSize({
    int decimalDigits = 1,
  }) {
    if (this <= 0) return '0 B';

    const units = <String>[
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
    ];

    final calculatedIndex =
        (math.log(this) / math.log(1024)).floor();

    final index = calculatedIndex.clamp(0, units.length - 1).toInt();
    final value = this / math.pow(1024, index);

    return '${value.toStringAsFixed(decimalDigits)} ${units[index]}';
  }
}
