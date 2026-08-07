# Mobile bottom navigation

Kite supports an actual bottom navigation bar as a compact shell mode.

```dart
KiteScope(
  navigationPolicy: const KiteNavigationPolicy(
    compact: KiteNavigationMode.bottomNavigation,
  ),
  child: child,
)
```

## Overflow

Material bottom navigation works best with a small number of frequent destinations. `KiteBottomNavigation` displays up to `maxVisibleItems`. When the item count is larger, the final destination becomes **More** and opens a bottom sheet.

```dart
KiteGoRouterShell(
  bottomNavigationMaxItems: 5,
  // ...
)
```

A six-item shell therefore displays four direct destinations plus More.

## Excluding an item

```dart
KiteNavItem(
  label: 'Audit log',
  route: '/audit',
  icon: Icons.history,
  showInBottomNavigation: false,
)
```

The item remains available in the drawer, rail, and sidebar.

## Branch switching

Give top-level destinations a `branchIndex`. `KiteGoRouterShell` then calls `StatefulNavigationShell.goBranch` and preserves each branch's navigation stack.
