import 'package:flutter/material.dart';

import 'app_colors.dart';


/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  static const standard = AppTypography(
    display: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.8,
    ),
    headingLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    headingMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.3,
    ),
    headingSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.2,
    ),
    body: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),
    label: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2),
    caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.35),
  );

  const AppTypography({
    required this.display,
    required this.headingLarge,
    required this.headingMedium,
    required this.headingSmall,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.caption,
  });

  final TextStyle display;
  final TextStyle headingLarge;
  final TextStyle headingMedium;
  final TextStyle headingSmall;
  final TextStyle body;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle caption;

  AppTypography applyColor(AppColors colors) {
    return copyWith(
      display: display.copyWith(color: colors.textPrimary),
      headingLarge: headingLarge.copyWith(color: colors.textPrimary),
      headingMedium: headingMedium.copyWith(color: colors.textPrimary),
      headingSmall: headingSmall.copyWith(color: colors.textPrimary),
      body: body.copyWith(color: colors.textPrimary),
      bodySmall: bodySmall.copyWith(color: colors.textSecondary),
      label: label.copyWith(color: colors.textPrimary),
      caption: caption.copyWith(color: colors.textSecondary),
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? display,
    TextStyle? headingLarge,
    TextStyle? headingMedium,
    TextStyle? headingSmall,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return AppTypography(
      display: display ?? this.display,
      headingLarge: headingLarge ?? this.headingLarge,
      headingMedium: headingMedium ?? this.headingMedium,
      headingSmall: headingSmall ?? this.headingSmall,
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  @override
  AppTypography lerp(covariant ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;

    return AppTypography(
      display: TextStyle.lerp(display, other.display, t)!,
      headingLarge: TextStyle.lerp(headingLarge, other.headingLarge, t)!,
      headingMedium: TextStyle.lerp(headingMedium, other.headingMedium, t)!,
      headingSmall: TextStyle.lerp(headingSmall, other.headingSmall, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}

extension AppTypographyX on BuildContext {
  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;
}
