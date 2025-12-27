import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/learning_repository_interface.dart';

/// UseCase to fetch a specific lesson by ID
class GetLessonByIdUseCase {
  final LearningRepositoryInterface _repository;

  GetLessonByIdUseCase(this._repository);

  /// Fetches a specific lesson by ID with its vocabularies
  /// Returns null if lesson not found
  Future<LessonEntity?> call(String lessonId) async {
    return await _repository.getLessonById(lessonId);
  }
}
