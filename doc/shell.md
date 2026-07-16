# Shell and navigation

`KiteShell` supports five navigation modes:

| Mode | Typical target |
|---|---|
| `drawer` | compact mobile with many destinations |
| `bottomNavigation` | compact mobile with frequent top-level destinations |
| `rail` | tablet and narrow desktop |
| `collapsedSidebar` | desktop focused on content width |
| `expandedSidebar` | large desktop |

The mode comes from `KiteNavigationPolicy` and the semantic size resolved by `KiteScope`.

## Custom top bar

```dart
KiteShell(
  topBarBuilder: (context, actions) {
    return AdminTopBar(
      showMenu: actions.navigationMode == KiteNavigationMode.drawer ||
          actions.navigationMode == KiteNavigationMode.bottomNavigation,
      onMenuPressed: actions.openNavigation,
      onToggleSidebar: actions.toggleSidebar,
    );
  },
  // ...
)
```

## Permission filtering

```dart
KiteShell(
  canAccess: (item) {
    return item.requiredPermissions.every(userPermissions.contains);
  },
  // ...
)
```

This only controls navigation visibility. Real authorization must still be enforced by routing guards and the backend.

## Sidebar state

```dart
final controller = KiteShellController();

KiteShell(
  controller: controller,
  // ...
)
```

The controller may optionally use a `KitePreferencesStore` adapter.
