import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kite/kite.dart';

import 'screens/chat_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/list_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const KiteExampleApp());
}

class KiteExampleApp extends StatefulWidget {
  const KiteExampleApp({super.key});

  @override
  State<KiteExampleApp> createState() => _KiteExampleAppState();
}

class _KiteExampleAppState extends State<KiteExampleApp> {
  late final GoRouter _router = _createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kite Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
        extensions: const [
          KiteShellThemeData(
            sidebarWidth: 280,
            collapsedSidebarWidth: 76,
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF818CF8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        extensions: const [KiteShellThemeData()],
      ),
      routerConfig: _router,
      builder: (context, child) {
        return KiteScope(
          navigationPolicy: const KiteNavigationPolicy(
            compact: KiteNavigationMode.bottomNavigation,
            medium: KiteNavigationMode.rail,
            expanded: KiteNavigationMode.collapsedSidebar,
            large: KiteNavigationMode.expandedSidebar,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

GoRouter _createRouter() {
  return GoRouter(
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return KiteGoRouterShell(
            navigationShell: navigationShell,
            navigationGroups: appNavigation,
            bottomNavigationMaxItems: 5,
            sidebarHeader: const _Brand(),
            sidebarFooter: const _AccountFooter(),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const ListScreen(
                  title: 'Orders',
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                builder: (context, state) => const ListScreen(
                  title: 'Customers',
                  icon: Icons.people_outline,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => ChatShell(
                  location: state.uri.path,
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: '/chat',
                    builder: (context, state) => const ChatPlaceholder(),
                  ),
                  GoRoute(
                    path: '/chat/:conversationId',
                    builder: (context, state) => ChatConversation(
                      id: state.pathParameters['conversationId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ListScreen(
                  title: 'Reports',
                  icon: Icons.insights_outlined,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) => SettingsShell(
                  location: state.uri.path,
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: '/settings',
                    builder: (context, state) => const ProfileSettingsPage(),
                  ),
                  GoRoute(
                    path: '/settings/profile',
                    builder: (context, state) => const ProfileSettingsPage(),
                  ),
                  GoRoute(
                    path: '/settings/appearance',
                    builder: (context, state) => const SettingsDetailPage(
                      title: 'Appearance',
                      icon: Icons.palette_outlined,
                    ),
                  ),
                  GoRoute(
                    path: '/settings/notifications',
                    builder: (context, state) => const SettingsDetailPage(
                      title: 'Notifications',
                      icon: Icons.notifications_none,
                    ),
                  ),
                  GoRoute(
                    path: '/settings/security',
                    builder: (context, state) => const SettingsDetailPage(
                      title: 'Security',
                      icon: Icons.shield_outlined,
                    ),
                  ),
                  GoRoute(
                    path: '/settings/billing',
                    builder: (context, state) => const SettingsDetailPage(
                      title: 'Billing',
                      icon: Icons.credit_card_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

const appNavigation = <KiteNavGroup>[
  KiteNavGroup(
    items: [
      KiteNavItem(
        label: 'Dashboard',
        route: '/dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        branchIndex: 0,
      ),
      KiteNavItem(
        label: 'Orders',
        route: '/orders',
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        branchIndex: 1,
      ),
      KiteNavItem(
        label: 'Customers',
        route: '/customers',
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        branchIndex: 2,
      ),
      KiteNavItem(
        label: 'Chat',
        route: '/chat',
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble,
        branchIndex: 3,
      ),
      KiteNavItem(
        label: 'Reports',
        route: '/reports',
        icon: Icons.insights_outlined,
        activeIcon: Icons.insights,
        branchIndex: 4,
      ),
      KiteNavItem(
        label: 'Settings',
        route: '/settings',
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        branchIndex: 5,
      ),
    ],
  ),
];


class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.air, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Flexible(
          child: Text(
            'Kite',
            overflow: TextOverflow.fade,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class _AccountFooter extends StatelessWidget {
  const _AccountFooter();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(child: Text('SA')),
        SizedBox(width: 10),
        Flexible(child: Text('Sakil Ahmed')),
      ],
    );
  }
}
