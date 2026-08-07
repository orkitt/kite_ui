# Kite 0.2.0 — Technical Documentation

## 1. Purpose

Kite initializes Flutter project foundations and generates architecture, shared UI, state, and networking code from versioned templates.

Supported commands:

```bash
kite init
kite --feat:clean dashboard
kite --feat:mvc dashboard
kite --widget button
kite --widget "[button,card,avater]"
kite --state riverpod
kite --api:dio
```

Canonical equivalents:

```bash
kite feature dashboard --architecture clean
kite feature dashboard --architecture mvc
kite component button card avatar
kite state riverpod
kite api dio
```

## 2. Package architecture

```text
bin/kite.dart
lib/
├── kite.dart
└── src/
    ├── cli/
    ├── commands/
    ├── generation/
    ├── generators/
    ├── logging/
    ├── naming/
    ├── process/
    ├── project/
    └── templates/
```

Responsibilities:

- `cli`: top-level runner and shorthand normalization.
- `commands`: argument validation and project detection.
- `generators`: orchestration for projects, features, and presets.
- `generation`: plans, conflict resolution, checksums, and project manifests.
- `templates`: registry, manifests, dependency resolution, rendering, and template files.
- `process`: dependency installation and Dart formatting.

## 3. Command normalization

The CLI normalizes shorthand before passing arguments to `CommandRunner`:

```text
--feat:mvc dashboard       -> feature dashboard --architecture mvc
--widget button            -> component button
--state riverpod           -> state riverpod
--api:dio                  -> api dio
```

The feature shorthand is architecture-generic. Adding a registered `feature.mvvm` template and allowing `mvvm` in `FeatureCommand` enables `--feat:mvvm` without another parser branch.

## 4. Template registry

`lib/src/templates/registry.json` stores template metadata:

```json
{
  "id": "component.button",
  "name": "Kite Button",
  "type": "component",
  "version": "1.0.0",
  "manifest": "components/button/manifest.json"
}
```

Internal dependency templates use:

```json
{
  "id": "component.foundation",
  "internal": true
}
```

They are hidden from `kite templates` and shown by `kite templates --all`.

## 5. Manifest schema

A manifest controls files, dependencies, recursive template requirements, conditions, and upgrade behavior:

```json
{
  "schemaVersion": 2,
  "id": "component.button",
  "version": "1.0.0",
  "requires": ["component.foundation"],
  "dependencies": [],
  "devDependencies": [],
  "files": [
    {
      "template": "files/kite_button.dart.tmpl",
      "target": "{{config.sourceDirectory}}/shared/components/kite_button.dart",
      "upgradePolicy": "replace"
    }
  ]
}
```

### `requires`

`TemplateStore.resolve()` performs depth-first dependency resolution:

1. Detect circular dependencies.
2. Load dependencies first.
3. Deduplicate templates.
4. Return the root template last.

`TemplatePlanner.buildResolved()` then renders the complete dependency bundle, deduplicates identical targets, and fails if two templates produce different content for the same path.

## 6. Preset generator

`PresetGenerator` powers widgets, Riverpod, and Dio.

For multiple widget selections it:

1. Resolves every root template.
2. Builds one plan per root.
3. Merges files by target path.
4. Detects content conflicts before writing.
5. Writes all files transactionally.
6. Records each root template in `.kite/manifest.json`.
7. Merges and installs package dependencies once.
8. Formats the project once.

This is why selecting button, card, and avatar creates only one `kite_component_size.dart`.

## 7. MVC feature

`feature.mvc` requires `state.riverpod` and generates:

```text
features/<name>/
├── controllers/<name>_controller.dart
├── models/<name>_model.dart
├── providers/<name>_providers.dart
├── routes/<name>_routes.dart       # optional
└── views/
    ├── screens/<name>_screen.dart
    └── widgets/<name>_content.dart
```

The controller extends manual Riverpod `Notifier<Model>`. The provider is declared manually with `NotifierProvider`.

`--json` switches the model template to `json_annotation` / `json_serializable`. `--route` generates the route and registers the MVC path in Kite's route registry.

## 8. Component templates

### Foundation

`component.foundation` generates `kite_component_size.dart`. This is a genuinely reusable shared design token used across components.

### Button

`KiteButton` includes:

- filled, tonal, outlined, and text variants
- small, medium, and large sizes
- loading state
- leading and trailing widgets
- full-width mode
- tooltip and semantics
- theme-driven Material 3 styling

### Card

`KiteCard` includes consistent sizing, optional interaction, selection appearance, semantics, and theme-aware colors.

### Avatar

`KiteAvatar` supports remote images, loading feedback, image-error fallback, initials, custom children, interaction, semantics, and adaptive sizing.

## 9. Riverpod preset

`state.riverpod` generates:

- `AppProviderObserver` using Riverpod 3 observer context APIs
- `AsyncNotifierGuard<T>` for standardized loading/error/data mutations
- `buildProviderScope()` with debug observation, overrides, observers, and Riverpod retry behavior

No Riverpod annotations or generated providers are used.

## 10. Dio preset

`api.dio` requires `api.core` and `state.riverpod`.

### Framework-independent files

- `ApiConfig`
- `ApiException`
- `AuthTokenStore`
- developer-owned `ApiEndpoints`

### Dio files

- `BearerTokenInterceptor` extends `QueuedInterceptor`
- `mapDioException()` maps every Dio exception category
- `DioApiClient` supports typed decoding, query parameters, headers, payloads, cancellation, progress callbacks, GET/POST, and raw Dio access
- Riverpod providers expose config, token storage, interceptors, and the client

`apiConfigProvider` intentionally throws until overridden. This prevents shipping with an accidental placeholder base URL.

## 11. Generated-file safety

Kite creates `.kite/manifest.json` with:

- generation ID
- root template ID and version
- rendering variables
- generated file paths
- file checksums
- upgrade policies

Conflict resolution happens for the complete plan before any file is written.

Strategies:

```text
ask       default interactive behavior
skip      --skip-existing
overwrite --force
fail      programmatic/CI usage
```

Upgrade logic rebuilds the root template together with its current dependencies. Modified files are preserved unless `--force` is used.

## 12. Adding a component

Example: `badge`.

Create:

```text
lib/src/templates/components/badge/
├── manifest.json
└── files/kite_badge.dart.tmpl
```

Manifest:

```json
{
  "schemaVersion": 2,
  "id": "component.badge",
  "version": "1.0.0",
  "requires": ["component.foundation"],
  "dependencies": [],
  "devDependencies": [],
  "files": [
    {
      "template": "files/kite_badge.dart.tmpl",
      "target": "{{config.sourceDirectory}}/shared/components/kite_badge.dart",
      "upgradePolicy": "replace"
    }
  ]
}
```

Then:

1. Register `component.badge` in `registry.json`.
2. Add `badge` to `ComponentCommand._supported`.
3. Add generation tests.
4. Run `python3 tool/validate_templates.py`.

## 13. Adding another state or API preset

Use a root template ID such as `state.bloc` or `api.http`. Register it, create its manifest/files, and allow the preset in the associated command. Shared contracts should be placed in an internal template and referenced through `requires`.

## 14. Validation

Run:

```bash
dart format .
dart analyze
dart test
python3 tool/validate_templates.py
```

The static validator checks registry/manifest JSON, ID/version consistency, dependency existence, cycles, source files, conditions, token rendering, safe paths, bundle conflicts, and generated relative imports.
