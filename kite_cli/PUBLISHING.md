# Publishing Kite

Run the complete release check from the package root:

```bash
dart pub get
dart format --set-exit-if-changed .
dart analyze
dart test
python3 tool/validate_templates.py
dart pub publish --dry-run
```

Verify the CLI locally:

```bash
dart pub global activate --source path .
kite --version
kite templates
```

Smoke-test inside a disposable Flutter project:

```bash
flutter create kite_smoke
cd kite_smoke
kite init
kite --feat:clean dashboard --route
kite --feat:mvc profile --route
kite --widget "[button,card,avatar]"
kite --state riverpod
kite --api:dio
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

Publish:

```bash
dart pub publish
```
