import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/vocabulary_entity.dart';
import '../../domain/entities/lesson_step_type.dart';
import '../models/topic_model.dart';
import '../models/lesson_model.dart';
import '../models/vocabulary_model.dart';

/// Extension to convert VocabularyModel to VocabularyEntity
extension VocabularyModelMapper on VocabularyModel {
  VocabularyEntity toEntity() {
    return VocabularyEntity(
      id: modelId,
      word: word,
      meaning: meaning,
      imagePath: imagePath,
      audioPath: audioPath,
      allowedLabels: allowedLabels,
    );
  }
}

/// Extension to convert VocabularyEntity to VocabularyModel
extension VocabularyEntityMapper on VocabularyEntity {
  VocabularyModel toModel() {
    return VocabularyModel.create(
      modelId: id,
      word: word,
      meaning: meaning,
      imagePath: imagePath,
      audioPath: audioPath,
      allowedLabels: allowedLabels,
    );
  }
}

/// Extension to convert LessonModel to LessonEntity
extension LessonModelMapper on LessonModel {
  LessonEntity toEntity() {
    return LessonEntity(
      id: modelId,
      title: title,
      orderIndex: orderIndex,
      isLocked: isLocked,
      isCompleted: isCompleted,
      currentStep: LessonStep.fromIdString(currentStep) ?? LessonStep.story,
      vocabularies: vocabularies.map((v) => v.toEntity()).toList(),
    );
  }
}

/// Extension to convert LessonEntity to LessonModel
extension LessonEntityMapper on LessonEntity {
  LessonModel toModel() {
    return LessonModel.create(
      modelId: id,
      title: title,
      orderIndex: orderIndex,
      isLocked: isLocked,
      isCompleted: isCompleted,
      currentStep: currentStep.toIdString(),
    );
  }
}

/// Extension to convert TopicModel to TopicEntity
extension TopicModelMapper on TopicModel {
  TopicEntity toEntity() {
    return TopicEntity(
      id: modelId,
      name: name,
      description: description,
      thumbnailPath: thumbnailPath,
      orderIndex: orderIndex,
      isLocked: isLocked,
      isCompleted: isCompleted,
      lessons: lessons.map((l) => l.toEntity()).toList(),
    );
  }
}

/// Extension to convert TopicEntity to TopicModel
extension TopicEntityMapper on TopicEntity {
  TopicModel toModel() {
    return TopicModel.create(
      modelId: id,
      name: name,
      description: description,
      thumbnailPath: thumbnailPath,
      orderIndex: orderIndex,
      isLocked: isLocked,
      isCompleted: isCompleted,
    );
  }
}
