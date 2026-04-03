# Somnio Flutter — Claude Code Configuration

Flutter/Dart monorepo for the Somnio mobile app. Uses Melos for workspace management, BLoC for state, clean architecture with data/domain/presentation layers, and Dio + Retrofit for networking.

## Project structure

```
lib/
  core/          — constants, DI, error types, network, routing, widgets
  features/
    auth/        — login, signup, social auth (data/domain/presentation)
    posts/       — post listing and detail (data/domain/presentation)
  l10n/          — localization
packages/
  app_ui/        — shared UI components and theme
  auth_client/   — Retrofit API client for NestJS auth backend
  form_inputs/   — form validation value objects (Email, Password, Name)
  token_provider/— secure token storage (flutter_secure_storage)
  user_repository/— auth state management and user session
```

## Behavioral Rules (Always Enforced)

- Do what has been asked; nothing more, nothing less
- NEVER create files unless they're absolutely necessary for achieving your goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files unless explicitly requested
- NEVER save working files, text/mds, or tests to the root folder
- Never continuously check status after spawning a swarm — wait for results
- ALWAYS read a file before editing it
- NEVER commit secrets, credentials, or .env files

## Architecture rules

- Clean architecture: domain layer has zero Flutter imports. CI enforces this.
- Each feature follows data/domain/presentation split.
- State management via BLoC/Cubit only. No setState, no ChangeNotifier.
- Dependency injection via GetIt in `lib/core/di/injection.dart`.
- All API clients use Retrofit code generation. Never construct raw HTTP requests.
- Error handling: use `Either<Failure, T>` from dartz. No throwing from repositories.
- Navigation: GoRouter with auth redirect guard in `app_router.dart`.
- Keep files under 500 lines.
- Ensure input validation at system boundaries.

## Code generation

Files ending in `.g.dart`, `.freezed.dart`, `.mocks.dart` are generated. Never edit them directly. Run `melos run codegen` after changing models, API clients, or freezed classes.

## Commands

```bash
flutter pub get                    # install deps
melos bootstrap                    # bootstrap monorepo
melos run codegen                  # run build_runner across all packages
flutter test                       # run all tests
flutter analyze --fatal-infos      # lint check
dart format lib/ test/             # format code
flutter run -d iPhone --flavor production --target lib/main_production.dart
```

- ALWAYS run `flutter test` and `flutter analyze --fatal-infos` after making code changes
- ALWAYS verify build succeeds before committing

## Testing

- Framework: `flutter_test` + `bloc_test` + `mocktail`
- Convention: test files mirror source structure under `test/`
- Mocks live in `test/helpers/mock_factories.dart`
- Fakes live in `test/helpers/fakes.dart`
- Fixtures live in `test/helpers/test_fixtures.dart`
- Every new feature needs corresponding tests. Every bug fix needs a regression test.
- Never commit code that breaks existing tests.

## Pre-work

- Before any structural refactor on a file over 300 lines, first remove dead code, unused imports, and debug logs. Commit cleanup separately.
- Break multi-file refactors into phases. Complete one phase, verify, then proceed. Each phase touches no more than 5 files.
- When asked to plan, output only the plan. No code until approved. If instructions are vague, outline what you'd build and where it goes. Get approval first.

## Code quality

- Write human-readable code. No robotic comment blocks or excessive section headers.
- Don't over-engineer. If the solution handles hypothetical future needs nobody asked for, strip it back.
- After writing code, run `flutter test` and `flutter analyze --fatal-infos` before reporting done. Never claim success without verification.
- Follow existing patterns. Study nearby code before building. The codebase is a better spec than a description.
- When given a bug report with error output, trace the actual error. Don't guess.

## Edit safety

- Re-read any file before editing it, especially after 10+ messages in conversation.
- After editing, read the file again to confirm the change applied correctly.
- When renaming functions, types, or variables, search for all references: direct calls, type references, string literals, re-exports, test mocks.
- Never fix a display problem by duplicating state. One source of truth.
- Never delete a file without verifying nothing references it.

## Failure recovery

- If a fix doesn't work after two attempts, stop. Re-read the entire relevant section. Figure out where the mental model was wrong and say so.
- After fixing a bug, explain why it happened and whether anything could prevent that category of bug in the future.
- When evaluating your own work, present what a perfectionist would criticize and what a pragmatist would accept. Let the user decide the tradeoff.

## Security notes

- Tokens stored in `flutter_secure_storage` (Keychain/EncryptedSharedPrefs). Never log tokens.
- `AppBlocObserver` is gated behind `kDebugMode`. Never register it in production.
- `badCertificate` TLS errors are rejected, not passed through.
- GitHub Actions are SHA-pinned. When adding new actions, always pin to full commit SHA.
- `pubspec.lock` is committed for reproducible builds. Do not add it back to `.gitignore`.
- NEVER hardcode API keys, secrets, or credentials in source files.
- NEVER commit .env files or any file containing secrets.
- Always validate user input at system boundaries.

## Concurrency: 1 MESSAGE = ALL RELATED OPERATIONS

- All operations MUST be concurrent/parallel in a single message
- Use Claude Code's Task tool for spawning agents, not just MCP
- ALWAYS batch ALL todos in ONE TodoWrite call (5-10+ minimum)
- ALWAYS spawn ALL agents in ONE message with full instructions via Task tool
- ALWAYS batch ALL file reads/writes/edits in ONE message
- ALWAYS batch ALL Bash commands in ONE message

## Swarm Orchestration

- MUST initialize the swarm using CLI tools when starting complex tasks
- MUST spawn concurrent agents using Claude Code's Task tool
- Never use CLI tools alone for execution — Task tool agents do the actual work
- MUST call CLI tools AND Task tool in ONE message for complex work

### 3-Tier Model Routing (ADR-026)

| Tier | Handler | Latency | Cost | Use Cases |
|------|---------|---------|------|-----------|
| **1** | Agent Booster (WASM) | <1ms | $0 | Simple transforms (var→const, add types) — Skip LLM |
| **2** | Haiku | ~500ms | $0.0002 | Simple tasks, low complexity (<30%) |
| **3** | Sonnet/Opus | 2-5s | $0.003-0.015 | Complex reasoning, architecture, security (>30%) |

- Always check for `[AGENT_BOOSTER_AVAILABLE]` or `[TASK_MODEL_RECOMMENDATION]` before spawning agents
- Use Edit tool directly when `[AGENT_BOOSTER_AVAILABLE]`

## Swarm Configuration & Anti-Drift

- ALWAYS use hierarchical topology for coding swarms
- Keep maxAgents at 6-8 for tight coordination
- Use specialized strategy for clear role boundaries
- Use `raft` consensus for hive-mind (leader maintains authoritative state)
- Run frequent checkpoints via `post-task` hooks
- Keep shared memory namespace for all agents

```bash
npx @claude-flow/cli@latest swarm init --topology hierarchical --max-agents 8 --strategy specialized
```

## Swarm Execution Rules

- ALWAYS use `run_in_background: true` for all agent Task calls
- ALWAYS put ALL agent Task calls in ONE message for parallel execution
- After spawning, STOP — do NOT add more tool calls or check status
- Never poll TaskOutput or check swarm status — trust agents to return
- When agent results arrive, review ALL results before proceeding

## V3 CLI Commands

### Core Commands

| Command | Subcommands | Description |
|---------|-------------|-------------|
| `init` | 4 | Project initialization |
| `agent` | 8 | Agent lifecycle management |
| `swarm` | 6 | Multi-agent swarm coordination |
| `memory` | 11 | AgentDB memory with HNSW search |
| `task` | 6 | Task creation and lifecycle |
| `session` | 7 | Session state management |
| `hooks` | 17 | Self-learning hooks + 12 workers |
| `hive-mind` | 6 | Byzantine fault-tolerant consensus |

### Quick CLI Examples

```bash
npx @claude-flow/cli@latest init --wizard
npx @claude-flow/cli@latest agent spawn -t coder --name my-coder
npx @claude-flow/cli@latest swarm init --v3-mode
npx @claude-flow/cli@latest memory search --query "authentication patterns"
npx @claude-flow/cli@latest doctor --fix
```

## Available Agents (60+ Types)

### Core Development
`coder`, `reviewer`, `tester`, `planner`, `researcher`

### Specialized
`security-architect`, `security-auditor`, `memory-specialist`, `performance-engineer`

### Swarm Coordination
`hierarchical-coordinator`, `mesh-coordinator`, `adaptive-coordinator`

### GitHub & Repository
`pr-manager`, `code-review-swarm`, `issue-tracker`, `release-manager`

### SPARC Methodology
`sparc-coord`, `sparc-coder`, `specification`, `pseudocode`, `architecture`

## Memory Commands Reference

```bash
# Store (REQUIRED: --key, --value; OPTIONAL: --namespace, --ttl, --tags)
npx @claude-flow/cli@latest memory store --key "pattern-auth" --value "JWT with refresh" --namespace patterns

# Search (REQUIRED: --query; OPTIONAL: --namespace, --limit, --threshold)
npx @claude-flow/cli@latest memory search --query "authentication patterns"

# List (OPTIONAL: --namespace, --limit)
npx @claude-flow/cli@latest memory list --namespace patterns --limit 10

# Retrieve (REQUIRED: --key; OPTIONAL: --namespace)
npx @claude-flow/cli@latest memory retrieve --key "pattern-auth" --namespace patterns
```

## Quick Setup

```bash
claude mcp add claude-flow -- npx -y @claude-flow/cli@latest
npx @claude-flow/cli@latest daemon start
npx @claude-flow/cli@latest doctor --fix
```

## Claude Code vs CLI Tools

- Claude Code's Task tool handles ALL execution: agents, file ops, code generation, git
- CLI tools handle coordination via Bash: swarm init, memory, hooks, routing
- NEVER use CLI tools as a substitute for Task tool agents

## Context management

- For tasks touching more than 5 independent files, use parallel sub-agents. One task per agent for focused execution.
- Use `run_in_background` for long-running tasks so the main agent can continue.
- Write intermediate results and session summaries to files when context gets large.

## Skill routing

When the user's request matches an available skill, ALWAYS invoke it using the Skill
tool as your FIRST action. Do NOT answer directly, do NOT use other tools first.

Key routing rules:
- Product ideas, "is this worth building", brainstorming → invoke office-hours
- Bugs, errors, "why is this broken", 500 errors → invoke investigate
- Ship, deploy, push, create PR → invoke ship
- QA, test the site, find bugs → invoke qa
- Code review, check my diff → invoke review
- Update docs after shipping → invoke document-release
- Weekly retro → invoke retro
- Architecture review → invoke plan-eng-review

## Support

- Documentation: https://github.com/ruvnet/claude-flow
- Issues: https://github.com/ruvnet/claude-flow/issues
