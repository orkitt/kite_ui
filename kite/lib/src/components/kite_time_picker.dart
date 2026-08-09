// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';
import 'internal/kite_interactive.dart';
import 'kite_button.dart';

class KiteTimePicker {
  KiteTimePicker._();

  static Future<TimeOfDay?> show(
    BuildContext context, {
    TimeOfDay? initialTime,
    String? helpText,
  }) {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.kolors.textPrimary.withValues(alpha: .32),
      builder: (context) => _TimePickerSheet(
        initialTime: initialTime ?? TimeOfDay.now(),
        title: helpText ?? 'Choose time',
      ),
    );
  }
}

class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet({required this.initialTime, required this.title});

  final TimeOfDay initialTime;
  final String title;

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late int _hour;
  late int _minute;
  late bool _pm;

  @override
  void initState() {
    super.initState();
    _pm = widget.initialTime.hour >= 12;
    _hour = widget.initialTime.hourOfPeriod == 0
        ? 12
        : widget.initialTime.hourOfPeriod;
    _minute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;

    return SafeArea(
      top: false,
      child: Container(
        padding: Dimensions.p16,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimensions.r24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Container(
                width: Dimensions.s40,
                height: Dimensions.s4,
                decoration: BoxDecoration(
                  color: colors.borderStrong,
                  borderRadius: Dimensions.radFull,
                ),
              ),
            ),
            Dimensions.gapV20,
            Text(widget.title, style: context.typography.h3),
            Dimensions.gapV20,
            Row(
              children: [
                Expanded(
                  child: _TimeNumber(
                    label: 'Hour',
                    value: _hour,
                    onMinus: () =>
                        setState(() => _hour = _hour == 1 ? 12 : _hour - 1),
                    onPlus: () =>
                        setState(() => _hour = _hour == 12 ? 1 : _hour + 1),
                  ),
                ),
                Padding(
                  padding: Dimensions.px8,
                  child: Text(':', style: context.typography.h1),
                ),
                Expanded(
                  child: _TimeNumber(
                    label: 'Minute',
                    value: _minute,
                    twoDigits: true,
                    onMinus: () => setState(() => _minute = (_minute - 5) % 60),
                    onPlus: () => setState(() => _minute = (_minute + 5) % 60),
                  ),
                ),
              ],
            ),
            Dimensions.gapV16,
            Container(
              padding: Dimensions.p4,
              decoration: ShapeDecoration(
                color: colors.muted,
                shape: Shapes.rounded12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _PeriodButton(
                      label: 'AM',
                      selected: !_pm,
                      onTap: () => setState(() => _pm = false),
                    ),
                  ),
                  Dimensions.gapH4,
                  Expanded(
                    child: _PeriodButton(
                      label: 'PM',
                      selected: _pm,
                      onTap: () => setState(() => _pm = true),
                    ),
                  ),
                ],
              ),
            ),
            Dimensions.gapV20,
            Row(
              children: [
                Expanded(
                  child: KiteButton(
                    label: 'Cancel',
                    variant: KiteButtonVariant.ghost,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Dimensions.gapH8,
                Expanded(
                  child: KiteButton(
                    label: 'Select',
                    onPressed: () {
                      final hour24 = _pm
                          ? (_hour == 12 ? 12 : _hour + 12)
                          : (_hour == 12 ? 0 : _hour);
                      Navigator.of(
                        context,
                      ).pop(TimeOfDay(hour: hour24, minute: _minute));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeNumber extends StatelessWidget {
  const _TimeNumber({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
    this.twoDigits = false,
  });

  final String label;
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool twoDigits;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final text = twoDigits ? value.toString().padLeft(2, '0') : '$value';

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.inputFill,
        shape: Shapes.rounded16.copyWith(
          side: BorderSide(color: colors.border),
        ),
      ),
      child: Padding(
        padding: Dimensions.p12,
        child: Column(
          children: [
            Text(label, style: context.typography.caption),
            Dimensions.gapV8,
            _MiniControl(icon: Icons.keyboard_arrow_up_rounded, onTap: onPlus),
            Dimensions.gapV8,
            Text(text, style: context.typography.h1),
            Dimensions.gapV8,
            _MiniControl(
              icon: Icons.keyboard_arrow_down_rounded,
              onTap: onMinus,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniControl extends StatelessWidget {
  const _MiniControl({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    return KitePressable(
      onTap: onTap,
      builder: (context, state) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: double.infinity,
        height: Dimensions.s32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: state.hovered ? colors.muted : colors.card,
          borderRadius: Dimensions.rad8,
          border: Border.all(color: colors.borderSoft),
        ),
        child: Icon(icon, size: Dimensions.iconSm, color: colors.icon),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    return KitePressable(
      onTap: onTap,
      semanticLabel: label,
      builder: (context, state) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: Dimensions.buttonHeightSm,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.card : Colors.transparent,
          borderRadius: Dimensions.rad8,
          border: Border.all(
            color: state.focused ? colors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: context.typography.labelSmall.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
