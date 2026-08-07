import 'package:flutter/material.dart';

@immutable
class KiteColors extends ThemeExtension<KiteColors> {
  // ---------------------------------------------------------------------------
  // Brand
  // ---------------------------------------------------------------------------

  final Color primary;
  final Color onPrimary;

  final Color secondary;
  final Color onSecondary;

  // ---------------------------------------------------------------------------
  // Base
  // ---------------------------------------------------------------------------

  /// Main application/page background.
  final Color background;

  /// Main card, sheet, dialog, and content container background.
  final Color card;

  /// Generic low-emphasis neutral background.
  ///
  /// Useful for:
  /// - subtle sections
  /// - inactive controls
  /// - neutral badges
  /// - table headers
  /// - toolbars
  final Color muted;

  /// Dedicated fill color for form controls.
  ///
  /// Useful for:
  /// - TextField
  /// - Dropdown
  /// - Search fields
  /// - TextArea
  final Color inputFill;

  // ---------------------------------------------------------------------------
  // Border
  // ---------------------------------------------------------------------------

  /// The single source of truth for the application's border family.
  final Color border;

  // ---------------------------------------------------------------------------
  // Content
  // ---------------------------------------------------------------------------

  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color icon;

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const KiteColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.card,
    required this.muted,
    required this.inputFill,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.icon,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  // ===========================================================================
  // Generated Brand Colors
  // ===========================================================================

  Color get primarySoft => soft(primary);

  Color get secondarySoft => soft(secondary);

  // ===========================================================================
  // Generated Status Colors
  // ===========================================================================

  Color get successSoft => soft(success);

  Color get warningSoft => soft(warning);

  Color get errorSoft => soft(error);

  Color get infoSoft => soft(info);

  // ===========================================================================
  // Generated Border Family
  // ===========================================================================

  /// Low-emphasis border.
  ///
  /// Derived from [border] toward [card] to preserve the same visual family.
  Color get borderSoft => _mix(card, border, 0.55);

  /// High-emphasis neutral border.
  ///
  /// Derived from [border] toward [textPrimary].
  Color get borderStrong => _mix(border, textPrimary, 0.22);

  // ===========================================================================
  // Color Utilities
  // ===========================================================================

  /// Creates a fully opaque subtle version of [color].
  ///
  /// Unlike alpha/opacity, the resulting color doesn't depend on whatever
  /// happens to be rendered behind it.
  Color soft(Color color, {double amount = 0.12}) {
    return _mix(background, color, amount);
  }

  Color _mix(Color from, Color to, double amount) {
    final value = amount.clamp(0.0, 1.0).toDouble();

    return Color.lerp(from, to, value)!;
  }

  // ===========================================================================
  // ThemeExtension
  // ===========================================================================

  @override
  KiteColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? card,
    Color? muted,
    Color? inputFill,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? icon,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return KiteColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      card: card ?? this.card,
      muted: muted ?? this.muted,
      inputFill: inputFill ?? this.inputFill,
      border: border ?? this.border,
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
  KiteColors lerp(covariant KiteColors? other, double t) {
    if (other == null) {
      return this;
    }

    return KiteColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      border: Color.lerp(border, other.border, t)!,
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

// =============================================================================
// BuildContext
// =============================================================================

extension KiteColorsX on BuildContext {
  KiteColors get kolors {
    final kolors = Theme.of(this).extension<KiteColors>();
    assert(
      kolors != null,
      'KiteColors is not registered in ThemeData.extensions.',
    );
    return kolors!;
  }
}
