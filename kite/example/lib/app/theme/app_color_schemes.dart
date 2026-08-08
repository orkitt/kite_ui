import 'package:flutter/material.dart';

abstract final class AppColorSchemes {
  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: const Color(0xFF4F46E5),
    brightness: Brightness.light,
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: const Color(0xFF818CF8),
    brightness: Brightness.dark,
  );
}
