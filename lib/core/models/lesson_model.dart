import 'word_model.dart';

/// Domain model for a lesson/level
class LessonModel {
  final int level;
  final String letter;
  final WordModel word;
  final bool isCompleted;
  final bool isLocked;

  const LessonModel({
    required this.level,
    required this.letter,
    required this.word,
    this.isCompleted = false,
    this.isLocked = false,
  });

  LessonModel copyWith({
    int? level,
    String? letter,
    WordModel? word,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return LessonModel(
      level: level ?? this.level,
      letter: letter ?? this.letter,
      word: word ?? this.word,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonModel &&
        other.level == level &&
        other.letter == letter &&
        other.word == word &&
        other.isCompleted == isCompleted &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode => Object.hash(
        level,
        letter,
        word,
        isCompleted,
        isLocked,
      );

  @override
  String toString() =>
      'LessonModel(level: $level, letter: $letter, word: ${word.word}, isLocked: $isLocked)';
}

