import 'package:isar_community/isar.dart';

import '../../domain/entities/lesson_step_type.dart';
import '../constants/constants.dart';
import '../models/lesson_model.dart';
import '../models/topic_model.dart';
import '../models/vocabulary_model.dart';

/// Local data source for learning feature using Isar database
class LearningLocalDataSource {
  final Isar _isar;

  LearningLocalDataSource(this._isar);

  /// Get all topics with their lessons and vocabularies
  Future<List<TopicModel>> getAllTopics() async {
    final topics = await _isar.topicModels.where().sortByOrderIndex().findAll();

    // Load relationships
    for (final topic in topics) {
      await topic.lessons.load();
      for (final lesson in topic.lessons) {
        await lesson.vocabularies.load();
      }
    }

    return topics;
  }

  /// Get a specific topic by ID
  Future<TopicModel?> getTopicById(String topicId) async {
    final topic = await _isar.topicModels.filter().modelIdEqualTo(topicId).findFirst();

    if (topic != null) {
      await topic.lessons.load();
      for (final lesson in topic.lessons) {
        await lesson.vocabularies.load();
      }
    }

    return topic;
  }

  /// Get a specific lesson by ID
  Future<LessonModel?> getLessonById(String lessonId) async {
    final lesson = await _isar.lessonModels.filter().modelIdEqualTo(lessonId).findFirst();

    if (lesson != null) {
      await lesson.vocabularies.load();
    }

    return lesson;
  }

  /// Update lesson progress
  Future<void> updateLessonProgress(String lessonId, LessonStep completedStep) async {
    await _isar.writeTxn(() async {
      final lesson = await _isar.lessonModels.filter().modelIdEqualTo(lessonId).findFirst();

      if (lesson == null) return;

      // Update current step based on completed step
      switch (completedStep) {
        case LessonStep.story:
          lesson.currentStep = LessonStep.flashcard.toIdString();
          break;
        case LessonStep.flashcard:
          lesson.currentStep = LessonStep.arGame.toIdString();
          break;
        case LessonStep.arGame:
          lesson.currentStep = LessonStep.done.toIdString();
          lesson.isCompleted = true;

          // Unlock next lesson
          final allLessons = await _isar.lessonModels.where().sortByOrderIndex().findAll();

          final currentIndex = allLessons.indexWhere((l) => l.modelId == lessonId);
          if (currentIndex != -1 && currentIndex + 1 < allLessons.length) {
            final nextLesson = allLessons[currentIndex + 1];
            nextLesson.isLocked = false;
            await _isar.lessonModels.put(nextLesson);
          }
          break;
        case LessonStep.done:
          // Already done, no action needed
          break;
      }

      await _isar.lessonModels.put(lesson);
    });
  }

  /// Check if database has been seeded
  Future<bool> isDatabaseSeeded() async {
    final count = await _isar.topicModels.count();
    return count > 0;
  }

  /// Seed initial data - 3 topics with 5 shared lessons (A-E)
  Future<void> seedInitialData() async {
    await _isar.writeTxn(() async {
      // Create vocabularies first
      final vocabularies = <String, VocabularyModel>{};
      for (final vocabConst in VocabularyConstants.all) {
        final vocab = VocabularyModel.create(
          modelId: vocabConst.id,
          word: vocabConst.word,
          meaning: vocabConst.meaning,
          imagePath: vocabConst.imagePath,
          allowedLabels: vocabConst.allowedLabels,
        );
        await _isar.vocabularyModels.put(vocab);
        vocabularies[vocabConst.id] = vocab;
      }

      // Create lessons and link vocabularies
      final lessons = <String, LessonModel>{};
      for (final lessonConst in LessonConstants.all) {
        final lesson = LessonModel.create(
          modelId: lessonConst.id,
          title: lessonConst.title,
          orderIndex: lessonConst.orderIndex,
          isLocked: lessonConst.orderIndex > 0, // First lesson unlocked, rest locked
          isCompleted: false,
          currentStep: LessonStep.story.toIdString(),
        );
        await _isar.lessonModels.put(lesson);

        // Link vocabulary to lesson
        final vocab = vocabularies[lessonConst.vocabularyId];
        if (vocab != null) {
          lesson.vocabularies.add(vocab);
          await lesson.vocabularies.save();
        }

        lessons[lessonConst.id] = lesson;
      }

      // Create topics and link shared lessons
      for (final topicConst in TopicConstants.all) {
        final topic = TopicModel.create(
          modelId: topicConst.id,
          name: topicConst.name,
          description: topicConst.description,
          thumbnailPath: topicConst.thumbnailPath,
          orderIndex: topicConst.orderIndex,
          isLocked: topicConst.orderIndex > 0, // First topic unlocked, rest locked
          isCompleted: false,
        );
        await _isar.topicModels.put(topic);

        // Link all shared lessons to this topic
        for (final lessonId in topicConst.lessonIds) {
          final lesson = lessons[lessonId];
          if (lesson != null) {
            topic.lessons.add(lesson);
          }
        }
        await topic.lessons.save();
      }
    });
  }
}
