# Architecture

Kite is intentionally small and layered.

```text
KiteScope
  └─ resolves semantic layout data

Layout widgets
  ├─ KitePage
  ├─ KiteGrid
  ├─ KiteSplitView
  ├─ KiteBuilder
  └─ KiteMasterDetail

Navigation
  ├─ KiteShell
  ├─ KiteBottomNavigation
  ├─ rail / drawer / sidebar presentations
  └─ KiteShellController

GoRouter integration
  ├─ KiteGoRouterShell
  ├─ KiteRouteMasterDetail
  ├─ context.openKiteDetail
  └─ KiteBreadcrumbs
```

## Design-system neutral

Kite uses Material navigation primitives internally, but feature content can use shadcn_ui, Material, Cupertino, or an internal design system. No feature package must depend on Kite-specific buttons, cards, forms, or typography.

## State-management neutral

Kite does not depend on Riverpod, Bloc, Provider, or GetX. `KiteShellController` extends `ChangeNotifier`, which can be owned directly or exposed through the application's preferred state-management solution.

## Layout adaptation rather than scaling

Kite avoids `.dp`-style proportional scaling. Semantic layout decisions are more appropriate for dashboards:

- cards become tables
- columns stack
- a sidebar becomes a rail or bottom bar
- master-detail becomes nested navigation
- secondary actions move or wrap

Fonts and controls keep normal platform dimensions unless the application explicitly changes them.
