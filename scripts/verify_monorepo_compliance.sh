#!/bin/bash
set -euo pipefail

WORKSPACE_DIR="$(pwd)"
STRICT_MODE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict)
      STRICT_MODE=true
      shift
      ;;
    --workspace)
      WORKSPACE_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: $0 [--strict] [--workspace <path>]"
      exit 1
      ;;
  esac
done

if [[ ! -d "$WORKSPACE_DIR" ]]; then
  echo "ERROR: Workspace does not exist: $WORKSPACE_DIR"
  exit 1
fi

cd "$WORKSPACE_DIR"

echo "=== Monorepo Compliance Verification ==="
if [[ "$STRICT_MODE" == true ]]; then
  echo "Mode: strict (critical checks fail CI)"
else
  echo "Mode: advisory (critical checks warn only)"
fi

critical_failures=0
advisory_warnings=0
SOURCE_ROOTS_VALID=true

echo ""
echo "[CRITICAL] Tooling availability"
if command -v rg >/dev/null 2>&1; then
  RG_AVAILABLE=true
  echo "PASS: rg is available"
else
  RG_AVAILABLE=false
  echo "FAIL: rg is required but not available in PATH"
  critical_failures=$((critical_failures + 1))
fi

echo ""
echo "[CRITICAL] Melos workspace config exists"
if [[ -f melos.yaml ]]; then
  echo "PASS: Found melos workspace file"
else
  echo "FAIL: melos.yaml is missing"
  critical_failures=$((critical_failures + 1))
fi

echo ""
echo "[CRITICAL] Expected source roots exist"
if [[ -d lib && -d packages ]]; then
  echo "PASS: Found lib/ and packages/ roots"
else
  echo "FAIL: Expected lib/ and packages/ directories in workspace root"
  critical_failures=$((critical_failures + 1))
  SOURCE_ROOTS_VALID=false
fi

echo ""
echo "[CRITICAL] No Flutter SDK imports in domain layer"
if [[ "$RG_AVAILABLE" == true && "$SOURCE_ROOTS_VALID" == true ]]; then
  if rg --no-heading --line-number 'package:flutter' lib/features --glob '*/domain/**/*.dart'; then
    echo "FAIL: Domain layer contains Flutter imports"
    critical_failures=$((critical_failures + 1))
  else
    echo "PASS: Domain layer remains pure Dart"
  fi
else
  echo "FAIL: Check skipped because prerequisites are unavailable"
  critical_failures=$((critical_failures + 1))
fi

echo ""
echo "[CRITICAL] No hardcoded credentials in source files"
if [[ "$RG_AVAILABLE" == true && "$SOURCE_ROOTS_VALID" == true ]]; then
  if rg --no-heading --line-number -i '(api[_-]?key|client[_-]?secret|private[_-]?key)\s*[:=]\s*["\x27][^"\x27]+["\x27]' lib packages --glob '*.dart'; then
    echo "FAIL: Potential hardcoded credentials found"
    critical_failures=$((critical_failures + 1))
  else
    echo "PASS: No API keys or secrets hardcoded in code"
  fi
else
  echo "FAIL: Check skipped because prerequisites are unavailable"
  critical_failures=$((critical_failures + 1))
fi

echo ""
echo "[CRITICAL] Generated files exist for all part directives"
if [[ "$RG_AVAILABLE" == true && "$SOURCE_ROOTS_VALID" == true ]]; then
  part_lines="$(rg --no-heading --line-number "part '\\S+\\.g\\.dart';" lib packages --glob '*.dart' || true)"
  missing_parts=0
  if [[ -n "$part_lines" ]]; then
    while IFS= read -r line; do
      file_path="$(echo "$line" | awk -F: '{print $1}')"
      part_file="$(echo "$line" | sed -E "s/.*part '([^']+)';.*/\\1/")"
      generated_path="$(dirname "$file_path")/$part_file"
      if [[ ! -f "$generated_path" ]]; then
        echo "Missing generated file: $generated_path (from $file_path)"
        missing_parts=$((missing_parts + 1))
      fi
    done <<< "$part_lines"
  fi

  if [[ "$missing_parts" -eq 0 ]]; then
    echo "PASS: All referenced *.g.dart files exist"
  else
    echo "FAIL: Missing $missing_parts generated files"
    critical_failures=$((critical_failures + 1))
  fi
else
  echo "FAIL: Check skipped because prerequisites are unavailable"
  critical_failures=$((critical_failures + 1))
fi

echo ""
echo "[ADVISORY] Avoid print in production code"
if [[ "$RG_AVAILABLE" == true && "$SOURCE_ROOTS_VALID" == true ]]; then
  if rg --no-heading --line-number '\bprint\s*\(' lib packages --glob '*.dart'; then
    echo "WARN: Prefer structured logging over print"
    advisory_warnings=$((advisory_warnings + 1))
  else
    echo "PASS: Prefer structured logging over print"
  fi
else
  echo "WARN: Check skipped because prerequisites are unavailable"
  advisory_warnings=$((advisory_warnings + 1))
fi

echo ""
echo "[ADVISORY] Track pending TODO/FIXME debt"
if [[ "$RG_AVAILABLE" == true && "$SOURCE_ROOTS_VALID" == true ]]; then
  if rg --no-heading --line-number '(TODO|FIXME)' lib packages --glob '*.dart'; then
    echo "WARN: TODO/FIXME markers found in source code"
    advisory_warnings=$((advisory_warnings + 1))
  else
    echo "PASS: No TODO/FIXME markers found in source code"
  fi
else
  echo "WARN: Check skipped because prerequisites are unavailable"
  advisory_warnings=$((advisory_warnings + 1))
fi

echo ""
echo "=== Compliance Summary ==="
echo "Critical failures: $critical_failures"
echo "Advisory warnings: $advisory_warnings"

if [[ "$STRICT_MODE" == true && "$critical_failures" -gt 0 ]]; then
  echo "Result: FAILED (strict mode)"
  exit 1
fi

echo "Result: PASSED"
