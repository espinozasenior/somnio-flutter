#!/bin/bash
set -e

echo "=== Somnio Compliance Verification ==="

echo "1. Cupertino compliance..."
if grep -r "package:flutter/material.dart" lib/ 2>/dev/null; then
    echo "FAIL: Material imports found"
    exit 1
fi
echo "   PASS: No Material imports"

echo "2. Architecture compliance..."
if grep -r "package:flutter" lib/features/*/domain/ 2>/dev/null; then
    echo "FAIL: Flutter imports in domain layer"
    exit 1
fi
echo "   PASS: Domain is pure Dart"

echo "3. Dependency resolution..."
flutter pub get
echo "   PASS: Dependencies resolved"

echo "4. Code generation..."
dart run build_runner build --delete-conflicting-outputs
echo "   PASS: Codegen complete"

echo "5. Static analysis..."
flutter analyze --fatal-infos
echo "   PASS: Zero issues"

echo "6. Format check..."
dart format --set-exit-if-changed lib/ test/
echo "   PASS: Code formatted"

echo "7. Tests..."
flutter test
echo "   PASS: All tests pass"

echo ""
echo "=== ALL CHECKS PASSED ==="
