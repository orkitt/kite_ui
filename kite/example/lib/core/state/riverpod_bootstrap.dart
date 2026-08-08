import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'app_provider_observer.dart';

Widget buildProviderScope({
  required Widget child,
  List<Override> overrides = const <Override>[],
  List<ProviderObserver> observers = const <ProviderObserver>[],
}) {
  return ProviderScope(
    overrides: overrides,
    observers: <ProviderObserver>[
      if (kDebugMode) const AppProviderObserver(),
      ...observers,
    ],
    retry: ProviderContainer.defaultRetry,
    child: child,
  );
}
