import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<int> visibleBranchIndexes = <int>[0, 1, 2];
  static const bool showNavigation = true;

  int get _selectedNavigationIndex =>
      visibleBranchIndexes.indexOf(navigationShell.currentIndex);

  void _selectNavigationDestination(int navigationIndex) {
    final branchIndex = visibleBranchIndexes[navigationIndex];
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedNavigationIndex = _selectedNavigationIndex;
    if (!showNavigation || selectedNavigationIndex < 0) {
      return Scaffold(body: navigationShell);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: selectedNavigationIndex,
                  onDestinationSelected: _selectNavigationDestination,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.circle_outlined),
                      selectedIcon: Icon(Icons.circle),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.circle_outlined),
                      selectedIcon: Icon(Icons.circle),
                      label: Text('Blog'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.circle_outlined),
                      selectedIcon: Icon(Icons.circle),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedNavigationIndex,
            onDestinationSelected: _selectNavigationDestination,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.circle_outlined),
                selectedIcon: Icon(Icons.circle),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.circle_outlined),
                selectedIcon: Icon(Icons.circle),
                label: 'Blog',
              ),
              NavigationDestination(
                icon: Icon(Icons.circle_outlined),
                selectedIcon: Icon(Icons.circle),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
