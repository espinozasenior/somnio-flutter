#!/bin/bash
set -e

echo "=== Somnio Coverage Check ==="

echo "Running tests with coverage..."
flutter test --coverage

echo "Filtering generated code from coverage..."
lcov --remove coverage/lcov.info \
    '*.g.dart' '*.freezed.dart' '*.gen.dart' \
    'lib/l10n/*' 'lib/core/di/injection.config.dart' \
    -o coverage/lcov_filtered.info

TOTAL=$(lcov --summary coverage/lcov_filtered.info 2>&1 | grep 'lines' | awk -F'[%]' '{print $1}' | awk '{print $NF}')
echo "Coverage: ${TOTAL}%"

if (( $(echo "$TOTAL < 100.0" | bc -l) )); then
    echo "FAIL: Coverage below 100%"
    exit 1
fi

echo "PASS: Coverage at or above 100%"
