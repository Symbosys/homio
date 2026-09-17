import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'base_permission.dart';

/// Dedicated permission handler for push and local notifications.
///
/// Scaffolded for future notification workflows across all devices.
class NotificationPermission {
  /// Request notification permission.
  ///
  /// Returns `true` if granted, or on Web/Desktop.
  static Future<bool> request() async {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return true;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }

    return true;
  }

  /// Check current notification permission status.
  static Future<PermissionResultStatus> getStatus() async {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return PermissionResultStatus.notApplicable;
    }

    final status = await Permission.notification.status;
    if (status.isGranted) {
      return PermissionResultStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return PermissionResultStatus.permanentlyDenied;
    }
    if (status.isRestricted) {
      return PermissionResultStatus.restricted;
    }
    return PermissionResultStatus.denied;
  }

  /// Open device app settings.
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
