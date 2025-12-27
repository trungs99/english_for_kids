import 'package:permission_handler/permission_handler.dart' as handler;

/// Service for handling camera permissions
class PermissionService {
  /// Request camera permission
  /// Returns true if granted, false otherwise
  static Future<bool> requestCameraPermission() async {
    final status = await handler.Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await handler.Permission.camera.status;
    return status.isGranted;
  }

  /// Open app settings if permission is permanently denied
  static Future<bool> openAppSettings() async {
    return await handler.openAppSettings();
  }
}

