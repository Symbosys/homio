import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'base_permission.dart';

/// Dedicated permission handler for device gallery / photo library.
///
/// Designed to work seamlessly across Web, Desktop (Windows, macOS, Linux), and Mobile (Android, iOS).
class GalleryPermission {
  /// Request gallery / photos access.
  ///
  /// Returns `true` if access is granted (or on Web/Desktop where runtime prompts are not required).
  /// Returns `false` if the user denied access.
  static Future<bool> request() async {
    // 1. Web: Browser file inputs handle file selection natively without OS permission prompts
    if (kIsWeb) {
      return true;
    }

    // 2. Desktop: Native OS file pickers do not require mobile runtime permission
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return true;
    }

    // 3. Mobile (Android & iOS)
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted || status.isLimited;
    }

    if (Platform.isAndroid) {
      // Android 13+ (API 33+) uses READ_MEDIA_IMAGES (Permission.photos)
      var status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        return true;
      }

      // Android 12 and below fallback: uses READ_EXTERNAL_STORAGE (Permission.storage)
      if (status.isDenied || status.isPermanentlyDenied) {
        final storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted || storageStatus.isLimited) {
          return true;
        }
      }

      return false;
    }

    return true;
  }

  /// Get the current permission status without prompting the user.
  static Future<PermissionResultStatus> getStatus() async {
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return PermissionResultStatus.notApplicable;
    }

    PermissionStatus status;
    if (Platform.isIOS) {
      status = await Permission.photos.status;
    } else {
      status = await Permission.photos.status;
      if (!status.isGranted && !status.isLimited) {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted || storageStatus.isLimited) {
          status = storageStatus;
        }
      }
    }

    if (status.isGranted || status.isLimited) {
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

  /// Open device app settings if the user previously selected "Don't ask again" / permanently denied.
  static Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
