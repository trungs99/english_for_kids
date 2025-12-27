import 'package:isar_community/isar.dart';
import 'vocabulary_model.dart';

part 'lesson_model.g.dart';

/// Isar model for lessons
@collection
class LessonModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String modelId;

  late String title;
  late int orderIndex;
  late bool isLocked;
  late bool isCompleted;

  /// Current step stored as string (e.g., "lesson_step_story")
  late String currentStep;

  /// One Lesson has many Vocabularies
  final vocabularies = IsarLinks<VocabularyModel>();

  LessonModel();

  LessonModel.create({
    required this.modelId,
    required this.title,
    required this.orderIndex,
    required this.isLocked,
    required this.isCompleted,
    required this.currentStep,
  });
}
