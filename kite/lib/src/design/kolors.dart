import 'package:flutter/material.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
@immutable
class KiteColors extends ThemeExtension<KiteColors> {
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
  // Brand
  // ===========================================================================

  /// Primary brand and interactive color.
  final Color primary;

  /// Content displayed on [primary].
  final Color onPrimary;

  /// Secondary brand or supporting accent.
  final Color secondary;

  /// Content displayed on [secondary].
  final Color onSecondary;

  // ===========================================================================
  // Base
  // ===========================================================================

  /// Main page and scaffold background.
  final Color background;

  /// Cards, sheets, dialogs, and content containers.
  final Color card;

  /// Low-emphasis neutral background.
  final Color muted;

  /// Form control and editable field background.
  final Color inputFill;

  // ===========================================================================
  // Border
  // ===========================================================================

  /// Base border color used to derive border variants.
  final Color border;

  // ===========================================================================
  // Content
  // ===========================================================================

  /// Primary readable content.
  final Color textPrimary;

  /// Supporting and secondary content.
  final Color textSecondary;

  /// Disabled content.
  final Color textDisabled;

  /// Default icon color.
  final Color icon;

  // ===========================================================================
  // Status
  // ===========================================================================

  /// Positive or completed state.
  final Color success;

  /// Warning or attention state.
  final Color warning;

  /// Error or destructive state.
  final Color error;

  /// Informational state.
  final Color info;

  // ===========================================================================
  // Generated Brand
  // ===========================================================================

  /// Subtle primary background.
  Color get primarySoft => soft(primary);

  /// Subtle secondary background.
  Color get secondarySoft => soft(secondary);

  // ===========================================================================
  // Generated Status
  // ===========================================================================

  Color get successSoft => soft(success);

  Color get warningSoft => soft(warning);

  Color get errorSoft => soft(error);

  Color get infoSoft => soft(info);

  // ===========================================================================
  // Generated Borders
  // ===========================================================================

  /// Quiet border for cards and subtle separation.
  Color get borderSoft => _mix(card, border, 0.55);

  /// Strong border for emphasized or interactive boundaries.
  Color get borderStrong => _mix(border, textPrimary, 0.22);

  // ===========================================================================
  // Generated Semantic
  // ===========================================================================

  /// Standard divider and separator color.
  Color get divider => borderSoft;

  /// Keyboard and accessibility focus color.
  Color get focusRing => primary;

  /// Modal, drawer, and dialog backdrop.
  Color get overlay => textPrimary.withValues(alpha: 0.55);

  /// Disabled or inactive component background.
  Color get disabledFill => muted;

  /// Selected low-emphasis background.
  Color get selectedFill => primarySoft;

  // ===========================================================================
  // Utilities
  // ===========================================================================

  /// Creates an opaque subtle version of [color].
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
  KiteColors get colors {
    final colors = Theme.of(this).extension<KiteColors>();
    if (colors != null) return colors;

    throw FlutterError.fromParts([
      ErrorSummary('KiteColors is not registered in ThemeData.extensions.'),
      ErrorDescription(
        'A widget requested context.colors, but the active ThemeData does not '
        'contain a KiteColors extension.',
      ),
      ErrorHint(
        'Build the app theme with KiteTheme.use(...) or register KiteColors '
        'in ThemeData.extensions.',
      ),
    ]);
  }
}
