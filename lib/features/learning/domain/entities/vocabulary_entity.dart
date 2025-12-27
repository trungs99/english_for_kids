/// Domain entity for vocabulary items
/// Pure Dart class without database dependencies
class VocabularyEntity {
  final String id;
  final String word;
  final String meaning;
  final String imagePath;
  final String? audioPath;

  const VocabularyEntity({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imagePath,
    this.audioPath,
  });

  /// Create a copy with some fields replaced
  VocabularyEntity copyWith({
    String? id,
    String? word,
    String? meaning,
    String? imagePath,
    String? audioPath,
  }) {
    return VocabularyEntity(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VocabularyEntity &&
        other.id == id &&
        other.word == word &&
        other.meaning == meaning &&
        other.imagePath == imagePath &&
        other.audioPath == audioPath;
  }

  @override
  int get hashCode => Object.hash(id, word, meaning, imagePath, audioPath);

  @override
  String toString() =>
      'VocabularyEntity(id: $id, word: $word, meaning: $meaning, imagePath: $imagePath, audioPath: $audioPath)';
}
