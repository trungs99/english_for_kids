/// Constants for topic items used in initial data seeding.
/// 
/// These constants define the topic data that will be seeded into the database
/// on first launch. All 3 topics share the same 5 lessons (A-E).
class TopicConstants {
  /// Topic: Khởi động (Warm-up)
  /// 
  /// First topic in the sequence (orderIndex 0), unlocked by default.
  /// Contains all 5 shared lessons (A-E).
  static const khoiDong = (
    id: 'topic_khoi_dong',
    name: 'Khởi động',
    description: 'Khởi động với những từ vựng cơ bản',
    thumbnailPath: 'assets/images/learning/lession_1/img_apple.png',
    orderIndex: 0,
    lessonIds: [
      'lesson_a',
      'lesson_b',
      'lesson_c',
      'lesson_d',
      'lesson_e',
    ],
  );

  /// Topic: Chào hỏi (Greetings)
  /// 
  /// Second topic in the sequence (orderIndex 1), locked by default.
  /// Contains all 5 shared lessons (A-E).
  static const chaoHoi = (
    id: 'topic_chao_hoi',
    name: 'Chào hỏi',
    description: 'Học cách chào hỏi và giao tiếp cơ bản',
    thumbnailPath: 'assets/images/learning/lession_1/img_apple.png',
    orderIndex: 1,
    lessonIds: [
      'lesson_a',
      'lesson_b',
      'lesson_c',
      'lesson_d',
      'lesson_e',
    ],
  );

  /// Topic: Gia đình (Family)
  /// 
  /// Third topic in the sequence (orderIndex 2), locked by default.
  /// Contains all 5 shared lessons (A-E).
  static const giaDinh = (
    id: 'topic_gia_dinh',
    name: 'Gia đình',
    description: 'Tìm hiểu về các thành viên trong gia đình',
    thumbnailPath: 'assets/images/learning/lession_1/img_apple.png',
    orderIndex: 2,
    lessonIds: [
      'lesson_a',
      'lesson_b',
      'lesson_c',
      'lesson_d',
      'lesson_e',
    ],
  );

  /// List of all topic constants
  static const all = [
    khoiDong,
    chaoHoi,
    giaDinh,
  ];
}

