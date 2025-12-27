import 'package:flutter/foundation.dart';

/// Domain entity for vocabulary items
/// Pure Dart class without database dependencies
class VocabularyEntity {
  final String id;
  final String word;
  final String meaning;
  final String imagePath;
  final String? audioPath;
  final List<String> allowedLabels;

  const VocabularyEntity({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imagePath,
    this.audioPath,
    this.allowedLabels = const [],
  });

  /// Create a copy with some fields replaced
  VocabularyEntity copyWith({
    String? id,
    String? word,
    String? meaning,
    String? imagePath,
    String? audioPath,
    List<String>? allowedLabels,
  }) {
    return VocabularyEntity(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      allowedLabels: allowedLabels ?? this.allowedLabels,
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
        other.audioPath == audioPath &&
        listEquals(other.allowedLabels, allowedLabels);
  }

  @override
  int get hashCode => Object.hash(
    id,
    word,
    meaning,
    imagePath,
    audioPath,
    Object.hashAll(allowedLabels),
  );

  @override
  String toString() =>
      'VocabularyEntity(id: $id, word: $word, meaning: $meaning, imagePath: $imagePath, audioPath: $audioPath, allowedLabels: $allowedLabels)';
}
