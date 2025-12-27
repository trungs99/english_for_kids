import 'package:isar_community/isar.dart';

import '../../domain/entities/lesson_step_type.dart';
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

  /// Seed initial data - Alphabet topic with 5 lessons (A-E)
  Future<void> seedInitialData() async {
    await _isar.writeTxn(() async {
      // Create Alphabet topic
      final alphabetTopic = TopicModel.create(
        modelId: 'topic_alphabet',
        name: 'Bảng Chữ Cái',
        description: 'Học bảng chữ cái với những từ vựng vui nhộn',
        thumbnailPath: 'assets/images/learning/lession_1/img_apple.png',
        orderIndex: 0,
        isLocked: false,
        isCompleted: false,
      );
      await _isar.topicModels.put(alphabetTopic);

      // Create lessons and vocabularies
      final lessonsData = [
        {
          'id': 'lesson_a',
          'title': 'Chữ Cái A',
          'word': 'Apple',
          'meaning': 'Quả táo',
          'image': 'assets/images/learning/lession_1/img_apple.png',
        },
        {
          'id': 'lesson_b',
          'title': 'Chữ Cái B',
          'word': 'Bottle',
          'meaning': 'Cái chai',
          'image': 'assets/images/learning/lession_1/img_bottle.png',
        },
        {
          'id': 'lesson_c',
          'title': 'Chữ Cái C',
          'word': 'Cup',
          'meaning': 'Cái cốc',
          'image': 'assets/images/learning/lession_1/img_cup.png',
        },
        {
          'id': 'lesson_d',
          'title': 'Chữ Cái D',
          'word': 'Desk',
          'meaning': 'Cái bàn',
          'image': 'assets/images/learning/lession_1/img_desk.png',
        },
        {
          'id': 'lesson_e',
          'title': 'Chữ Cái E',
          'word': 'Egg',
          'meaning': 'Quả trứng',
          'image':
              'assets/images/learning/lession_1/img_ear.png', // Using ear.png as placeholder for egg
        },
      ];

      for (int i = 0; i < lessonsData.length; i++) {
        final data = lessonsData[i];

        // Create lesson
        final lesson = LessonModel.create(
          modelId: data['id'] as String,
          title: data['title'] as String,
          orderIndex: i,
          isLocked: i > 0, // First lesson unlocked, rest locked
          isCompleted: false,
          currentStep: LessonStep.story.toIdString(),
        );
        await _isar.lessonModels.put(lesson);

        // Create vocabulary
        final vocab = VocabularyModel.create(
          modelId: 'vocab_${data['id']}',
          word: data['word'] as String,
          meaning: data['meaning'] as String,
          imagePath: data['image'] as String,
        );
        await _isar.vocabularyModels.put(vocab);

        // Link vocabulary to lesson
        lesson.vocabularies.add(vocab);
        await lesson.vocabularies.save();

        // Link lesson to topic
        alphabetTopic.lessons.add(lesson);
      }

      // Save topic with all lesson links
      await alphabetTopic.lessons.save();
    });
  }
}
