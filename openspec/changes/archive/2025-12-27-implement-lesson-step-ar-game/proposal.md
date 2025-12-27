# Implement AR Game Lesson Step

## Overview
Implement the AR (Augmented Reality) Game lesson step, the third and final interactive step in the learning flow. This feature uses the device camera and Google ML Kit Image Labeling to enable kids to find real-world objects matching the vocabulary word they are learning.

## Goal
Enable children to complete the `arGame` lesson step by pointing their device camera at real-world objects that match the lesson vocabulary. The AR Game reinforces vocabulary learning through physical interaction with the environment.

## Scope

### In Scope
- **Camera Integration**: Camera preview using back camera only
- **ML Kit Image Labeling**: Offline object detection with fuzzy label matching
- **AR Game Page**: Full-screen camera with detection overlay and game UI
- **Game Flow**: Target display → Camera scan → Match detection → Success celebration → Progress update
- **Debug Features**: Label overlay for testing, skip/cheat button, toggleable visibility
- **Clean Architecture**: Controller, binding, page, widgets following project conventions
- **VocabularyEntity Update**: Add `allowedLabels` field for AR matching
- **Home Page Test Button**: Debug button to navigate directly to AR Game for testing

### Out of Scope
- Front camera support
- AR overlays/3D objects (only camera + detection)
- Custom ML models (uses default ML Kit model)
- Online processing

## Dependencies
- `learning-data` spec (entities, progress tracking)
- `google_mlkit_image_labeling: ^0.14.1` (already in project)
- `camera: ^0.11.3` (already in project)
- `permission_handler: ^12.0.1` (already in project)

## Related Capabilities
- `learning-data`: Lesson entities, vocabulary with `allowedLabels`, progress tracking via `UpdateLessonProgressUseCase`

## Architecture Decision

> [!IMPORTANT]
> **VocabularyEntity owns `allowedLabels`**: Each vocabulary item has its own set of allowed ML Kit labels for AR detection. This allows reusing vocabulary across different lessons while maintaining consistent AR behavior.
