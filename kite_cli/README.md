# Kite 🪁

Kite is a professional Flutter scaffolding CLI for initializing maintainable app foundations and generating features, reusable components, state-management infrastructure, and API clients.

## Highlights

- Feature-first Clean Architecture and MVC generators
- Manual Riverpod `Notifier` / `AsyncNotifier` foundations without Riverpod code generation
- Production Dio client with typed decoding, bearer-token interception, exception mapping, cancellation, and Riverpod providers
- Reusable Material 3 components with light/dark theme support
- Versioned JSON manifests with readable `.tmpl` source files
- Recursive template dependencies through `requires`
- Transaction-style conflict handling, checksums, dry runs, formatting, dependency installation, and safe upgrades

## Installation

```bash
dart pub global activate kite
```

For local development:

```bash
git clone https://github.com/orkitt/kite.git
cd kite
dart pub get
dart pub global activate --source path .
```

## Initialize an existing Flutter project

```bash
cd your_flutter_app
kite init
```

This generates Material 3 themes, GoRouter configuration, shared loading/error/empty views, core errors/results, production Riverpod infrastructure, `kite.yaml`, and a managed `.kite/manifest.json`.

Useful options:

```bash
kite init --dry-run
kite init --force
kite init --skip-existing
kite init --no-dependencies
kite init --no-format
kite init --path ./apps/mobile
```

## Generate Clean Architecture

```bash
kite --feat:clean dashboard
```

Canonical form:

```bash
kite feature dashboard --architecture clean
```

Generated structure:

```text
lib/features/dashboard/
├── data/
│   ├── dtos/dashboard_dto.dart
│   ├── repositories/dashboard_repository_impl.dart
│   └── sources/dashboard_remote_source.dart
├── domain/
│   ├── entities/dashboard_entity.dart
│   ├── repositories/dashboard_repository.dart
│   └── usecases/get_dashboard_use_case.dart
└── presentation/
    ├── providers/dashboard_providers.dart
    ├── screens/dashboard_screen.dart
    └── widgets/dashboard_content.dart
```

The generated source and repository contracts remain intentionally empty. Kite does not invent API operations or business methods.

## Generate MVC

```bash
kite --feat:mvc dashboard
```

Canonical form:

```bash
kite feature dashboard --architecture mvc
kite feature dashboard --mvc
```

Generated structure:

```text
lib/features/dashboard/
├── controllers/dashboard_controller.dart
├── models/dashboard_model.dart
├── providers/dashboard_providers.dart
└── views/
    ├── screens/dashboard_screen.dart
    └── widgets/dashboard_content.dart
```

Add and register a GoRouter route:

```bash
kite --feat:mvc dashboard --route
```

Generate a JSON-serializable model or DTO:

```bash
kite --feat:mvc dashboard --json
kite --feat:clean dashboard --json
```

Kite installs `json_annotation`, `build_runner`, and `json_serializable`. Run `dart run build_runner build` after adding real fields.

## Generate reusable widgets

Single component:

```bash
kite --widget button
```

Multiple components:

```bash
kite --widget "[button,card,avater]"
```

`avater` is accepted as an alias for `avatar`.

Canonical forms:

```bash
kite component button
kite component button card avatar
kite widget button card avatar
kite g widget button card avatar
```

Generated output:

```text
lib/shared/components/
├── kite_component_size.dart
├── kite_button.dart
├── kite_card.dart
└── kite_avatar.dart
```

Every component declares its dependencies in its JSON manifest. Button, card, and avatar all require `component.foundation`, so the shared size file is generated once even when multiple components are selected.

## Add Riverpod production infrastructure

```bash
kite --state riverpod
```

Canonical form:

```bash
kite state riverpod
```

Generated output:

```text
lib/core/state/
├── app_provider_observer.dart
├── async_notifier_guard.dart
└── riverpod_bootstrap.dart
```

The generated code uses manual providers and modern `Notifier` / `AsyncNotifier` APIs. It does not add `riverpod_generator`.

## Add a Dio API client

```bash
kite --api:dio
```

Canonical forms:

```bash
kite api dio
kite --api dio
```

Generated output:

```text
lib/core/network/
├── api_config.dart
├── api_endpoints.dart
├── api_exception.dart
├── auth_token_store.dart
└── dio/
    ├── bearer_token_interceptor.dart
    ├── dio_api_client.dart
    ├── dio_exception_mapper.dart
    └── dio_providers.dart
```

`api.dio` requires both `api.core` and `state.riverpod`, so all required contracts, Riverpod files, `dio`, and `flutter_riverpod` are added automatically.

Override the generated config provider at bootstrap:

```dart
buildProviderScope(
  overrides: <Override>[
    apiConfigProvider.overrideWithValue(
      const ApiConfig(baseUrl: 'https://api.example.com'),
    ),
  ],
  child: const App(),
);
```

Then read the client:

```dart
final client = ref.read(dioApiClientProvider);
final profile = await client.get<ProfileDto>(
  path: '/profile',
  decoder: (data) => ProfileDto.fromJson(
    Map<String, Object?>.from(data! as Map<Object?, Object?>),
  ),
);
```

## Template dependencies

A template may depend on other templates:

```json
{
  "id": "api.dio",
  "requires": ["api.core", "state.riverpod"]
}
```

Kite resolves dependencies recursively in dependency-first order, detects circular dependencies, deduplicates identical target files, rejects conflicting targets, merges package dependencies, and records the root template for future upgrades.

## Inspect and upgrade

```bash
kite doctor
kite templates
kite templates --all
kite upgrade --dry-run
kite upgrade
```

Internal dependency templates are hidden from the default `kite templates` output and shown with `--all`.

During upgrade, Kite replaces a managed file only when its checksum shows it was not manually modified. Files marked `preserve`, such as `api_endpoints.dart`, remain developer-owned.

## Add another template

1. Create a folder under `lib/src/templates/`.
2. Add `manifest.json` and readable `.tmpl` files.
3. Register the template in `registry.json`.
4. Add dependencies using `requires` when necessary.
5. Add or extend a command mapping.
6. Run template validation and tests.

See [`documentation.md`](documentation.md) for the complete internal architecture and extension guide.

## Development

```bash
dart pub get
dart format .
dart analyze
dart test
python3 tool/validate_templates.py
dart pub publish --dry-run
```

## License

MIT License. Part of the Orkitt developer tools ecosystem.

## Documentation website

Kite includes a complete branded documentation website under `website/`.

```bash
cd website
npm run dev
```

Validate and build the static site:

```bash
npm test
```

The production output is written to `website/dist`. The included `.github/workflows/docs.yml` workflow deploys that output to GitHub Pages.
