#!/bin/bash
set -euo pipefail

MELOS_VERSION="${MELOS_VERSION:-6.3.3}"

dart pub global activate melos "$MELOS_VERSION"
export PATH="$HOME/.pub-cache/bin:$PATH"

flutter pub get
melos bootstrap
melos run codegen
