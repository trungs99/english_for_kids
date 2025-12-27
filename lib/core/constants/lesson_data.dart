import '../models/word_model.dart';
import '../models/lesson_model.dart';

/// Hardcoded lesson data - 5 levels (A, B, C, D, E)
final List<WordModel> lessonWords = [
  WordModel(
    letter: 'A',
    word: 'Apple',
    vietnameseMeaning: 'Quả táo',
    imageAsset: 'assets/images/apple.png',
    storySentence: 'A is for Apple. The apple is red.',
  ),
  WordModel(
    letter: 'B',
    word: 'Bottle',
    vietnameseMeaning: 'Cái chai',
    imageAsset: 'assets/images/bottle.png',
    storySentence: 'B is for Bottle. The bottle is full of water.',
  ),
  WordModel(
    letter: 'C',
    word: 'Cup',
    vietnameseMeaning: 'Cái cốc',
    imageAsset: 'assets/images/cup.png',
    storySentence: 'C is for Cup. I drink from a cup.',
  ),
  WordModel(
    letter: 'D',
    word: 'Desk',
    vietnameseMeaning: 'Cái bàn',
    imageAsset: 'assets/images/desk.png',
    storySentence: 'D is for Desk. I study at my desk.',
  ),
  WordModel(
    letter: 'E',
    word: 'Egg',
    vietnameseMeaning: 'Quả trứng',
    imageAsset: 'assets/images/egg.png',
    storySentence: 'E is for Egg. The egg is white.',
  ),
];

/// Generate lessons from words
List<LessonModel> generateLessons() {
  return lessonWords.asMap().entries.map((entry) {
    final index = entry.key;
    final word = entry.value;
    
    return LessonModel(
      level: index + 1,
      letter: word.letter,
      word: word,
      isLocked: index > 0, // First lesson (A) is unlocked, others are locked
      isCompleted: false,
    );
  }).toList();
}

/// Get lesson by level index (0-based)
LessonModel? getLessonByIndex(int index) {
  final lessons = generateLessons();
  if (index >= 0 && index < lessons.length) {
    return lessons[index];
  }
  return null;
}

/// Get lesson by letter
LessonModel? getLessonByLetter(String letter) {
  final lessons = generateLessons();
  return lessons.firstWhere(
    (lesson) => lesson.letter == letter.toUpperCase(),
    orElse: () => lessons.first,
  );
}

