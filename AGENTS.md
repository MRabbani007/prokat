# AGENTS.md

## Project
Prokat Mobile is a Flutter + Riverpod + GoRouter app for equipment rental:
vacuum trucks, manipulators, tow trucks, cranes, forklifts, excavators.

## Tech stack
- Flutter / Dart
- Riverpod for state
- GoRouter for routing
- Dio for API
- Prisma backend schema
- Mapbox for maps

## Architecture rules
- Keep feature-based structure:
  - models/
  - services/
  - providers/
  - screens/
  - widgets/
- Do not mix API calls directly into UI widgets.
- Use notifier/provider pattern similar to existing features.
- Keep backend DTO naming aligned with Prisma schema.
- Prefer small reusable widgets over large screen files.

## Flutter style
- Use `Theme.of(context)` and `colorScheme`; avoid hardcoded colors.
- Use `context.go()` / `context.push()` for navigation.
- Keep widgets responsive and SafeArea-aware.
- Avoid business logic inside `build`.
- Prefer `AsyncValue` or explicit `isLoading/error` state patterns consistently.

## Riverpod rules
- Providers must be lowercase variables like `equipmentProvider`.
- Controller classes should not be named `SomethingProvider`.
- Use `ref.read(...notifier)` for actions.
- Use `ref.watch(...)` for UI state.

## API rules
- Propagate backend error messages from Dio responses.
- Do not replace backend errors with generic messages unless no message exists.
- Keep response parsing defensive.

## Commands
- Analyze: `flutter analyze`
- Format: `dart format .`
- Test: `flutter test`

## Before finishing a task
- Run `dart format .`
- Run `flutter analyze`
- Explain changed files briefly.