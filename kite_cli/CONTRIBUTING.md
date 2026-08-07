# Contributing

1. Create a focused branch.
2. Keep command parsing separate from generation logic.
3. Keep reusable source code in `.tmpl` files and metadata in JSON manifests.
4. Declare reusable template dependencies through `requires`; never duplicate dependency files in commands.
5. Add or update tests for every command, manifest, or template change.
6. Bump a template version whenever generated output changes.
7. Run `dart format .`, `dart analyze`, `dart test`, and `python3 tool/validate_templates.py`.
8. Do not add invented business operations to Clean Architecture placeholder contracts.
9. Keep Riverpod providers manual; do not introduce Riverpod code generation.
