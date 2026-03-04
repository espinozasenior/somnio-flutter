# Somnio Flutter - Project Technical Brief

**Prepared for**: Project Manager & Client Stakeholders
**Date**: March 3, 2026
**Repository**: `espinozasenior/somnio-flutter`
**Status**: Architecture & Specification Complete - Ready for Implementation

---

## 1. Executive Summary

Somnio is a production-grade Flutter mobile application template built on top of the industry-standard Very Good Ventures (VGV) scaffold. It replaces the default Material Design system with Apple's Cupertino design language, delivering an iOS-native user experience across all platforms (iOS, Android, Web).

The project is structured as an 11-phase build plan. Each phase has a detailed specification document with requirements, pseudocode, test definitions, and acceptance criteria. The architecture follows Clean Architecture with four strict layers, dependency injection, and 100% test coverage enforcement.

**Key differentiators over stock VGV template:**
- Full Cupertino design system (no Material widgets)
- 4-layer Clean Architecture (Presentation, Application, Domain, Data)
- Stricter lint rules via `solid_lints`
- Offline-first data strategy with automatic cache fallback
- Typed error handling pipeline with retry support
- GoRouter with iOS-native page transitions and auth guards
- CI/CD pipeline with 100% coverage gate and multi-platform builds

---

## 2. Technology Stack

### Core Framework
| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | Flutter | >= 3.24.0 (stable) |
| Language | Dart | >= 3.5.0 |
| Design System | Cupertino (iOS-native) | Built-in |

### State & Routing
| Package | Purpose |
|---------|---------|
| `flutter_bloc` / `bloc` | State management via Cubit pattern |
| `go_router` | Declarative routing with deep linking |
| `equatable` | Value equality for entities and states |

### Dependency Injection & Codegen
| Package | Purpose |
|---------|---------|
| `get_it` + `injectable` | Service locator with annotation-driven codegen |
| `freezed` + `freezed_annotation` | Immutable data classes and union types |
| `json_serializable` + `json_annotation` | JSON serialization codegen |
| `retrofit` + `retrofit_generator` | Type-safe HTTP client codegen |

### Networking & Storage
| Package | Purpose |
|---------|---------|
| `dio` | HTTP client with interceptors |
| `hive_flutter` | High-performance local key-value storage |
| `flutter_secure_storage` | Encrypted credential storage |
| `shared_preferences` | Lightweight preferences |
| `connectivity_plus` | Network state detection |

### Quality & Testing
| Package | Purpose |
|---------|---------|
| `solid_lints` | Strict Dart/Flutter lint rules |
| `custom_lint` | Project-specific lint rules |
| `mocktail` | Mock-first unit testing |
| `bloc_test` | Cubit/Bloc state testing |

### Utilities
| Package | Purpose |
|---------|---------|
| `dartz` | Functional `Either<Failure, T>` error handling |
| `logger` | Structured logging |
| `intl` | Internationalization |
| `cached_network_image` | Image caching |
| `shimmer` | Loading skeleton placeholders |

**Total: 20 production + 10 development dependencies**

---

## 3. Architecture Overview

### 3.1 Four-Layer Clean Architecture

```
+-------------------------------------------------------------+
|  PRESENTATION                                                |
|  Cupertino widgets, Cubits/Blocs, Pages, UI components       |
|  Depends on: Application, Domain                             |
+-------------------------------------------------------------+
|  APPLICATION                                                 |
|  Use Cases, DTOs, Mappers                                    |
|  Depends on: Domain only                                     |
+-------------------------------------------------------------+
|  DOMAIN                                                      |
|  Entities, Repository interfaces, Value objects               |
|  Depends on: Nothing (pure Dart, no Flutter imports)          |
+-------------------------------------------------------------+
|  DATA                                                        |
|  Repository implementations, API clients, Local storage       |
|  Depends on: Domain (implements interfaces)                  |
+-------------------------------------------------------------+
```

**Strict dependency rules enforced by automated grep scans:**
- Domain layer contains zero Flutter imports
- Domain never references the Data layer
- Core module never references feature modules
- All verified by CI and compliance scripts

### 3.2 Feature Module Structure

Every feature follows the same 4-layer directory pattern:

```
lib/features/<feature>/
  domain/
    entities/           # Pure Dart value objects
    repositories/       # Abstract interfaces
    usecases/           # Single-responsibility use cases
  data/
    models/             # Freezed data models + JSON
    repositories/       # Interface implementations
    datasources/
      remote/           # Retrofit API clients
      local/            # Hive cache sources
  presentation/
    cubit/              # State management
    pages/              # Full-screen Cupertino pages
    widgets/            # Reusable UI components
```

### 3.3 Error Handling Pipeline

```
API/Cache throws Exception
        |
        v
Repository catches -> returns Either<Failure, T>
        |
        v
Use Case passes Either through unchanged
        |
        v
Cubit emits typed error state
        |
        v
Page renders CupertinoErrorView with retry button
```

Four failure types: `ServerFailure`, `CacheFailure`, `NetworkFailure`, `ValidationFailure`

### 3.4 Routing Architecture

- GoRouter with `CupertinoPage` transitions (iOS slide animation)
- `CupertinoTabScaffold` shell route for bottom tab navigation (3 tabs)
- Authentication guard with automatic redirect
- Deep linking support for all parameterized routes

**Route tree:**
```
/                    Splash
/login               Authentication
/home/feed           Tab 0: Feed list
/home/feed/:id       Feed item detail
/home/search         Tab 1: Search
/home/profile        Tab 2: Profile
/settings            Settings
/settings/theme      Theme configuration
```

---

## 4. Cupertino Design System

The entire UI is built with Apple's Cupertino widget set. Zero Material widgets exist in the production codebase.

| UI Element | Widget Used |
|-----------|-------------|
| App shell | `CupertinoApp.router` |
| Theming | `CupertinoThemeData` (light + dark) |
| Page layout | `CupertinoPageScaffold` |
| Navigation bar | `CupertinoNavigationBar` |
| Buttons | `CupertinoButton` / `CupertinoButton.filled` |
| Text input | `CupertinoTextField` |
| Dialogs | `CupertinoAlertDialog` |
| Bottom tabs | `CupertinoTabBar` + `CupertinoTabScaffold` |
| Loading | `CupertinoActivityIndicator` |
| Toggles | `CupertinoSwitch` |
| Icons | `CupertinoIcons` |
| List items | `CupertinoListTile` |

**Typography**: SF Pro Text via system font defaults
**Theme switching**: `ThemeCubit` manages `Brightness.light` / `Brightness.dark`

---

## 5. Implementation Phases

| # | Phase | Files Created | Files Modified | TDD Tests | Status |
|---|-------|:------------:|:--------------:|:---------:|--------|
| 01 | Generate VGV base project | 9 | 0 | 5 | Spec complete |
| 02 | Cupertino design system conversion | 4 | 5 | 9 | Spec complete |
| 03 | SOLID lints configuration | 0 | 4 | 7 | Spec complete |
| 04 | Core dependencies | 0 | 1 | 7 | Spec complete |
| 05 | 4-layer architecture scaffolding | 11 | 2 | 9 | Spec complete |
| 06 | Error handling strategy | 10 | 1 | 12 | Spec complete |
| 07 | Routing with GoRouter | 6 | 1 | 9 | Spec complete |
| 08 | Example feature (Posts) | 16+ | 1 | 17 | Spec complete |
| 09 | Testing infrastructure | 9+ | 0 | 9 | Spec complete |
| 10 | CI/CD pipeline | 3 | 0 | 11 | Spec complete |
| 11 | Rules compliance & verification | 2 | 0 | 13 | Spec complete |
| | **TOTALS** | **~70+** | **~15** | **93** | |

### Phase Dependency Chain

```
Phase 01 (Base)
    |
    v
Phase 02 (Cupertino) ---> Phase 03 (Lints) ---> Phase 04 (Deps)
                                                       |
                                                       v
                           Phase 05 (Architecture) <---+
                                |
                    +-----------+-----------+
                    |                       |
                    v                       v
            Phase 06 (Errors)       Phase 07 (Routing)
                    |                       |
                    +-----------+-----------+
                                |
                                v
                    Phase 08 (Posts Feature)
                                |
                                v
                    Phase 09 (Testing)
                                |
                                v
                    Phase 10 (CI/CD)
                                |
                                v
                    Phase 11 (Compliance)
```

---

## 6. Quality Gates

### 6.1 Static Analysis
- `flutter analyze --fatal-infos` must report zero issues
- `dart run custom_lint` must report zero issues
- `dart format --set-exit-if-changed` must pass

### 6.2 Test Coverage
- **Target: 100%** line coverage on hand-written code
- Generated files excluded: `*.g.dart`, `*.freezed.dart`, `*.gen.dart`, `injection.config.dart`
- Localization files excluded: `lib/l10n/*`
- Coverage enforced by CI pipeline with hard failure on any drop

### 6.3 Cupertino Compliance
Automated grep-based scans ensure zero Material widgets leak into `lib/`:
- No `material.dart` imports
- No `MaterialApp`, `Scaffold`, `AppBar`, `FloatingActionButton`
- No `ElevatedButton`, `CircularProgressIndicator`, `Icons.`
- No `AlertDialog`, `TextField`, `Switch` (Material variants)

### 6.4 Architecture Compliance
- Domain layer contains no Flutter or Data layer imports
- Core module contains no feature-level imports
- All verified by `scripts/verify_compliance.sh`

---

## 7. CI/CD Pipeline

GitHub Actions workflow triggered on push/PR to `main` and `develop`:

```
[Push / PR]
    |
    v
[Analyze & Lint]          # flutter analyze, custom_lint, dart format
    |
    v
[Test & Coverage]         # flutter test --coverage, 100% gate
    |
    +--------+--------+
    |        |        |
    v        v        v
[Android] [iOS]    [Web]  # Parallel build artifacts
```

**Build targets:**
- Android: Release APK split by ABI (arm64, x86_64, armeabi)
- iOS: Release build, unsigned (for CI validation)
- Web: Release build

**Automated dependency management:** Dependabot configured for weekly Pub and GitHub Actions updates.

---

## 8. Example Feature: Posts

A complete reference implementation demonstrating all architecture layers:

**Functionality:**
- Fetch posts from REST API (JSONPlaceholder)
- Display in Cupertino list with iOS-native styling
- Tap to view detail page
- Pull-to-refresh
- Automatic offline cache fallback via Hive
- Error display with retry button

**Layers implemented:**
- **Domain**: `PostEntity`, `PostRepository` interface, `GetPosts` / `GetPostById` use cases
- **Data**: `PostModel` (Freezed), `PostRemoteDataSource` (Retrofit), `PostLocalDataSource` (Hive), `PostRepositoryImpl` with online/offline strategy
- **Presentation**: `PostsCubit` + `PostsState` (Freezed union), `PostsPage`, `PostDetailPage`, `PostListTile`

**Test coverage:** 17 TDD anchors covering entity equality, JSON parsing, repository caching logic, cubit state emissions, and widget rendering.

---

## 9. Testing Strategy

**Methodology:** London School TDD (mock-first, outside-in)

| Layer | Test Type | Tooling | Pattern |
|-------|-----------|---------|---------|
| Domain | Unit | `mocktail` | Mock repository, verify use case calls |
| Data | Unit | `mocktail` | Mock data sources, verify cache behavior |
| Presentation (Cubit) | Unit | `bloc_test` | Verify state emission sequences |
| Presentation (Widget) | Widget | `flutter_test` | `pumpCupertinoApp` helper with mock cubits |
| Full App | Integration | `integration_test` | Smoke test: app renders `CupertinoApp` |

**Test infrastructure:**
- `test/helpers/pump_app.dart` - Cupertino widget test wrapper
- `test/helpers/mock_factories.dart` - Centralized mock registry
- `test/helpers/test_fixtures.dart` - Reusable test data factories
- `test/fixtures/posts.json` - JSON fixture files
- `scripts/check_coverage.sh` - Coverage threshold enforcement

---

## 10. Specification Artifacts

All detailed spec-pseudocode documents are located in `docs/spec/`:

| File | Lines | Description |
|------|:-----:|-------------|
| `phase_01_generate_base.md` | 111 | VGV scaffold generation and baseline verification |
| `phase_02_cupertino_design_system.md` | 210 | Complete Material-to-Cupertino conversion map |
| `phase_03_solid_lints.md` | 150 | Lint configuration with 20+ strict rules |
| `phase_04_dependencies.md` | 194 | Full dependency manifest with 30 packages |
| `phase_05_4layer_architecture.md` | 254 | Architecture layers, DI, base classes |
| `phase_06_error_handling.md` | 267 | Error pipeline, Dio interceptor, Cupertino error UI |
| `phase_07_routing.md` | 259 | GoRouter with Cupertino transitions and auth guards |
| `phase_08_example_feature.md` | 394 | Full Posts feature across all 4 layers |
| `phase_09_testing.md` | 324 | Testing infra, mocks, fixtures, 100% coverage |
| `phase_10_ci_cd.md` | 262 | GitHub Actions CI pipeline, multi-platform builds |
| `phase_11_rules_compliance.md` | 320 | Compliance verification and final push |
| **Total** | **2,745** | |

Each document contains:
- Numbered requirements
- Pseudocode with flow diagrams
- TDD anchor definitions (93 total)
- Files-to-create and files-to-modify tables
- Exit criteria checklists

---

## 11. Verification Checklist

Upon completion of all 11 phases, the following must pass:

- [ ] `flutter pub get` resolves all dependencies
- [ ] `dart run build_runner build` generates all codegen files
- [ ] `flutter analyze --fatal-infos` reports zero issues
- [ ] `dart run custom_lint` reports zero issues
- [ ] `dart format --set-exit-if-changed lib/ test/` passes
- [ ] `flutter test --coverage` passes with 100% coverage
- [ ] Zero `material.dart` imports in `lib/`
- [ ] Zero Flutter imports in domain layer
- [ ] Zero cross-layer violations
- [ ] DI graph resolves all singletons
- [ ] App renders with iOS-native Cupertino look on all platforms
- [ ] CI pipeline runs green on GitHub Actions
- [ ] Code pushed to `espinozasenior/somnio-flutter`

---

## 12. Risk Considerations

| Risk | Mitigation |
|------|-----------|
| Cupertino widgets missing some Material equivalents (e.g. complex tables, chips) | Use `CupertinoListSection` and custom widgets; document any gaps |
| Freezed/Retrofit codegen conflicts | Pin exact versions; run codegen with `--delete-conflicting-outputs` |
| 100% coverage difficult to maintain | Coverage helper imports all lib files; exclude only generated code |
| GoRouter + CupertinoTabScaffold integration complexity | Use `StatefulShellRoute.indexedStack` pattern (documented in Phase 07) |
| Hive offline cache stale data | Implement TTL-based invalidation in future enhancement |

---

## 13. Next Steps

1. **Install Flutter SDK** (>= 3.24.0 stable) on development machine
2. **Execute Phase 01** to generate VGV base scaffold
3. **Proceed sequentially** through Phases 02-11
4. **Run verification checklist** (Section 11) after Phase 11
5. **Push to GitHub** and confirm CI pipeline runs green
