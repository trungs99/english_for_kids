import 'dart:io';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:english_for_kids/core/exceptions/storage_error.dart';
import 'package:exo_shared/exo_shared.dart';

class IsarService extends GetxService {
  late Isar _isar;
  Isar get isar => _isar;

  /// Initializes the Isar database.
  /// If the database fails to open (e.g., corruption), it attempts recovery
  /// by deleting existing Isar files and retrying.
  Future<IsarService> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();

      try {
        _isar = await Isar.open(
          [], // Schemas will be added here
          directory: dir.path,
        );
      } catch (e) {
        // Critical: Implement a try-catch mechanism. If opening the database fails (e.g., due to corruption),
        // call a _recoverFromCorruption method to delete the old files and attempt to open it again.
        LoggerUtil.error(
          'Failed to open Isar database, attempting recovery',
          e,
        );
        await _recoverFromCorruption(dir.path);

        // Retry opening after recovery
        _isar = await Isar.open([], directory: dir.path);
      }

      await _performMigration();
      await _verifyDataIntegrity();

      LoggerUtil.info('IsarService initialized successfully');
      return this;
    } catch (e) {
      LoggerUtil.error('IsarService initialization failed', e);
      throw StorageError('Failed to initialize Isar database', e);
    }
  }

  /// Deletes all .isar files in the given directory to recover from corruption.
  Future<void> _recoverFromCorruption(String path) async {
    LoggerUtil.info('Recovering from database corruption at $path');
    try {
      final dir = Directory(path);
      if (await dir.exists()) {
        final files = dir.listSync();
        for (final file in files) {
          if (file is File && file.path.endsWith('.isar')) {
            await file.delete();
          }
        }
        LoggerUtil.info('Deleted potentially corrupted Isar files');
      }
    } catch (e) {
      LoggerUtil.error('Failed to delete corrupted files during recovery', e);
      // We don't throw here, the next Isar.open attempt will likely fail and be caught by the outer catch.
    }
  }

  Future<void> _performMigration() async {
    // TODO: Implement migration logic when schemas change
    LoggerUtil.debug('Performing Isar migration (placeholder)');
  }

  Future<void> _verifyDataIntegrity() async {
    // TODO: Implement data integrity verification if needed
    LoggerUtil.debug('Verifying data integrity (placeholder)');
  }
}
