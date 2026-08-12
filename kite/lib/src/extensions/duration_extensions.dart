extension DurationExtensions on Duration {
  String get hhmmss {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String get readable {
    if (inSeconds < 60) {
      return '$inSeconds ${inSeconds == 1 ? 'sec' : 'secs'}';
    }

    if (inMinutes < 60) {
      final seconds = inSeconds.remainder(60);

      if (seconds == 0) {
        return '$inMinutes min';
      }

      return '$inMinutes min $seconds sec';
    }

    if (inHours < 24) {
      final minutes = inMinutes.remainder(60);

      if (minutes == 0) {
        return '$inHours hr';
      }

      return '$inHours hr $minutes min';
    }

    final days = inDays;
    final hours = inHours.remainder(24);

    if (hours == 0) {
      return '$days ${days == 1 ? 'day' : 'days'}';
    }

    return '$days ${days == 1 ? 'day' : 'days'} $hours hr';
  }
}

extension IntDurationExtensions on int {
  Duration get milliseconds => Duration(milliseconds: this);

  Duration get seconds => Duration(seconds: this);

  Duration get minutes => Duration(minutes: this);

  Duration get hours => Duration(hours: this);

  Duration get days => Duration(days: this);
}
