#!/bin/bash
set -euo pipefail

echo "Running root code generation..."
dart run build_runner build --delete-conflicting-outputs

echo "Running auth_client code generation..."
(
  cd packages/auth_client
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs
)

echo "Code generation completed."
