# Kite CLI 🪁

**Kite CLI** is a Flutter project scaffolding and developer tooling CLI focused on creating clean, maintainable, and production-ready Flutter foundations.

Instead of repeatedly creating architecture folders, providers, API infrastructure, shared components, routing setup, and common boilerplate by hand, Kite generates a consistent starting point while leaving your actual business logic under your control.

```bash
dart pub global activate kite_cli
```

Once installed, the executable is simply:

```bash
kite
```

---

## Why Kite?

Starting a Flutter project is easy.

Keeping its architecture consistent as the project grows is harder.

Kite helps standardize common Flutter development tasks such as:

* Initializing a maintainable project foundation
* Generating Feature-First Clean Architecture modules
* Generating lightweight MVC features
* Adding reusable shared UI components
* Setting up modern Riverpod infrastructure
* Creating a production-ready Dio networking layer
* Managing reusable templates and their dependencies
* Safely upgrading generated files

Kite intentionally generates **structure and infrastructure**, not imaginary business logic.

You remain responsible for your APIs, repository operations, entities, use cases, and application-specific behavior.

---

# Features

### Feature generators

* Feature-First Clean Architecture
* MVC architecture
* Optional GoRouter route registration
* Optional JSON serialization setup

### Flutter infrastructure

* Manual Riverpod `Notifier` / `AsyncNotifier`
* Dio API client
* Bearer token interceptor
* API exception mapping
* Request cancellation
* Typed response decoding
* Shared loading, error, and empty states

### Reusable components

* Kite Button
* Kite Card
* Kite Avatar
* Dependency-aware component generation

### Generator system

* Versioned JSON template manifests
* Recursive template dependencies
* Dependency deduplication
* Conflict detection
* Checksums
* Dry-run support
* Safe upgrades
* Automatic dependency installation
* Automatic Dart formatting

---

# Installation

Install Kite CLI globally from pub.dev:

```bash
dart pub global activate kite_cli
```

Verify the installation:

```bash
kite --version
```

You should see something similar to:

```text
Kite CLI 0.x.x
```

View available commands:

```bash
kite --help
```

View registered templates:

```bash
kite templates
```

---

## Command not found?

If Dart's global executable directory is not in your `PATH`, add it.

### macOS / Linux

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

For Zsh:

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

Then verify:

```bash
which kite
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

Generate your first feature:

```bash
kite --feat:clean dashboard
```

Add a shared component:

```bash
kite --widget button
```

Add Riverpod infrastructure:

```bash
kite --state riverpod
```

Add Dio networking:

```bash
kite --api:dio
```

Then:

```bash
flutter pub get
flutter analyze
```

---

# Initialize a Flutter Project

Run Kite inside an existing Flutter application:

```bash
kite init
```

Kite initializes the common application foundation required by generated features.

Typical generated structure:

```text
lib/
├── app/
│   ├── router/
│   └── theme/
│
├── core/
│   ├── errors/
│   ├── result/
│   └── state/
│
├── features/
│
├── shared/
│   ├── components/
│   └── widgets/
│
└── main.dart
```

Kite also creates project configuration files such as:

```text
kite.yaml
.kite/
└── manifest.json
```

The `.kite` manifest tracks generated templates and managed files so future upgrades can be handled safely.

---

## Init options

Preview changes without writing files:

```bash
kite init --dry-run
```

Overwrite existing generated files:

```bash
kite init --force
```

Skip existing files:

```bash
kite init --skip-existing
```

Skip automatic dependency installation:

```bash
kite init --no-dependencies
```

Skip automatic formatting:

```bash
kite init --no-format
```

Target another Flutter project:

```bash
kite init --path ./apps/mobile
```

Create a GoRouter shell with independent navigation stacks:

```bash
kite init --shell "[home,blog,profile]"
```

The unbracketed form is equivalent:

```bash
kite init --shell "home,blog,profile"
```

The first branch becomes the `/` branch. Later branches use kebab-case paths, so the example configures:

```text
/
/blog
/profile
```

Kite generates a `StatefulShellRoute.indexedStack` and one `StatefulShellBranch` per configured branch. `AppShell` switches branches with `StatefulNavigationShell.goBranch`, so each branch keeps its own navigation stack.

---

# Clean Architecture

Generate a Feature-First Clean Architecture module:

```bash
kite --feat:clean dashboard
```

Canonical command:

```bash
kite feature dashboard --architecture clean
```

Generated structure:

```text
lib/features/dashboard/
├── data/
│   ├── dtos/
│   │   └── dashboard_dto.dart
│   │
│   ├── repositories/
│   │   └── dashboard_repository_impl.dart
│   │
│   └── sources/
│       └── dashboard_remote_source.dart
│
├── domain/
│   ├── entities/
│   │   └── dashboard_entity.dart
│   │
│   ├── repositories/
│   │   └── dashboard_repository.dart
│   │
│   └── usecases/
│       └── get_dashboard_use_case.dart
│
└── presentation/
    ├── providers/
    │   └── dashboard_providers.dart
    │
    ├── screens/
    │   └── dashboard_screen.dart
    │
    └── widgets/
        └── dashboard_content.dart
```

The generated architecture follows three clear boundaries:

### Domain

Contains application business contracts and entities.

```text
domain/
├── entities/
├── repositories/
└── usecases/
```

The domain layer should remain independent of Flutter, Dio, Riverpod, and other frameworks.

### Data

Contains external data access and repository implementations.

```text
data/
├── dtos/
├── repositories/
└── sources/
```

### Presentation

Contains Flutter-specific UI and state management.

```text
presentation/
├── providers/
├── screens/
└── widgets/
```

Kite intentionally leaves repository and source contracts without fake API operations.

You define the actual behavior required by your feature.

---

# MVC Architecture

For smaller features or applications where full Clean Architecture would be unnecessary, Kite also provides an MVC generator.

```bash
kite --feat:mvc dashboard
```

Canonical forms:

```bash
kite feature dashboard --architecture mvc
```

or:

```bash
kite feature dashboard --mvc
```

Generated structure:

```text
lib/features/dashboard/
├── controllers/
│   └── dashboard_controller.dart
│
├── models/
│   └── dashboard_model.dart
│
├── providers/
│   └── dashboard_providers.dart
│
└── views/
    ├── screens/
    │   └── dashboard_screen.dart
    │
    └── widgets/
        └── dashboard_content.dart
```

---

# Route Generation

Routing is application composition, so generated features no longer own route folders. Kite keeps the runtime route graph under:

```text
lib/app/router/
├── app_router.dart
├── app_routes.dart
├── app_shell.dart              # shell projects
├── navigator_observer.dart
└── generated/
    ├── generated_routes.dart
    ├── root_routes.dart
    ├── branches/
    └── features/
```

`kite.yaml` is the routing topology source of truth, while `AppRoutes` is the single source of truth for runtime URL constants.

Generate a root-level route:

```bash
kite --feat:clean about --route
```

This keeps the feature at:

```text
lib/features/about/
```

and registers:

```text
/about
```

For a shell project, place a feature route into a configured branch with `--into`:

```bash
kite --feat:clean details --route --into blog
```

The feature still lives independently at:

```text
lib/features/details/
```

but its route becomes:

```text
/blog/details
```

Application code navigates with the generated constant:

```dart
context.go(AppRoutes.blogDetails);
```

MVC uses exactly the same central routing flow:

```bash
kite --feat:mvc account --route --into profile
```

`--into` is valid only together with `--route`, and the branch must already exist in `kite.yaml`. Kite never silently creates a missing shell branch.

Generated route files under `lib/app/router/generated/` are Kite-owned and can be regenerated. Existing legacy files such as `features/*/presentation/routes/` or `features/*/routes/` are not deleted automatically during migration.

---

# JSON Serialization

Generate a JSON-ready DTO or model:

```bash
kite --feat:clean dashboard --json
```

For MVC:

```bash
kite --feat:mvc dashboard --json
```

Kite adds the required serialization dependencies:

```text
json_annotation
json_serializable
build_runner
```

After adding actual fields to the generated model or DTO, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Kite uses JSON code generation for serialization only.

Riverpod code generation is not required.

---

# Reusable Components

Kite can generate common reusable components inside your shared UI layer.

## Button

```bash
kite --widget button
```

## Multiple components

```bash
kite --widget "[button,card,avatar]"
```

The commonly mistyped:

```bash
kite --widget "[button,card,avater]"
```

is also accepted and normalized to `avatar`.

Canonical forms:

```bash
kite component button
kite component button card avatar
kite widget button card avatar
kite g widget button card avatar
```

Generated structure:

```text
lib/shared/components/
├── kite_component_size.dart
├── kite_button.dart
├── kite_card.dart
└── kite_avatar.dart
```

---

## Component dependencies

Components can depend on shared internal templates.

For example:

```text
component.button
component.card
component.avatar
        ↓
component.foundation
```

The shared foundation might generate:

```text
kite_component_size.dart
```

even when multiple components require it.

Kite resolves the dependency once and avoids generating duplicate files.

This keeps reusable components independent while still allowing them to share common infrastructure.

---

# Riverpod Infrastructure

Generate the production Riverpod foundation:

```bash
kite --state riverpod
```

Canonical command:

```bash
kite state riverpod
```

Generated structure:

```text
lib/core/state/
├── app_provider_observer.dart
├── async_notifier_guard.dart
└── riverpod_bootstrap.dart
```

The generated setup uses modern manually declared Riverpod APIs including:

```text
Provider
Notifier
NotifierProvider
AsyncNotifier
AsyncNotifierProvider
AsyncValue
```

Kite does **not** require:

```text
riverpod_generator
@riverpod
```

for state management.

This keeps generated state infrastructure explicit and easy to understand.

---

# Dio API Client

Generate Kite's Dio networking foundation:

```bash
kite --api:dio
```

Canonical forms:

```bash
kite api dio
```

or:

```bash
kite --api dio
```

Generated structure:

```text
lib/core/network/
├── api_config.dart
├── api_endpoints.dart
├── api_exception.dart
├── auth_token_store.dart
│
└── dio/
    ├── bearer_token_interceptor.dart
    ├── dio_api_client.dart
    ├── dio_exception_mapper.dart
    └── dio_providers.dart
```

The generated networking layer includes:

* Dio client configuration
* Typed decoding
* Bearer-token support
* API exception mapping
* Riverpod providers
* Request cancellation
* Upload/download progress callbacks
* Timeouts
* Debug-only HTTP logging
* Automatic client disposal

---

## Configure the API

Override the generated configuration during application bootstrap:

```dart
buildProviderScope(
  overrides: <Override>[
    apiConfigProvider.overrideWithValue(
      const ApiConfig(
        baseUrl: 'https://api.example.com',
      ),
    ),
  ],
  child: const App(),
);
```

Read the API client:

```dart
final client = ref.read(dioApiClientProvider);
```

Example typed request:

```dart
final profile = await client.get<ProfileDto>(
  path: '/profile',
  decoder: (data) {
    return ProfileDto.fromJson(
      Map<String, Object?>.from(
        data! as Map<Object?, Object?>,
      ),
    );
  },
);
```

---

# Template Dependency System

Kite templates can depend on other templates.

Example:

```json
{
  "id": "api.dio",
  "requires": [
    "api.core",
    "state.riverpod"
  ]
}
```

When you run:

```bash
kite --api:dio
```

Kite resolves:

```text
api.dio
├── api.core
└── state.riverpod
```

before generating the requested API template.

The dependency system:

* Resolves dependencies recursively
* Generates dependencies before the root template
* Detects circular dependencies
* Deduplicates identical generated targets
* Rejects conflicting generated targets
* Combines Dart/Flutter package dependencies
* Tracks generated files in the Kite manifest

---

# Safe File Generation

Kite is designed to avoid silently destroying application code.

Available conflict strategies include:

```bash
kite init --dry-run
kite init --skip-existing
kite init --force
```

When an existing file conflicts with generated output, Kite can:

```text
overwrite
overwrite all
skip
quit
```

Managed generated files are also recorded with checksums.

This allows Kite to determine whether a generated file has been manually modified before attempting future upgrades.

---

# Inspect Your Project

Run Kite's project diagnostics:

```bash
kite doctor
```

Use it to verify:

* Flutter project structure
* Kite configuration
* Managed manifest
* Template availability
* Generator environment

---

# Available Templates

List public templates:

```bash
kite templates
```

Show every registered template, including internal dependency templates:

```bash
kite templates --all
```

Example categories may include:

```text
project.clean

feature.clean
feature.mvc

component.button
component.card
component.avatar

state.riverpod

api.core
api.dio
```

---

# Upgrade Generated Foundations

Preview an upgrade:

```bash
kite upgrade --dry-run
```

Apply an upgrade:

```bash
kite upgrade
```

Kite uses its generated-file manifest and stored checksums to determine whether files can be safely replaced.

Developer-owned files can use a preservation policy.

For example:

```text
api_endpoints.dart
```

may be preserved because applications are expected to customize it.

---

# Kite Configuration

Kite can store project-specific generation settings inside:

```text
kite.yaml
```

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
      - name: blog
        path: /blog
      - name: profile
        path: /profile
  routes:
    - feature: details
      path: /blog/details
      segment: details
      branch: blog
      architecture: clean

serialization:
  type: json_serializable

generation:
  format_after_generation: true
  install_dependencies: true
  conflict_strategy: ask
```




### 6. Map the CLI command

Expose the template through an appropriate command or shorthand.

### 7. Validate

```bash
dart test
python3 tool/validate_templates.py
```

See `documentation.md` for the internal generator architecture and template authoring guide.

---

# CLI Reference

## Project

```bash
kite init
kite init --shell "[home,blog,profile]"
kite doctor
kite upgrade
```

## Features

```bash
kite --feat:clean dashboard
kite --feat:mvc dashboard

kite feature dashboard --architecture clean
kite feature dashboard --architecture mvc
```

## Feature options

```bash
--route
--into <branch>
--json
--dry-run
--force
--skip-existing
```

## Components

```bash
kite --widget button
kite --widget "[button,card,avatar]"

kite component button card avatar
```

## State

```bash
kite --state riverpod
kite state riverpod
```

## Networking

```bash
kite --api:dio
kite api dio
```

## Templates

```bash
kite templates
kite templates --all
```

## General

```bash
kite --version
kite --help
```

---


# Philosophy

Kite follows a few simple principles:

**Generate structure, not assumptions.**

Kite should not invent repository methods, API endpoints, business entities, or application behavior.

**Prefer explicit code.**

Generated code should remain readable and understandable without hidden generators or excessive abstractions.

**Keep architecture scalable.**

Small projects can use MVC while larger applications can use Feature-First Clean Architecture.

**Protect developer-owned code.**

Generation and upgrades should avoid overwriting manually modified files unexpectedly.

**Make common Flutter infrastructure repeatable.**

Architecture, routing, state management, networking, and shared components should be easy to establish consistently across projects.

---

# Contributing

Contributions, bug reports, new templates, and generator improvements are welcome.

Before submitting changes:

```bash
dart format .
dart analyze
dart test
python3 tool/validate_templates.py
```

When adding a new generator, include tests for:

* Argument normalization
* Template resolution
* Generated file structure
* Dependency resolution
* Conflict handling
* Generated imports

---

# License

Kite CLI is available under the **MIT License**.

Part of the **Orkitt developer tools ecosystem**.
