# Kite 🪁

**Kite** is a Flutter development ecosystem for building clean, scalable, and consistent applications with less boilerplate.

It combines reusable Flutter foundations with a companion CLI for project scaffolding, architecture, routing, networking, offline storage, and developer tooling.

## Kite Ecosystem

```text
                         KITE
                          │
          ┌───────────────┴───────────────┐
          │                               │
        kite                           kite_cli
   Flutter Dev Pack                    Dart CLI
          │                               │
 package:kite/kite_ui.dart          executable: kite
````

* **`kite`** — Flutter UI foundations, themes, responsive utilities, extensions, and reusable developer tooling.
* **`kite_cli`** — project initialization, feature generation, routing, networking, database setup, and synchronization.

Kite-generated applications remain standard Flutter projects while preserving developer ownership of application code.

## Installation

Install the companion CLI:

```bash
dart pub global activate kite_cli
```

Verify the installation:

```bash
kite --version
```

## Quick Start

```bash
flutter create my_app
cd my_app

kite init
```

Kite generates a structured application foundation:

```text
lib/
├── app/
├── core/
├── features/
├── shared/
└── main.dart
```

## Philosophy

> Generate the repetitive foundation, preserve developer ownership, and keep the resulting Flutter project easy to understand.

Kite accelerates development without hiding Flutter behind another framework.

## Documentation

* **[kite.orkitt.dev](https://kite.orkitt.dev)**
* **[pub.dev/packages/kite](https://pub.dev/packages/kite)**
* **[pub.dev/packages/kite_cli](https://pub.dev/packages/kite_cli)**

## License

Licensed under the **Apache License 2.0**.

Copyright © 2026 **Orkitt**.

**Kite 🪁 — Built with care by Orkitt.**
