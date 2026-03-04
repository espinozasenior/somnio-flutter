# Somnio Flutter - Compliance Report

## Date: 2026-03-04

## Flutter Version: 3.41.x

### Cupertino Design System
- [x] Zero Material imports in lib/
- [x] CupertinoApp root widget (CupertinoApp.router)
- [x] CupertinoThemeData (light + dark)
- [x] CupertinoPageScaffold for all pages
- [x] CupertinoNavigationBar for navigation
- [x] CupertinoButton for all buttons
- [x] CupertinoIcons throughout
- [x] CupertinoActivityIndicator for loading
- [x] CupertinoTabBar for bottom navigation

### Architecture
- [x] 4-layer clean architecture (Presentation -> BLoC -> Repository -> Data)
- [x] Domain layer is pure Dart (no Flutter imports)
- [x] No cross-layer violations
- [x] DI via GetIt with constructor injection
- [x] GoRouter with Cupertino page transitions
- [x] StatefulShellRoute with CupertinoTabBar

### Code Quality
- [x] very_good_analysis: strict lint rules (188 rules, 86.2% coverage)
- [x] dart:developer log() for structured logging
- [x] Equatable + @JsonSerializable for models
- [x] Freezed sealed classes for state management
- [x] dartz Either<Failure, T> for error handling

### Testing
- [x] TDD London School (fakes/stubs for use cases, mocks where verify needed)
- [x] Private mocks (_MockClassName) per test file
- [x] $Type string interpolation in test names
- [x] setUp inside group() blocks
- [x] buildCubit() helpers + returnsNormally tests
- [x] Separate state test files

### CI/CD
- [x] GitHub Actions CI configured
- [x] Dependabot configured
- [x] Pull request template

### Lint Decision
very_good_analysis (v10.2.0) retained over solid_lints (v0.3.3) based on:
- 13x more popular (745 vs 57 likes)
- Stricter rules (188 vs uncharted, 86.2% coverage)
- Enables strict-inference and strict-raw-types
- Maintained by Very Good Ventures (major Flutter consultancy)
