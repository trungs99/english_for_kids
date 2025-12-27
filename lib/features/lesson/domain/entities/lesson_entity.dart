import 'word_entity.dart';

/// Domain entity for a lesson
/// Contains a word entity and level information
class LessonEntity {
  final int levelIndex; // 0-4
  final WordEntity word;

  const LessonEntity({
    required this.levelIndex,
    required this.word,
  });

  /// Create a copy with some fields replaced
  LessonEntity copyWith({
    int? levelIndex,
    WordEntity? word,
  }) {
    return LessonEntity(
      levelIndex: levelIndex ?? this.levelIndex,
      word: word ?? this.word,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonEntity &&
        other.levelIndex == levelIndex &&
        other.word == word;
  }

  @override
  int get hashCode => Object.hash(levelIndex, word);

  @override
  String toString() => 'LessonEntity(levelIndex: $levelIndex, word: ${word.word})';
}

