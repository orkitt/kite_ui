import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _selectBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  minExtendedWidth: 320,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _selectBranch,
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
                      label: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _selectBranch,
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
