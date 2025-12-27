import 'package:isar_community/isar.dart';

part 'vocabulary_model.g.dart';

/// Isar model for vocabulary items
@collection
class VocabularyModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String modelId;

  late String word;
  late String meaning;
  late String imagePath;
  String? audioPath;

  VocabularyModel();

  VocabularyModel.create({
    required this.modelId,
    required this.word,
    required this.meaning,
    required this.imagePath,
    this.audioPath,
  });
}
