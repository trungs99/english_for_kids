import 'word_model.dart';

/// Data model for a lesson
class LessonModel {
  final int levelIndex;
  final WordModel word;

  LessonModel({
    required this.levelIndex,
    required this.word,
  });

  /// Create from JSON/Map
  factory LessonModel.fromMap(Map<String, dynamic> map, int levelIndex) {
    return LessonModel(
      levelIndex: levelIndex,
      word: WordModel.fromMap(map),
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'levelIndex': levelIndex,
      'word': word.toMap(),
    };
  }
}

