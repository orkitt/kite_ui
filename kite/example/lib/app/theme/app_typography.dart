import 'package:flutter/material.dart';
import 'package:kite/kite_ui.dart';

abstract final class AppTypography {
  AppTypography._();

  static final KiteTypography textStyle = KiteTypography(
    display: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.8,
    ),
    h1: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.5,
    ),
    h2: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.3,
    ),
    h3: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: -0.2,
    ),
    title: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: -0.1,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.0,
    ),
    body: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
      letterSpacing: 0.0,
    ),
    bodySmall: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0.0,
    ),
    label: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0.1,
    ),
    labelSmall: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0.2,
    ),
    caption: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.3,
      letterSpacing: 0.0,
    ),
  );
}
