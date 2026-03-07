# Somnio Flutter Monorepo

This project uses a Melos-based monorepo strategy to keep code generation and CI reliable as the codebase grows.

## How It Works

- The workspace is managed with `melos`.
- Code generation is centralized in `melos.yaml` under the `codegen` script.
- CI runs:
  - `melos bootstrap`
  - `melos run codegen`
  - `flutter analyze --fatal-infos`

This prevents analyzer failures caused by missing generated files (`*.g.dart`) in package-based code.

## Guardrails Policy

### Critical checks (CI blocking)

Critical checks run in CI through `./scripts/verify_monorepo_compliance.sh --strict` and fail the pipeline when violated:

- Flutter imports inside domain layer (`lib/features/*/domain/**`)
- hardcoded secrets/credentials in source files
- missing generated files referenced by `part '*.g.dart'`

### Advisory checks (local warning)

Advisory checks run with `./scripts/verify_monorepo_compliance.sh` and report warnings without failing:

- `print()` usage in app/package sources
- unresolved `TODO` / `FIXME` markers in source code

## Local Developer Flow

From the repository root:

```bash
flutter pub get
dart pub global activate melos 6.3.3
export PATH="$PATH:$HOME/.pub-cache/bin"
melos bootstrap
melos run codegen
flutter analyze --fatal-infos
```

To run guardrails locally:

```bash
./scripts/verify_monorepo_compliance.sh
```

## Monorepo Scaling Guide

When adding a new feature/package:

1. Add the package under `packages/`.
2. If the package needs code generation, add `build_runner` (and related generators) in that package `pubspec.yaml`.
3. Run `melos bootstrap` and `melos run codegen`.
4. Verify with `flutter analyze --fatal-infos`.

No CI workflow path updates are required for each new codegen package, because Melos discovers packages from workspace metadata.

## Contributor Onboarding Checklist

For every new package or major feature, complete this checklist:

1. Place reusable package code under `packages/<package_name>/`.
2. Add/update package `pubspec.yaml` dependencies.
3. If codegen is needed, add generator dependencies (including `build_runner`) in that package.
4. Run:
   - `melos bootstrap`
   - `melos run codegen`
   - `./scripts/verify_monorepo_compliance.sh`
   - `flutter analyze --fatal-infos`
5. Confirm package guardrail compatibility before opening PR.

## Useful Checks

- List packages that require code generation:

```bash
melos list --depends-on=build_runner
```

- Run codegen for all relevant packages:

```bash
melos run codegen
```

## CI Troubleshooting

- **Error:** `Target of URI hasn't been generated` or missing `*.g.dart`
  - **Cause:** codegen did not run for all required packages.
  - **Fix:** run `melos bootstrap` then `melos run codegen` before analyze/test.

- **Error:** `melos: command not found`
  - **Cause:** Melos is not installed or not available on `PATH`.
  - **Fix:** install with `dart pub global activate melos 6.3.3` and add `$HOME/.pub-cache/bin` to `PATH`.

- **Error:** new package with generators still fails in CI
  - **Cause:** missing `build_runner`/generator deps in that package `pubspec.yaml`.
  - **Fix:** add required dev dependencies, run `melos bootstrap`, then rerun codegen.

- **Error:** local works but CI fails
  - **Cause:** stale local generated files can hide missing CI steps.
  - **Fix:** clean and validate with:
    - `melos bootstrap`
    - `melos run codegen`
    - `./scripts/verify_monorepo_compliance.sh --strict`
    - `flutter analyze --fatal-infos`
