import '../entities/vocabulary_entity.dart';

/// Use case to process ML Kit image labels and determine if they match the target vocabulary
class ProcessImageLabelUseCase {
  /// Check if detected label matches the target vocabulary
  /// Returns true if confidence >= 0.7 and label is in allowed list
  bool call({
    required VocabularyEntity vocabulary,
    required String detectedLabel,
    required double confidence,
  }) {
    // Confidence threshold: 70%
    if (confidence < 0.7) return false;

    // Case-insensitive fuzzy matching against allowed labels
    return vocabulary.allowedLabels.any(
      (allowed) => allowed.toLowerCase() == detectedLabel.toLowerCase(),
    );
  }
}
