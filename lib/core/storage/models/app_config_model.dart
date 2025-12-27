import 'package:isar_community/isar.dart';

part 'app_config_model.g.dart';

/// A minimal placeholder model to allow Isar database initialization.
/// This model can be used to store app-level configuration if needed.
@collection
class AppConfigModel {
  Id id = Isar.autoIncrement;

  /// Configuration key
  @Index()
  late String key;

  /// Configuration value (stored as string, can be parsed as needed)
  late String value;

  /// Timestamp when this config was created
  @Index()
  late DateTime createdAt;

  /// Timestamp when this config was last updated
  late DateTime updatedAt;

  AppConfigModel();

  AppConfigModel.create({required this.key, required this.value}) {
    final now = DateTime.now();
    createdAt = now;
    updatedAt = now;
  }

  void updateValue(String newValue) {
    value = newValue;
    updatedAt = DateTime.now();
  }
}
