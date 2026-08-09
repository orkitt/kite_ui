// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';

class KiteCalendar extends StatefulWidget {
  const KiteCalendar({
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
    this.firstDate,
    this.lastDate,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<KiteCalendar> createState() => _KiteCalendarState();
}

class _KiteCalendarState extends State<KiteCalendar> {
  late DateTime _visibleMonth;

  DateTime get _firstDate =>
      widget.firstDate ?? DateTime(DateTime.now().year - 100);
  DateTime get _lastDate =>
      widget.lastDate ?? DateTime(DateTime.now().year + 10, 12, 31);

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  @override
  void didUpdateWidget(covariant KiteCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameMonth(oldWidget.selectedDate, widget.selectedDate)) {
      _visibleMonth = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.card,
        shape: Shapes.rounded16.copyWith(
          side: BorderSide(color: colors.borderSoft),
        ),
      ),
      child: Padding(
        padding: Dimensions.p16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CalendarHeader(
              month: _visibleMonth,
              canGoPrevious: _canGoPrevious,
              canGoNext: _canGoNext,
              onPrevious: _previousMonth,
              onNext: _nextMonth,
            ),
            Dimensions.gapV16,
            const _WeekHeader(),
            Dimensions.gapV8,
            _MonthGrid(
              month: _visibleMonth,
              selectedDate: widget.selectedDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              onSelected: widget.onDateChanged,
            ),
          ],
        ),
      ),
    );
  }

  bool get _canGoPrevious {
    final previous = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    return !previous.isBefore(DateTime(_firstDate.year, _firstDate.month, 1));
  }

  bool get _canGoNext {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    return !next.isAfter(DateTime(_lastDate.year, _lastDate.month, 1));
  }

  void _previousMonth() {
    if (!_canGoPrevious) return;
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
    });
  }

  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  static const _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${_months[month.month - 1]} ${month.year}',
            style: context.typography.title,
          ),
        ),
        _CalendarArrow(
          icon: Icons.chevron_left_rounded,
          enabled: canGoPrevious,
          onTap: onPrevious,
        ),
        Dimensions.gapH8,
        _CalendarArrow(
          icon: Icons.chevron_right_rounded,
          enabled: canGoNext,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _CalendarArrow extends StatelessWidget {
  const _CalendarArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: enabled ? onTap : null,
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: Dimensions.s32,
          height: Dimensions.s32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: state.hovered ? colors.muted : Colors.transparent,
            borderRadius: Dimensions.rad8,
            border: Border.all(
              color: state.focused ? colors.primary : colors.borderSoft,
            ),
          ),
          child: Icon(
            icon,
            size: Dimensions.iconSm,
            color: enabled ? colors.icon : colors.textDisabled,
          ),
        );
      },
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader();

  @override
  Widget build(BuildContext context) {
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(label, style: context.typography.caption),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
  });

  final DateTime month;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = firstOfMonth.weekday % 7;
    final cells = ((leading + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: Dimensions.s4,
        crossAxisSpacing: Dimensions.s4,
      ),
      itemCount: cells,
      itemBuilder: (context, index) {
        final dayNumber = index - leading + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(month.year, month.month, dayNumber);
        final enabled =
            !date.isBefore(_dateOnly(firstDate)) &&
            !date.isAfter(_dateOnly(lastDate));
        final selected = _sameDate(date, selectedDate);
        final today = _sameDate(date, DateTime.now());

        return _DayCell(
          date: date,
          enabled: enabled,
          selected: selected,
          today: today,
          onTap: () => onSelected(date),
        );
      },
    );
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.enabled,
    required this.selected,
    required this.today,
    required this.onTap,
  });

  final DateTime date;
  final bool enabled;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return KitePressable(
      onTap: enabled ? onTap : null,
      semanticLabel: '${date.day}',
      builder: (context, state) {
        final background = selected
            ? colors.primary
            : state.hovered
            ? colors.muted
            : Colors.transparent;
        final foreground = !enabled
            ? colors.textDisabled
            : selected
            ? colors.onPrimary
            : colors.textPrimary;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: Dimensions.rad8,
            border: Border.all(
              color: selected
                  ? colors.primary
                  : state.focused
                  ? colors.primary
                  : today
                  ? colors.borderStrong
                  : Colors.transparent,
            ),
          ),
          child: Text(
            '${date.day}',
            style: context.typography.labelSmall.copyWith(color: foreground),
          ),
        );
      },
    );
  }
}
