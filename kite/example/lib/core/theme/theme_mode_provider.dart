import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_storage_keys.dart';
import '../preferences/app_preferences_provider.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

final class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored = ref
        .watch(appPreferencesProvider)
        .getString(AppStorageKeys.themeMode);
    for (final mode in ThemeMode.values) {
      if (mode.name == stored) {
        return mode;
      }
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) {
      return;
    }

    state = mode;
    await ref
        .read(appPreferencesProvider)
        .setString(AppStorageKeys.themeMode, mode.name);
  }
}
