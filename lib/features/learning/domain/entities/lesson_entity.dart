import 'lesson_step_type.dart';
import 'vocabulary_entity.dart';

/// Domain entity for lessons
/// Pure Dart class without database dependencies
class LessonEntity {
  final String id;
  final String title;
  final int orderIndex;
  final bool isLocked;
  final bool isCompleted;
  final LessonStep currentStep;
  final List<VocabularyEntity> vocabularies;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.orderIndex,
    required this.isLocked,
    required this.isCompleted,
    required this.currentStep,
    this.vocabularies = const [],
  });

  /// Create a copy with some fields replaced
  LessonEntity copyWith({
    String? id,
    String? title,
    int? orderIndex,
    bool? isLocked,
    bool? isCompleted,
    LessonStep? currentStep,
    List<VocabularyEntity>? vocabularies,
  }) {
    return LessonEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      currentStep: currentStep ?? this.currentStep,
      vocabularies: vocabularies ?? this.vocabularies,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LessonEntity &&
        other.id == id &&
        other.title == title &&
        other.orderIndex == orderIndex &&
        other.isLocked == isLocked &&
        other.isCompleted == isCompleted &&
        other.currentStep == currentStep &&
        _listEquals(other.vocabularies, vocabularies);
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    orderIndex,
    isLocked,
    isCompleted,
    currentStep,
    Object.hashAll(vocabularies),
  );

  @override
  String toString() =>
      'LessonEntity(id: $id, title: $title, orderIndex: $orderIndex, isLocked: $isLocked, isCompleted: $isCompleted, currentStep: $currentStep, vocabularies: ${vocabularies.length} items)';

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
