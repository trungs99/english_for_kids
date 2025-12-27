import 'package:isar_community/isar.dart';
import 'lesson_model.dart';

part 'topic_model.g.dart';

/// Isar model for topics
@collection
class TopicModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String modelId;

  late String name;
  late String description;
  late String thumbnailPath;
  late int orderIndex;
  late bool isLocked;
  late bool isCompleted;

  /// One Topic has many Lessons
  final lessons = IsarLinks<LessonModel>();

  TopicModel();

  TopicModel.create({
    required this.modelId,
    required this.name,
    required this.description,
    required this.thumbnailPath,
    required this.orderIndex,
    required this.isLocked,
    required this.isCompleted,
  });
}
