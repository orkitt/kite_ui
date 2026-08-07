import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  static const light = AppColors(
    primary: Color(0xFF4F46E5),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFEEF2FF),
    secondary: Color(0xFF0F172A),
    onSecondary: Color(0xFFFFFFFF),
    secondarySoft: Color(0xFFF1F5F9),
    background: Color(0xFFF8FAFC),
    card: Color(0xFFFFFFFF),
    border: Color(0xFFE2E8F0),
    divider: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textDisabled: Color(0xFF94A3B8),
    icon: Color(0xFF475569),
    success: Color(0xFF16A34A),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFDC2626),
    info: Color(0xFF0284C7),
  );

  static const dark = AppColors(
    primary: Color(0xFF818CF8),
    onPrimary: Color(0xFF111827),
    primarySoft: Color(0xFF252541),
    secondary: Color(0xFFF8FAFC),
    onSecondary: Color(0xFF0F172A),
    secondarySoft: Color(0xFF1E293B),
    background: Color(0xFF09090B),
    card: Color(0xFF18181B),
    border: Color(0xFF2E2E33),
    divider: Color(0xFF27272A),
    textPrimary: Color(0xFFFAFAFA),
    textSecondary: Color(0xFFA1A1AA),
    textDisabled: Color(0xFF71717A),
    icon: Color(0xFFD4D4D8),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    info: Color(0xFF38BDF8),
  );

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.secondary,
    required this.onSecondary,
    required this.secondarySoft,
    required this.background,
    required this.card,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.icon,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  final Color primary;
  final Color onPrimary;
  final Color primarySoft;

  final Color secondary;
  final Color onSecondary;
  final Color secondarySoft;

  final Color background;
  final Color card;
  final Color border;
  final Color divider;

  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color icon;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primarySoft,
    Color? secondary,
    Color? onSecondary,
    Color? secondarySoft,
    Color? background,
    Color? card,
    Color? border,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? icon,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primarySoft: primarySoft ?? this.primarySoft,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondarySoft: secondarySoft ?? this.secondarySoft,
      background: background ?? this.background,
      card: card ?? this.card,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      icon: icon ?? this.icon,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      secondarySoft: Color.lerp(secondarySoft, other.secondarySoft, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
