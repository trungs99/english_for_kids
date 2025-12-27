import '../../../../core/exceptions/storage_error.dart';
import '../../../../core/exceptions/not_found_error.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/lesson_step_type.dart';
import '../../domain/repositories/learning_repository_interface.dart';
import '../datasources/learning_local_datasource.dart';
import '../mappers/learning_mapper.dart';

/// Repository implementation for learning data operations
class LearningRepository implements LearningRepositoryInterface {
  final LearningLocalDataSource _dataSource;

  LearningRepository(this._dataSource);

  @override
  Future<List<TopicEntity>> getAllTopics() async {
    try {
      final models = await _dataSource.getAllTopics();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw StorageError('Failed to get all topics', e);
    }
  }

  @override
  Future<TopicEntity?> getTopicById(String topicId) async {
    try {
      final model = await _dataSource.getTopicById(topicId);
      return model?.toEntity();
    } catch (e) {
      throw StorageError('Failed to get topic by ID: $topicId', e);
    }
  }

  @override
  Future<LessonEntity?> getLessonById(String lessonId) async {
    try {
      final model = await _dataSource.getLessonById(lessonId);
      return model?.toEntity();
    } catch (e) {
      throw StorageError('Failed to get lesson by ID: $lessonId', e);
    }
  }

  @override
  Future<void> updateLessonProgress(
    String lessonId,
    LessonStep completedStep,
  ) async {
    try {
      // Check if lesson exists
      final lesson = await _dataSource.getLessonById(lessonId);
      if (lesson == null) {
        throw NotFoundError('Lesson not found: $lessonId');
      }

      await _dataSource.updateLessonProgress(lessonId, completedStep);
    } catch (e) {
      if (e is NotFoundError) rethrow;
      throw StorageError('Failed to update lesson progress: $lessonId', e);
    }
  }

  @override
  Future<void> seedInitialData() async {
    try {
      await _dataSource.seedInitialData();
    } catch (e) {
      throw StorageError('Failed to seed initial data', e);
    }
  }

  @override
  Future<bool> isDatabaseSeeded() async {
    try {
      return await _dataSource.isDatabaseSeeded();
    } catch (e) {
      throw StorageError('Failed to check if database is seeded', e);
    }
  }
}
