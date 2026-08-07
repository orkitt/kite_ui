# GoRouter integration

Kite's responsive core is independent of routing. GoRouter-specific APIs live in `src/routing`.

## Stateful shell

`KiteGoRouterShell` bridges a `StatefulNavigationShell` into `KiteShell`.

- An item with `branchIndex` switches branches.
- An item without `branchIndex` uses `context.go(item.route)`.
- The active destination is selected from the current URI.

## Top-level versus nested navigation

Use top-level branch navigation for dashboard modules:

```dart
context.go('/orders');
```

Use nested navigation for settings, chat conversations, and entity details:

```dart
context.openKiteDetail('/settings/security');
```

`openKiteDetail` uses `push` on compact screens and `go` on wider screens.

## Browser and deep-link behavior

Every master-detail selection remains a real URL, such as:

```text
/settings/security
/chat/customer-42
/customers/customer-42
```

A browser refresh or copied link therefore restores the selected detail.
