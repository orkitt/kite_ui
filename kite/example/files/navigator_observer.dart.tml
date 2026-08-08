import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logScreen(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logScreen(newRoute);
    }
  }

  void _logScreen(Route<dynamic> route) {
    final screenName = route.settings.name;
    if (screenName != null && screenName.isNotEmpty) {
      // Replace print with your analytics service call (e.g., Firebase, Mixpanel)
      debugPrint('[Analytics] Screen Viewed: $screenName');
    }
  }
}
