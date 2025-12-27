# Design: Project Setup Foundation

## Context

This is an 8-hour hackathon project to build a Kids English Learning App MVP using Flutter with Clean Architecture. The project requires:
- Android-only target (real device required for ML Kit testing)
- Clean Architecture pattern with three layers (Domain, Data, Presentation)
- Integration with `exo_shared` library for standardized base classes
- Offline object detection using ML Kit

## Goals

- Establish a Clean Architecture folder structure
- Configure Android for ML Kit and camera access
- Set up asset management with `flutter_gen`
- Set up translation infrastructure with `TranslationKeys`
- Create a foundation that enables parallel development of features

## Non-Goals

- Implementing actual feature logic (covered in subsequent proposals)
- User authentication or remote backend integration
- iOS platform support

## Decisions

### D1: Clean Architecture Layer Separation

**Decision**: Use strict three-layer separation with clear dependency rules.

**Rationale**: 
- Domain layer has no external dependencies (pure Dart)
- Data layer only depends on Domain layer
- Presentation layer can depend on both Domain and Data layers
- This enables unit testing of business logic without framework dependencies

### D2: Android SDK Versions

**Decision**: Use `minSdk = 28`, `compileSdk = 35`, `targetSdk = 35`.

**Rationale**:
- `minSdk 28` (Android 9 Pie) is required for ML Kit image labeling to function properly
- `compileSdk 35` provides the latest Android APIs while maintaining stability
- `multiDexEnabled = true` is required due to ML Kit's large number of methods

### D3: Asset Management

**Decision**: Use `flutter_gen` for all asset references.

**Rationale**:
- Type-safe asset access (`Assets.images.apple.image()`)
- Compile-time verification of asset paths
- Consistent pattern enforced across the codebase
- Hardcoded string paths are explicitly forbidden

### D4: String Localization

**Decision**: Use `TranslationKeys` class with GetX `.tr` extension. **Vietnamese (VI) as default locale**.

**Rationale**:
- Target audience is Vietnamese children learning English
- Centralized translation key management
- Runtime language switching capability
- Support for English and Vietnamese languages
- Hardcoded UI strings are explicitly forbidden

### D5: Folder Structure

**Decision**: Use feature-first organization with Clean Architecture layers.

```
lib/
├── core/                    # Shared infrastructure
│   ├── bindings/            # Global DI bindings
│   ├── constants/           # App-wide constants
│   ├── routes/              # Navigation configuration
│   ├── theme/               # Colors, typography, themes
│   ├── translations/        # i18n resources
│   └── widgets/             # Reusable UI components
├── features/
│   ├── splash/              # Splash screen feature
│   │   └── presentation/    # UI only (no domain/data needed)
│   ├── home/                # Home screen feature
│   │   └── presentation/    # UI only (no domain/data needed)
│   └── learning/            # Main learning feature
│       ├── domain/          # Business logic layer
│       ├── data/            # Data access layer
│       └── presentation/    # UI layer
└── gen/                     # Generated code (flutter_gen)
```

**Rationale**:
- Feature modules can be developed in isolation
- Clear boundaries between layers
- Easy to add new features without modifying core
- Consistent with `exo_shared` patterns

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Boilerplate overhead for MVP | Use code templates and leverage `exo_shared` base classes |
| Learning curve for Clean Architecture | Provide clear examples in `technical_spec.md` |
| Build time with flutter_gen | Only regenerate when assets change |

## Open Questions

- None at this time.
