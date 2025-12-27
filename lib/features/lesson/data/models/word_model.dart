/// Data model for a word/lesson item
/// Used for data transfer and storage
class WordModel {
  final String letter;
  final String word;
  final String vietnameseMeaning;
  final String imageAsset;
  final String storySentence;

  WordModel({
    required this.letter,
    required this.word,
    required this.vietnameseMeaning,
    required this.imageAsset,
    required this.storySentence,
  });

  /// Create from JSON/Map
  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      letter: map['letter'] as String,
      word: map['word'] as String,
      vietnameseMeaning: map['vietnameseMeaning'] as String,
      imageAsset: map['imageAsset'] as String,
      storySentence: map['storySentence'] as String,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'letter': letter,
      'word': word,
      'vietnameseMeaning': vietnameseMeaning,
      'imageAsset': imageAsset,
      'storySentence': storySentence,
    };
  }
}

