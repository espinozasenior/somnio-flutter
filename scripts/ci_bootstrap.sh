#!/bin/bash
set -euo pipefail

MELOS_VERSION="${MELOS_VERSION:-6.3.3}"
MAX_RETRIES="${CI_RETRIES:-3}"

dart pub global activate melos "$MELOS_VERSION"
export PATH="$HOME/.pub-cache/bin:$PATH"

retry() {
  local attempt=1
  while [[ $attempt -le $MAX_RETRIES ]]; do
    if "$@"; then
      return 0
    fi
    echo "Attempt $attempt/$MAX_RETRIES failed. Retrying in $((attempt * 5))s..."
    sleep $((attempt * 5))
    attempt=$((attempt + 1))
  done
  echo "All $MAX_RETRIES attempts failed for: $*"
  return 1
}

retry flutter pub get
retry melos bootstrap
melos run codegen
