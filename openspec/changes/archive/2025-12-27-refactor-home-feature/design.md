# Design

## Architecture

We adhere to the **Clean Architecture** patterns.

### Directory Structure
```
lib/features/home/
├── data/                  # Data layer (Empty for now)
├── domain/                # Domain layer (Empty for now)
└── presentation/          # Presentation layer
    ├── bindings/
    ├── controllers/
    ├── pages/
    └── widgets/
```

## UI/UX

### Home Page
- **Extends**: `BaseView<HomeController>`
- **AppBar**: `MAppBar` (Title: "Home", stored in translations)
- **Body**: Column with:
    - Icon (School)
    - Title Text
    - "Start Learning" Button (`MButton.elevated`)
    - "My Progress" Button (`MButton.elevated`)

## Logic
- No complex business logic yet.
- `HomeController` handles navigation (mocked/stubbed for now).
