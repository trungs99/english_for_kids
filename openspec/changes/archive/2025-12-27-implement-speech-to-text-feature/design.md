# Speech-to-Text Feature Design

## Context
Adding pronunciation practice to the English learning app. Users speak vocabulary words aloud, and the app recognizes their speech to verify correct pronunciation. This enhances active learning by engaging auditory and verbal skills alongside visual learning.

## Goals / Non-Goals
### Goals
- Enable speech recognition for English vocabulary practice
- Provide immediate feedback on pronunciation attempts
- Handle device permission flow gracefully
- Support offline recognition where possible

### Non-Goals
- Pronunciation scoring/grading (only pass/fail matching)
- Supporting languages other than English for recognition
- Recording and playback of user's voice

## Decisions

### Decision 1: Use `speech_to_text` Flutter package
- **What**: Use the `speech_to_text` package for speech recognition
- **Why**: Well-maintained, supports Android, integrates with platform speech services
- **Alternatives considered**:
  - Google Cloud Speech-to-Text API: Requires network, adds cost
  - Custom ML model: Overkill for simple word matching

### Decision 2: Fixed English locale (`en_US`)
- **What**: Always configure speech recognition with `en_US` locale
- **Why**: App teaches English vocabulary; device locale may be Vietnamese but recognition should be English
- **Trade-off**: Users with UK English accent may have slightly lower accuracy

### Decision 3: Simple substring matching for vocabulary
- **What**: Match if recognized text contains target word (case-insensitive)
- **Why**: Speech recognition often adds context words ("I said apple"); substring matching handles this naturally
- **Trade-off**: Could match false positives in rare cases

### Decision 4: Reuse existing patterns from AR Game
- **What**: Follow same controller/binding/page structure as ARGameController
- **Why**: Consistent architecture, proven pattern, easier maintenance
- **Files to mirror**: `ar_game_controller.dart`, `ar_game_page.dart`, `ar_game_binding.dart`

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Speech recognition unavailable on some devices | Enable skip-only mode; graceful degradation |
| Microphone permission denied | Show rationale dialog; allow skip |
| Poor recognition in noisy environments | Allow multiple attempts; provide skip option |
| Speech recognition requires internet on some Android versions | Inform user if offline recognition unavailable |

## Open Questions
- Should we add a "Try again" button after failed recognition, or just continue listening?
- Should success require speaking ONLY the target word, or allow it in a sentence?

## Implementation Notes
- Use `Permission.microphone.request()` for permission handling
- Controller extends `BaseController` from `exo_shared`
- Page extends `BaseView` from `exo_shared`
- Add `speech_to_text: ^6.6.0` to `pubspec.yaml`

