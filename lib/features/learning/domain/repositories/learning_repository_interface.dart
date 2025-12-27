import '../entities/topic_entity.dart';
import '../entities/lesson_entity.dart';
import '../entities/lesson_step_type.dart';

/// Repository interface for learning data operations
/// Defines the contract for data access without implementation details
abstract class LearningRepositoryInterface {
  /// Get all topics with their lessons and vocabularies
  Future<List<TopicEntity>> getAllTopics();

  /// Get a specific topic by ID
  Future<TopicEntity?> getTopicById(String topicId);

  /// Get a specific lesson by ID
  Future<LessonEntity?> getLessonById(String lessonId);

  /// Update lesson progress
  /// Updates the current step and handles unlocking logic
  Future<void> updateLessonProgress(String lessonId, LessonStep completedStep);

  /// Seed initial data into the database
  Future<void> seedInitialData();

  /// Check if database has been seeded
  Future<bool> isDatabaseSeeded();
}
