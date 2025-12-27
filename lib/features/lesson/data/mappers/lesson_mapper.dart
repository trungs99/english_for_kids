import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/word_entity.dart';
import '../models/lesson_model.dart';
import '../models/word_model.dart';

/// Extension to convert WordModel to WordEntity
extension WordModelMapper on WordModel {
  WordEntity toEntity() {
    return WordEntity(
      letter: letter,
      word: word,
      vietnameseMeaning: vietnameseMeaning,
      imageAsset: imageAsset,
      storySentence: storySentence,
    );
  }
}

/// Extension to convert WordEntity to WordModel
extension WordEntityMapper on WordEntity {
  WordModel toModel() {
    return WordModel(
      letter: letter,
      word: word,
      vietnameseMeaning: vietnameseMeaning,
      imageAsset: imageAsset,
      storySentence: storySentence,
    );
  }
}

/// Extension to convert LessonModel to LessonEntity
extension LessonModelMapper on LessonModel {
  LessonEntity toEntity() {
    return LessonEntity(
      levelIndex: levelIndex,
      word: word.toEntity(),
    );
  }
}

/// Extension to convert LessonEntity to LessonModel
extension LessonEntityMapper on LessonEntity {
  LessonModel toModel() {
    return LessonModel(
      levelIndex: levelIndex,
      word: word.toModel(),
    );
  }
}

