import 'package:flutter/widgets.dart';

/// Built with Kite 🪁
/// Flutter foundations, architecture, and developer tooling.
/// Learn more: https://kite.orkitt.dev
extension NumSpacingX on num {
  // Dynamic SizedBox spacing
  SizedBox get vBox => SizedBox(height: toDouble());
  SizedBox get hBox => SizedBox(width: toDouble());
  SizedBox get box => SizedBox(height: toDouble());

  // Dynamic EdgeInsets
  EdgeInsets get padAll => EdgeInsets.all(toDouble());
  EdgeInsets get padH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get padV => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get padTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get padBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get padLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get padRight => EdgeInsets.only(right: toDouble());

  // Radius Shortcut
  Radius get radius => Radius.circular(toDouble());
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());
  // ── Padding (EdgeInsets) ───────────────────────────────────────────────────
  /// All-side padding (`EdgeInsets.all(value)`)
  EdgeInsets get p => EdgeInsets.all(toDouble());

  /// Horizontal padding (`EdgeInsets.symmetric(horizontal: value)`)
  EdgeInsets get px => EdgeInsets.symmetric(horizontal: toDouble());

  /// Vertical padding (`EdgeInsets.symmetric(vertical: value)`)
  EdgeInsets get py => EdgeInsets.symmetric(vertical: toDouble());

  // ── Radius & BorderRadius ─────────────────────────────────────────────────
  /// Single `Radius` object (`Radius.circular(value)`)
  Radius get r => Radius.circular(toDouble());

  /// Complete `BorderRadius` object (`BorderRadius.circular(value)`)
  BorderRadius get rad => BorderRadius.circular(toDouble());
}

extension EdgeInsetsX on EdgeInsets {
  /// Combine paddings: `16.px + 8.py`
  EdgeInsets operator +(EdgeInsets other) {
    return EdgeInsets.only(
      left: left + other.left,
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
    );
  }
}
