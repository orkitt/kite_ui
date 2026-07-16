# Master-detail layouts

Use `KiteRouteMasterDetail` for settings, chat, inboxes, tickets, file managers, products, and customer profiles.

```dart
KiteRouteMasterDetail(
  rootRoute: '/settings',
  currentLocation: state.uri.path,
  master: const SettingsNavigation(),
  detail: child,
  masterWidth: 280,
)
```

## Behavior

```text
Desktop
┌────────────────┬─────────────────────────┐
│ master         │ detail                  │
└────────────────┴─────────────────────────┘

Mobile /settings
┌──────────────────────────────────────────┐
│ master                                   │
└──────────────────────────────────────────┘

Mobile /settings/security
┌──────────────────────────────────────────┐
│ back header                              │
│ detail                                   │
└──────────────────────────────────────────┘
```

The default mobile header falls back to the root route when there is no Navigator page to pop.

## Three-column chat

Compose a master-detail shell with `KiteSplitView` inside the detail:

```dart
KiteRouteMasterDetail(
  master: conversationList,
  detail: KiteSplitView(
    sideBySideFrom: KiteLayoutSize.large,
    primary: messagePanel,
    secondary: customerDetails,
  ),
)
```

This produces one column on compact screens, two columns on desktop, and three columns on large screens.
