import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/preferences/app_preferences_provider.dart';
import '../core/state/riverpod_bootstrap.dart';

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(
    buildProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: builder(),
    ),
  );
}
