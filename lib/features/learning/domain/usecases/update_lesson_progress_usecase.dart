import '../../domain/entities/lesson_step_type.dart';
import '../../domain/repositories/learning_repository_interface.dart';

/// UseCase to update lesson progress
/// Handles step progression: story -> flashcard -> arGame -> done
class UpdateLessonProgressUseCase {
  final LearningRepositoryInterface _repository;

  UpdateLessonProgressUseCase(this._repository);

  /// Updates lesson progress based on completed step
  ///
  /// Progression logic:
  /// - story completed -> move to flashcard
  /// - flashcard completed -> move to arGame
  /// - arGame completed -> mark as done, unlock next lesson
  ///
  /// Throws NotFoundError if lesson doesn't exist
  Future<void> call({
    required String lessonId,
    required LessonStep completedStep,
  }) async {
    await _repository.updateLessonProgress(lessonId, completedStep);
  }
}
