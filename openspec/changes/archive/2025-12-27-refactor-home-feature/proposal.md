# Refactor Home Feature

## Goal
Refactor the existing `Home` feature to strictly follow the **Clean Architecture** patterns, **exo_shared** usage, and coding conventions defined in `new-feature-implementation-instruction.md`.

## Context
The current `Home` feature implementation is basic and violates some `BaseView` usage patterns (e.g., nesting `Scaffold`). It lacks the full directory structure required by the project standards. This change aims to bring it up to standard to serve as a proper foundation for future features.

## Changes
1.  **Presentation Layer**:
    *   Refactor `HomePage` to remove redundant `Scaffold`.
    *   Use `MAppBar` within `BaseView`.
    *   Ensure `HomeController` is ready for `exo_shared` patterns.
2.  **Structure**:
    *   Enforce `features/home/domain` and `features/home/data` directory structure (scaffold empty layers to comply with the standard).

## Impact
- `lib/features/home/presentation/pages/home_page.dart`
- `lib/features/home/presentation/controllers/home_controller.dart`
- Directory structure of `lib/features/home/`
