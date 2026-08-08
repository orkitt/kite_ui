import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin AsyncNotifierGuard<T> on AsyncNotifier<T> {
  Future<void> runGuarded(
    Future<T> Function() operation, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(operation);
  }
}
