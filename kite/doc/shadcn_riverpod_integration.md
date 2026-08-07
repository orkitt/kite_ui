# shadcn_ui and Riverpod integration

Kite does not depend on either package, but works well with both.

## Riverpod-owned shell controller

```dart
final kiteShellControllerProvider = Provider<KiteShellController>((ref) {
  final controller = KiteShellController();
  ref.onDispose(controller.dispose);
  return controller;
});
```

Pass the controller into `KiteGoRouterShell`.

## shadcn_ui content

Kite only decides page structure. Place Shad cards, buttons, tables, sheets, and dialogs inside `KitePage`, `KiteGrid`, `KiteSplitView`, or `KiteRouteMasterDetail`.

```dart
KiteRepresentation(
  compact: ProductCardList(),
  expanded: ShadTable(...),
)
```

A custom top bar can also be built entirely with shadcn_ui while using `KiteShellActions` for the drawer and sidebar controls.
