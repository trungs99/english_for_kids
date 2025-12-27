# Project Context

## Purpose
An educational app designed for kids to learn English through an interactive 3-step flow: Story → Flashcard → AR Object Hunt.

## Tech Stack
- **Framework**: Flutter (Android ONLY)
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **State Management**: GetX
- **Database**: Isar (Local persistence)
- **Utilities**: `exo_shared` (Internal library for base classes and UI)
- **AI/ML**: Google ML Kit Image Labeling
- **Assets**: `flutter_gen` for type-safe asset management
- **I18n**: GetX translations with `TranslationKeys`

## Project Conventions

### Code Style
- **Effective Dart**: Follow standard Dart style guide.
- **Naming**: `PascalCase` for classes, `camelCase` for variables/methods, `snake_case` for file names and serialized IDs.
- **Organization**: Clean Architecture folder structure.

### Architecture Patterns
- **Clean Architecture**: Strict separation between Domain (Pure Dart), Data (Persistence/Implementation), and Presentation (UI/Controllers).
- **Base Classes**: Use `BaseView` and `BaseController` from `exo_shared`.
- **Error Handling**: Wrap repository operations in `try-catch` and throw custom exceptions from `core/errors/`.
- **Loading State**: Use `withLoadingSafe` and `isLoading` from `BaseController`.

### Testing Strategy
- **Manual Verification**: Test on a physical Android device (Mandatory for AR features).
- **Static Analysis**: `flutter analyze` must pass.

### Git Workflow
- Verb-led commit messages.
- Feature branches for development.

## Domain Context
- **Learning Flow**: Each lesson has a Story step (reading), a Flashcard step (review), and an AR Game step (object detection).
- **Progress Tracking**: Lessons and Topics are unlocked sequentially.
- **Scoring/Completion**: A lesson is "done" only after the AR Game step is successfully completed.

## Important Constraints
- **Android ONLY**: No iOS support.
- **Physical Device**: Required for ML Kit and AR performance.
- **Offline First**: All learning content and ML processing must work without internet.

## External Dependencies
- `google_ml_kit_image_labeling`
- `flutter_tts`
- `isar_community`
- `exo_shared` (Git dependency)
