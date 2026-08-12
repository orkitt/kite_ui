import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay {
    return DateTime(
      year,
      month,
      day,
      23,
      59,
      59,
      999,
      999,
    );
  }

  DateTime get startOfMonth => DateTime(year, month);

  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999, 999);
  }

  DateTime get startOfYear => DateTime(year);

  DateTime get endOfYear {
    return DateTime(year, 12, 31, 23, 59, 59, 999, 999);
  }

  bool get isToday => isSameDate(DateTime.now());

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return isSameDate(yesterday);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    return isSameDate(tomorrow);
  }

  bool get isPast => isBefore(DateTime.now());

  bool get isFuture => isAfter(DateTime.now());

  bool get isWeekend {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  bool get isWeekday => !isWeekend;

  bool isSameDate(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) => year == other.year;

  bool isBetween(
    DateTime start,
    DateTime end, {
    bool inclusive = true,
  }) {
    if (inclusive) {
      return !isBefore(start) && !isAfter(end);
    }

    return isAfter(start) && isBefore(end);
  }

  DateTime addDays(int days) => add(Duration(days: days));

  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Adds calendar months while keeping the date valid.
  ///
  /// Example: January 31 + 1 month becomes February 28/29.
  DateTime addMonths(int months) {
    final totalMonths = year * 12 + (month - 1) + months;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = totalMonths % 12 + 1;

    final lastDay = DateTime(
      targetYear,
      targetMonth + 1,
      0,
    ).day;

    final targetDay = day > lastDay ? lastDay : day;

    return DateTime(
      targetYear,
      targetMonth,
      targetDay,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime subtractMonths(int months) => addMonths(-months);

  int differenceInDays(DateTime other) {
    return dateOnly.difference(other.dateOnly).inDays.abs();
  }

  int get age {
    final now = DateTime.now();

    var value = now.year - year;

    if (now.month < month ||
        (now.month == month && now.day < day)) {
      value--;
    }

    return value;
  }

  String format(
    String pattern, {
    String? locale,
  }) {
    return DateFormat(pattern, locale).format(this);
  }

  String get yyyyMMdd => DateFormat('yyyy-MM-dd').format(this);

  String get ddMMyyyy => DateFormat('dd-MM-yyyy').format(this);

  String get ddSlashMMyyyy => DateFormat('dd/MM/yyyy').format(this);

  String get readableDate => DateFormat('dd MMM yyyy').format(this);

  String get fullDate => DateFormat('EEEE, dd MMMM yyyy').format(this);

  String get monthDay => DateFormat('dd MMM').format(this);

  String get monthYear => DateFormat('MMMM yyyy').format(this);

  String get monthShortYear => DateFormat('MMM yyyy').format(this);

  String get dayName => DateFormat('EEEE').format(this);

  String get shortDayName => DateFormat('EEE').format(this);

  String get monthName => DateFormat('MMMM').format(this);

  String get shortMonthName => DateFormat('MMM').format(this);

  String get time12Hour => DateFormat('hh:mm a').format(this);

  String get time24Hour => DateFormat('HH:mm').format(this);

  String get dateTime12Hour =>
      DateFormat('dd MMM yyyy, hh:mm a').format(this);

  String get dateTime24Hour =>
      DateFormat('dd MMM yyyy, HH:mm').format(this);

  String get isoDateTime => toIso8601String();

  /// Human-friendly relative time.
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return _futureTime(difference.abs());
    }

    if (difference.inSeconds < 10) {
      return 'Just now';
    }

    if (difference.inMinutes < 1) {
      final seconds = difference.inSeconds;
      return '$seconds ${seconds == 1 ? 'second' : 'seconds'} ago';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (isYesterday) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }

    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    final years = difference.inDays ~/ 365;
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }

  String _futureTime(Duration duration) {
    if (duration.inMinutes < 1) {
      return 'In a moment';
    }

    if (duration.inHours < 1) {
      final minutes = duration.inMinutes;
      return 'In $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }

    if (duration.inDays < 1) {
      final hours = duration.inHours;
      return 'In $hours ${hours == 1 ? 'hour' : 'hours'}';
    }

    if (duration.inDays < 7) {
      final days = duration.inDays;
      return 'In $days ${days == 1 ? 'day' : 'days'}';
    }

    return readableDate;
  }
}

extension NullableDateTimeExtensions on DateTime? {
  String formatOr({
    String pattern = 'dd MMM yyyy',
    String fallback = '-',
    String? locale,
  }) {
    final value = this;

    if (value == null) return fallback;

    return DateFormat(pattern, locale).format(value);
  }
}
