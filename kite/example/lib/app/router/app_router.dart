import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'generated/generated_routes.dart';
import 'navigator_observer.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: generatedInitialLocation,
    observers: <NavigatorObserver>[KiteNavigatorObserver()],
    routes: generatedRoutes,
  );
});
