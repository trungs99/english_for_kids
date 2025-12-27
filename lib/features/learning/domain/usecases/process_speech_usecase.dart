import '../entities/vocabulary_entity.dart';

/// Use case to process speech recognition results and determine if they match the target vocabulary
class ProcessSpeechUseCase {
  /// Check if spoken text contains the target vocabulary word
  /// Normalizes both strings (lowercase, trim whitespace) and performs case-insensitive substring match
  /// Returns true if spoken text contains the vocabulary word
  bool call({
    required VocabularyEntity vocabulary,
    required String spokenText,
  }) {
    // Normalize both strings
    final normalizedWord = vocabulary.word.toLowerCase().trim();
    final normalizedSpoken = spokenText.toLowerCase().trim();

    // Check if spoken text contains the vocabulary word (case-insensitive substring match)
    return normalizedSpoken.contains(normalizedWord);
  }
}

