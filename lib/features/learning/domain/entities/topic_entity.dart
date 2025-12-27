import 'lesson_entity.dart';

/// Domain entity for topics
/// Pure Dart class without database dependencies
class TopicEntity {
  final String id;
  final String name;
  final String description;
  final String thumbnailPath;
  final int orderIndex;
  final bool isLocked;
  final bool isCompleted;
  final List<LessonEntity> lessons;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailPath,
    required this.orderIndex,
    required this.isLocked,
    required this.isCompleted,
    this.lessons = const [],
  });

  /// Create a copy with some fields replaced
  TopicEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailPath,
    int? orderIndex,
    bool? isLocked,
    bool? isCompleted,
    List<LessonEntity>? lessons,
  }) {
    return TopicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      orderIndex: orderIndex ?? this.orderIndex,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TopicEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.thumbnailPath == thumbnailPath &&
        other.orderIndex == orderIndex &&
        other.isLocked == isLocked &&
        other.isCompleted == isCompleted &&
        _listEquals(other.lessons, lessons);
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    thumbnailPath,
    orderIndex,
    isLocked,
    isCompleted,
    Object.hashAll(lessons),
  );

  @override
  String toString() =>
      'TopicEntity(id: $id, name: $name, description: $description, thumbnailPath: $thumbnailPath, orderIndex: $orderIndex, isLocked: $isLocked, isCompleted: $isCompleted, lessons: ${lessons.length} items)';

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
