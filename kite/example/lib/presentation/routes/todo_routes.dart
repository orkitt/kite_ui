import 'package:go_router/go_router.dart';

import '../../../../lib/app/router/app_routes.dart';
import '../screens/todo_screen.dart';

final List<RouteBase> todoRoutes = <RouteBase>[
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => const TodoScreen(),
  ),
];
