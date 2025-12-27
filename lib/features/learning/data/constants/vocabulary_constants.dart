/// Constants for vocabulary items used in initial data seeding.
/// 
/// These constants define the vocabulary data that will be seeded into the database
/// on first launch. Each vocabulary is associated with a lesson (A-E).
class VocabularyConstants {
  /// Vocabulary for Letter A lesson
  /// 
  /// Represents the word "Apple" with Vietnamese meaning and AR labels.
  static const lessonA = (
    id: 'vocab_lesson_a',
    word: 'Apple',
    meaning: 'Quả táo',
    imagePath: 'assets/images/learning/lession_1/img_apple.png',
    allowedLabels: [
      'Apple',
      'Fruit',
      'Food',
      'Red',
      'Natural foods',
    ],
  );

  /// Vocabulary for Letter B lesson
  /// 
  /// Represents the word "Bottle" with Vietnamese meaning and AR labels.
  static const lessonB = (
    id: 'vocab_lesson_b',
    word: 'Bottle',
    meaning: 'Cái chai',
    imagePath: 'assets/images/learning/lession_1/img_bottle.png',
    allowedLabels: [
      'Bottle',
      'Water bottle',
      'Drinkware',
      'Plastic',
      'Container',
    ],
  );

  /// Vocabulary for Letter C lesson
  /// 
  /// Represents the word "Cup" with Vietnamese meaning and AR labels.
  static const lessonC = (
    id: 'vocab_lesson_c',
    word: 'Cup',
    meaning: 'Cái cốc',
    imagePath: 'assets/images/learning/lession_1/img_cup.png',
    allowedLabels: [
      'Cup',
      'Mug',
      'Coffee cup',
    ],
  );

  /// Vocabulary for Letter D lesson
  /// 
  /// Represents the word "Desk" with Vietnamese meaning and AR labels.
  static const lessonD = (
    id: 'vocab_lesson_d',
    word: 'Desk',
    meaning: 'Cái bàn',
    imagePath: 'assets/images/learning/lession_1/img_desk.png',
    allowedLabels: [
      'Desk',
      'Table',
      'Furniture',
      'Office',
      'Wood',
    ],
  );

  /// Vocabulary for Letter E lesson
  /// 
  /// Represents the word "Egg" with Vietnamese meaning and AR labels.
  static const lessonE = (
    id: 'vocab_lesson_e',
    word: 'Egg',
    meaning: 'Quả trứng',
    imagePath: 'assets/images/learning/lession_1/img_ear.png', // Using ear.png as placeholder for egg
    allowedLabels: [
      'Egg',
      'Food',
      'Oval',
      'White',
      'Ingredient',
      'Breakfast',
    ],
  );

  /// List of all vocabulary constants
  static const all = [
    lessonA,
    lessonB,
    lessonC,
    lessonD,
    lessonE,
  ];
}

