# Kite Flutter Complete Devpack

```text
                         KITE
                          │
          ┌───────────────┴───────────────┐
          │                               │
        kite                           kite_cli
   Flutter Dev Pack                  Dart CLI Tool
          │                               │
 package:kite/kite_ui.dart          executable: kite
```

**Kite🪁** is a Flutter development ecosystem designed to reduce repetitive project setup and boilerplate while keeping generated applications clean, scalable, and developer-owned.

The ecosystem is divided into two packages:

* **`kite`** — Flutter development pack containing reusable UI, utilities, and application foundations.
* **`kite_cli`** — Dart CLI for project initialization, feature scaffolding, routing, networking, database setup, and project synchronization.

---

## Installation

Activate Kite CLI globally with Dart:

```bash
dart pub global activate kite_cli
```

Verify the installation:

```bash
kite --version
```

View available commands:

```bash
kite --help
```

---

# Quick Start

Create a Flutter application:

```bash
flutter create my_app
cd my_app
```

Initialize Kite:

```bash
kite init
```

Or initialize the application with independent shell navigation branches:

```bash
kite init --shell "[home,blog,settings]"
```

Kite generates the application foundation and creates the requested shell branches as real application features.

Example:

```text
lib/
├── app/
│   └── router/
├── core/
├── features/
│   ├── home/
│   ├── blog/
│   └── settings/
├── shared/
└── main.dart
```

The shell uses `StatefulShellRoute.indexedStack`, allowing each branch to preserve its own navigation stack.

---

# Feature Generation

## Clean Architecture

Generate a feature using Feature-First Clean Architecture:

```bash
kite --feat:clean dashboard
```

Generated structure:

```text
lib/features/dashboard/
├── data/
│   ├── dtos/
│   ├── repositories/
│   └── sources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

Generate the feature and register a route:

```bash
kite --feat:clean dashboard --route
```

---

## MVC

Generate an MVC feature:

```bash
kite --feat:mvc dashboard
```

With routing:

```bash
kite --feat:mvc dashboard --route
```

Clean and MVC features share the same centralized routing system.

---

# Shell Routing

Initialize an application with navigation branches:

```bash
kite init --shell "[home,blog,settings]"
```

You can also use:

```bash
kite init --shell "home,blog,settings"
```

The resulting route topology is similar to:

```text
/
├── home
├── blog
└── settings
```

Each branch is backed by its own `StatefulShellBranch`.

Kite also generates the corresponding root features:

```text
features/
├── home/
├── blog/
└── settings/
```

Generated branch routes reference the actual feature screens.

For example:

```dart
final StatefulShellBranch homeBranch = StatefulShellBranch(
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
      routes: <RouteBase>[],
    ),
  ],
);
```

---

# Nested Routes with `--into`

Generate a feature inside an existing shell branch:

```bash
kite --feat:clean details --route --into blog
```

Kite generates:

```text
lib/features/details/
```

while registering:

```text
/blog/details
```

The feature itself is **not nested inside the blog feature**.

```text
features/
├── blog/
└── details/
```

The branch only controls the route topology.

Application navigation uses generated route constants:

```dart
context.go(AppRoutes.blogDetails);
```

instead of hardcoded URLs.

---

# Centralized Routing

Features do not own application routing.

Generated routing is managed centrally:

```text
lib/app/router/
├── app_router.dart
├── app_routes.dart
├── app_shell.dart
└── generated/
    ├── generated_routes.dart
    ├── root_routes.dart
    ├── branches/
    └── features/
```

Kite-owned files under:

```text
lib/app/router/generated/
```

may be regenerated automatically.

Application route URLs remain centralized through:

```dart
AppRoutes
```

---

# `kite.yaml`

Kite uses `kite.yaml` as the declarative source of truth for project configuration.

Example:

```yaml
schema_version: 1

project:
  preset: clean
  source_directory: lib

architecture:
  type: clean
  feature_directory: lib/features

state_management:
  type: riverpod
  code_generation: false

routing:
  type: go_router
  auto_register_features: true

  shell:
    enabled: true
    branches:
      - name: home
        path: /
        feature: home

      - name: blog
        path: /blog
        feature: blog

      - name: settings
        path: /settings
        feature: settings

  routes: []

generation:
  format_after_generation: true
  install_dependencies: true
  conflict_strategy: skip
```

---

# Kite Sync

After initialization, `kite.yaml` continues to describe the desired Kite-managed project state.

Apply configuration changes with:

```bash
kite sync
```

For example, manually add another route:

```yaml
routing:
  routes:
    - feature: details
      path: /blog/details
      segment: details
      branch: blog
      architecture: clean

    - feature: photo
      path: /blog/photo
      segment: photo
      branch: blog
      architecture: clean
```

Then run:

```bash
kite sync
```

If `photo` does not exist yet, Kite creates the missing feature and wires the route automatically.

```text
✓ Created missing feature: photo
✓ Registered /blog/photo
✓ Updated generated routing
```

Existing developer-owned feature files are preserved.

---

# Hidden Shell Branches

A shell branch does not have to appear in the application's navigation bar.

Example:

```yaml
shell:
  enabled: true

  branches:
    - name: home
      path: /
      feature: home

      navigation:
        visible: true
        label: Home

    - name: blog
      path: /blog
      feature: blog

      navigation:
        visible: true
        label: Blog

    - name: checkout
      path: /checkout
      feature: checkout

      navigation:
        visible: false
```

`checkout` remains a real independent shell branch while staying outside the primary navigation UI.

---

# Route Parameters

Kite routing configuration supports typed path parameter metadata.

Example:

```yaml
routes:
  - feature: details
    path: /blog/details/:id
    segment: details/:id
    branch: blog
    architecture: clean

    parameters:
      path:
        - name: id
          type: String
          required: true
```

This keeps routing topology and parameter definitions declarative and available to `kite sync`.

---

# Application Foundations

`kite init` can generate common application foundations including:

```text
lib/core/constants/
├── app_constants.dart
├── app_storage_keys.dart
└── app_environment.dart
```

`AppConstants.appName` is generated from the actual Flutter project name rather than a hardcoded example value.

Example:

```dart
abstract final class AppConstants {
  static const String appName = 'Study Room';
}
```

---

## Preferences

Shared application preferences live under:

```text
lib/core/preferences/
```

Kite provides the SharedPreferences infrastructure and Riverpod providers required by generated application foundations.

---

## Theme Mode

Kite includes a Riverpod theme-mode provider with preference persistence.

Supported modes:

```text
System
Light
Dark
```

A reusable theme changer is generated at:

```text
lib/shared/widgets/theme_changer.dart
```

Usage:

```dart
const ThemeChanger()
```

---

# Isar Offline Database

Install Kite's Isar database foundation:

```bash
kite --db:isar
```

Equivalent canonical syntax:

```bash
kite db isar
```

Kite configures the offline database infrastructure and records it in `kite.yaml`.

Example:

```yaml
database:
  enabled: true
  type: isar
```

Generated infrastructure lives under:

```text
lib/core/database/
├── app_database.dart
├── app_database_provider.dart
└── generated/
    └── isar_schemas.dart
```

The schema registry is Kite-managed so additional local database capabilities can be integrated consistently in future versions.

Running:

```bash
kite sync
```

can restore missing Kite-managed database infrastructure from the project configuration.

---

# Dio Networking

Install the Dio networking foundation:

```bash
kite --api:dio
```

Kite generates a reusable network client, providers, interceptors, exception handling, cancellation support, progress callbacks, and development logging.

---

## Bearer Authentication

Add secure bearer-token support:

```bash
kite --api:dio --auth bearer
```

This adds secure authentication infrastructure using `flutter_secure_storage`.

Generated concepts include:

```text
AuthSession
AuthTokenStorage
SecureAuthTokenStorage
BearerTokenInterceptor
authenticatedDioApiClientProvider
```

Bearer credentials are attached using:

```http
Authorization: Bearer <token>
```

Authentication storage remains separated from normal SharedPreferences-based application preferences.

---

# Dry Run

Preview generation without modifying the project:

```bash
kite --feat:clean dashboard --dry-run
```

You can also preview synchronization:

```bash
kite sync --dry-run
```

---

# Safe Generation

Kite is designed to preserve developer ownership.

The generator supports:

* dry-run generation
* conflict detection
* checksums
* `.kite/manifest.json`
* dependency deduplication
* formatting
* skip-existing behavior
* force generation
* template dependency resolution
* idempotent synchronization

Kite-managed generated infrastructure may be safely regenerated.

Developer-owned feature code is not silently deleted during synchronization.

---

# Template Driven

Kite itself is template-driven.

Infrastructure such as:

```text
routing
features
constants
preferences
theme
database
networking
authentication
```

is generated from Kite templates rather than being tightly hardcoded into individual commands.

This allows the ecosystem to evolve while keeping the CLI architecture maintainable.

---

# Philosophy

Kite follows a simple principle:

> Generate the repetitive foundation, preserve developer ownership, and keep the resulting Flutter project understandable without requiring Kite at runtime.

Generated applications should remain normal Flutter applications.

Kite helps build them faster.

---

## License

See the repository license for details.

Kite 🪁 | Built with care. Powered by **Orkitt**.
