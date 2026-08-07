# Contributing

1. Create a focused branch.
2. Add or update tests for behavior changes.
3. Run `dart format .`.
4. Run `flutter analyze`.
5. Run `flutter test`.
6. Update the changelog for user-visible changes.

Kite avoids feature-domain dependencies, code generation, and mandatory state-management packages. New APIs should solve reusable layout, shell, navigation, or routing problems.
