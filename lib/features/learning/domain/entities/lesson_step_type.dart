/// Enum representing the different steps in a lesson
/// Each lesson progresses through: story -> flashcard -> arGame -> done
enum LessonStep {
  story,
  flashcard,
  arGame,
  done;

  /// Convert to string ID for database storage
  /// Returns snake_case format: lesson_step_story, lesson_step_flashcard, etc.
  String toIdString() {
    switch (this) {
      case LessonStep.story:
        return 'lesson_step_story';
      case LessonStep.flashcard:
        return 'lesson_step_flashcard';
      case LessonStep.arGame:
        return 'lesson_step_ar_game';
      case LessonStep.done:
        return 'lesson_step_done';
    }
  }

  /// Create from string ID
  /// Parses snake_case format: lesson_step_story -> LessonStep.story
  static LessonStep? fromIdString(String? id) {
    if (id == null) return null;

    switch (id) {
      case 'lesson_step_story':
        return LessonStep.story;
      case 'lesson_step_flashcard':
        return LessonStep.flashcard;
      case 'lesson_step_ar_game':
        return LessonStep.arGame;
      case 'lesson_step_done':
        return LessonStep.done;
      default:
        return null;
    }
  }
}
