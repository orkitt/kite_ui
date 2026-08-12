import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Returns this color with [opacity] applied using modern Flutter color APIs.
  Color withOpacityValue(double opacity) {
    return withValues(
      alpha: opacity.clamp(0.0, 1.0).toDouble(),
    );
  }

  /// Returns this color as a CSS-style hexadecimal string.
  String toHex({
    bool includeAlpha = false,
    bool leadingHash = true,
  }) {
    final value = toARGB32();
    final hex = value.toRadixString(16).padLeft(8, '0').toUpperCase();
    final body = includeAlpha ? hex : hex.substring(2);

    return leadingHash ? '#$body' : body;
  }
}
