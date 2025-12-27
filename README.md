# Kids English MVP 🦁

An interactive English learning application for children, featuring pronunciation practice and an AR Object Hunt game. This project demonstrates a robust implementation of **Clean Architecture** in Flutter within an 8-hour hackathon context.

## 🌟 Core Features

- **Interactive Learning Flow**: Structured path guiding children through Topic Selection → Pronunciation Practice → AR Object Hunt.
- **Topic Selection**: Choose from various topics (e.g., Alphabet, Numbers, Colors).
- **Speech Game**: Practice pronunciation by speaking vocabulary words (e.g., "Apple") with real-time feedback using Speech-to-Text.
- **AR Object Hunt**: A real-time game where kids find physical objects (e.g., "Find a Cup") using the device's camera and ML Kit object detection.
- **Clean Architecture**: Strict separation of concerns into Domain, Data, and Presentation layers for scalability and testability.
- **Strict Asset & String Management**: Uses `flutter_gen` for type-safe assets and a centralized translation system.

## 🏗️ Architecture

The application is built using **Clean Architecture** to ensure maintainability and testability:

```
lib/
├── core/                          # Shared utilities (Theme, Translations, etc.)
├── features/                      # Feature modules
│   └── home/                      # Home screen & Topic selection
│   └── learning/                  # Main learning feature
│       ├── domain/                # Business Logic (Entities, UseCases, Repositories)
│       ├── data/                  # Data Handling (Models, DataSources, Repositories Impl)
│       └── presentation/          # UI Layer (Controllers, Pages, Widgets)
└── gen/                           # Generated code (Assets, etc.)
```

## 🛠️ Tech Stack

- **Framework**: Flutter (Latest Stable)
- **Language**: Dart
- **State Management**: GetX
- **Architecture**: Clean Architecture
- **ML & Camera**: `google_ml_kit_image_labeling`, `camera`
- **Speech Recognition**: `speech_to_text`
- **UI Kit**: `exo_shared`
- **Code Gen**: `flutter_gen`, `build_runner`

## 📱 Requirements

- **Platform**: Android
- **Device**: **Real Android Device Required** (Emulators are not suitable for real-time ML camera features).
- **Min SDK**: 28 (Android 9 Pie)
- **Target SDK**: 34

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK installed
- Android device connected via USB

### 2. Installation
```bash
# Clone the repository
git clone <repository_url>
cd english_for_kids

# Install dependencies
flutter pub get
```

### 3. Code Generation
This project uses `flutter_gen` for safe asset management. You must run build_runner before starting the app:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Running the App
Connect your Android device and run:
```bash
flutter run
```

*Note: Ensure you grant Microphone and Camera permissions when prompted to use the Speech and AR features.*

## 📚 Project Structure

- **Domain Layer**: Pure Dart, no Flutter dependencies. Contains Entities and Use Cases.
- **Data Layer**: Handles data retrieval (local hardcoded data for MVP). Maps Models to Entities.
- **Presentation Layer**: Uses GetX Controllers for state management and Flutter Widgets for UI.

## 🐛 Debugging

The AR Game includes a **Debug Overlay** to show real-time ML Kit detection results (labels and confidence scores) to help understand how the object detection is performing in different lighting conditions.
