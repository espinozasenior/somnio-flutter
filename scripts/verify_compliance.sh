#!/bin/bash
set -euo pipefail

echo "=== Somnio Compliance Verification ==="

echo "1. Bootstrap monorepo dependencies and generated sources..."
./scripts/ci_bootstrap.sh
echo "   PASS: Melos bootstrap and codegen completed"

echo "2. Critical anti-pattern checks..."
./scripts/verify_monorepo_compliance.sh --strict
echo "   PASS: Critical checks passed"

echo "3. Static analysis..."
flutter analyze --fatal-infos
echo "   PASS: Zero issues"

echo "4. Format check..."
dart format --output=none --set-exit-if-changed lib/ test/
echo "   PASS: Code formatted"

echo "5. Tests..."
flutter test
echo "   PASS: All tests pass"

echo ""
echo "=== ALL CHECKS PASSED ==="
