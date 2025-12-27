import '../../domain/entities/topic_entity.dart';
import '../../domain/repositories/learning_repository_interface.dart';

/// UseCase to fetch a specific topic by ID
class GetTopicByIdUseCase {
  final LearningRepositoryInterface _repository;

  GetTopicByIdUseCase(this._repository);

  /// Fetches a specific topic by ID with its lessons and vocabularies
  /// Returns null if topic not found
  Future<TopicEntity?> call(String topicId) async {
    return await _repository.getTopicById(topicId);
  }
}
