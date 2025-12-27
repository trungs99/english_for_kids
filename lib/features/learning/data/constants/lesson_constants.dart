/// Constants for lesson items used in initial data seeding.
/// 
/// These constants define the lesson data that will be seeded into the database
/// on first launch. The same 5 lessons (A-E) are shared across all 3 topics.
class LessonConstants {
  /// Lesson A - Letter A
  /// 
  /// First lesson in the sequence, associated with Apple vocabulary.
  static const lessonA = (
    id: 'lesson_a',
    title: 'Letter A',
    orderIndex: 0,
    vocabularyId: 'vocab_lesson_a',
  );

  /// Lesson B - Letter B
  /// 
  /// Second lesson in the sequence, associated with Bottle vocabulary.
  static const lessonB = (
    id: 'lesson_b',
    title: 'Letter B',
    orderIndex: 1,
    vocabularyId: 'vocab_lesson_b',
  );

  /// Lesson C - Letter C
  /// 
  /// Third lesson in the sequence, associated with Cup vocabulary.
  static const lessonC = (
    id: 'lesson_c',
    title: 'Letter C',
    orderIndex: 2,
    vocabularyId: 'vocab_lesson_c',
  );

  /// Lesson D - Letter D
  /// 
  /// Fourth lesson in the sequence, associated with Desk vocabulary.
  static const lessonD = (
    id: 'lesson_d',
    title: 'Letter D',
    orderIndex: 3,
    vocabularyId: 'vocab_lesson_d',
  );

  /// Lesson E - Letter E
  /// 
  /// Fifth lesson in the sequence, associated with Egg vocabulary.
  static const lessonE = (
    id: 'lesson_e',
    title: 'Letter E',
    orderIndex: 4,
    vocabularyId: 'vocab_lesson_e',
  );

  /// List of all lesson constants
  static const all = [
    lessonA,
    lessonB,
    lessonC,
    lessonD,
    lessonE,
  ];
}

