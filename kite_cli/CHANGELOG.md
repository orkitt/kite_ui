## 0.4.0

* Added some `Action` `Listener` patterns.
* Improved `Functions` for pattern matching.
* Added some extensions and overall improvement

## 0.3.0

* Added `kite sync` to reconcile clean GoRouter infrastructure from `kite.yaml`.
* Added per-branch navigation visibility so shell branches can stay out of the navbar/rail.
* Moved generated GoRouter Dart bodies to reusable routing templates.
* Added clean-project constants, SharedPreferences providers, persisted theme mode, and `ThemeChanger`.


## 0.2.0

* Added central GoRouter generation under `lib/app/router/generated/`.
* Added `kite init --shell` with `StatefulShellRoute.indexedStack` branches.
* Added feature `--into <branch>` routing for Clean and MVC generators.
* Added typed routing topology in `kite.yaml` and managed `AppRoutes` constants.
* Added managed recursive-template dependency filtering to avoid repeated foundation conflicts.
* Added routing parser, generation, dry-run, idempotency, MVC, and migration tests.

## 0.1.0

* Fixed bundled template registry resolution after global installation.
* Improved CLI logging for clearer generation progress and error messages.
* Improved template loading reliability for `dart pub global activate kite_cli`.


## 0.0.1

- Added `kite init`.
- Added Clean Architecture feature generation.
- Added route and JSON serialization options.
- Added versioned JSON manifests and `.tmpl` source files.
- Added dry-run, conflict protection, checksums, and upgrades.
- Added `feature.mvc` and `kite --feat:mvc <name>`.
- Added reusable component generation through `--widget` / `component`.
- Added button, card, and avatar Material 3 templates.
- Added `--state riverpod` production Riverpod infrastructure.
- Added `--api:dio` typed Dio client infrastructure.
- Added recursive template dependencies with cycle and target-conflict detection.
- Added internal templates and `kite templates --all`.
- Added dependency-aware upgrade planning.
- Added expanded tests and multi-scenario static template validation.
