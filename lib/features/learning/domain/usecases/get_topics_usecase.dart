import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/learning_repository_interface.dart';

/// UseCase to fetch all topics with their lessons and vocabularies
class GetTopicsUseCase {
  final LearningRepositoryInterface _repository;

  GetTopicsUseCase(this._repository);

  /// Fetches all topics with nested lessons and vocabulary
  /// Returns topics sorted by orderIndex
  Future<List<TopicEntity>> call() async {
    return await _repository.getAllTopics();
  }
}
