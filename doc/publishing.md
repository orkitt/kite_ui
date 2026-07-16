# Publishing checklist

Before publishing:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter pub publish --dry-run
```

Confirm:

- repository and issue tracker URLs are correct
- the package name is owned by your pub.dev account or verified publisher
- README examples match the released API
- example runs on web, Android, iOS, Windows, macOS, and Linux as applicable
- all public APIs have dartdoc comments
- changelog version equals `pubspec.yaml`
- the archive contains no secrets, generated build folders, or IDE metadata

## Existing package warning

The `kite` package name already has a published development version under the `orkitt.dev` publisher. Publishing this source as `0.1.0` is a breaking change from the previous CLI purpose. Publish it only from the owning publisher and communicate the package-purpose change clearly. Otherwise, rename the package while retaining the `Kite*` class names.
