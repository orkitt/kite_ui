#!/usr/bin/env bash
set -euo pipefail

dart pub get
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
python3 tool/validate_templates.py
dart pub publish --dry-run
