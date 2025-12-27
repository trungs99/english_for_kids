/// Domain entity for a word/lesson item
/// Pure Dart class without database dependencies
class WordEntity {
  final String letter;
  final String word;
  final String vietnameseMeaning;
  final String imageAsset;
  final String storySentence;

  const WordEntity({
    required this.letter,
    required this.word,
    required this.vietnameseMeaning,
    required this.imageAsset,
    required this.storySentence,
  });

  /// Create a copy with some fields replaced
  WordEntity copyWith({
    String? letter,
    String? word,
    String? vietnameseMeaning,
    String? imageAsset,
    String? storySentence,
  }) {
    return WordEntity(
      letter: letter ?? this.letter,
      word: word ?? this.word,
      vietnameseMeaning: vietnameseMeaning ?? this.vietnameseMeaning,
      imageAsset: imageAsset ?? this.imageAsset,
      storySentence: storySentence ?? this.storySentence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordEntity &&
        other.letter == letter &&
        other.word == word &&
        other.vietnameseMeaning == vietnameseMeaning &&
        other.imageAsset == imageAsset &&
        other.storySentence == storySentence;
  }

  @override
  int get hashCode => Object.hash(
        letter,
        word,
        vietnameseMeaning,
        imageAsset,
        storySentence,
      );

  @override
  String toString() =>
      'WordEntity(letter: $letter, word: $word, vietnameseMeaning: $vietnameseMeaning)';
}

