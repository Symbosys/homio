import 'dart:io';
import 'package:flutter/foundation.dart';

/// Normalized permission result statuses across Web, Desktop, and Mobile.
enum PermissionResultStatus {
  /// The user granted access to the requested resource.
  granted,

  /// The user denied access to the requested resource.
  denied,

  /// The permission is permanently denied (user must enable it in app settings).
  permanentlyDenied,

  /// The permission is restricted by parental controls or device policy.
  restricted,

  /// Not applicable on platforms (Web / Desktop) where runtime OS prompts do not exist.
  notApplicable,
}

/// Abstract base class defining common platform detection and permission helpers.
abstract class BasePermission {
  /// Whether the app is currently running on the Web.
  static bool get isWeb => kIsWeb;

  /// Whether the app is running on a desktop platform (Windows, macOS, Linux).
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Whether the app is running on a mobile platform (Android or iOS).
  static bool get isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Helper to open device app settings if a permission is permanently denied.
  static Future<bool> openAppSettings() async {
    if (isMobile) {
      return await openAppSettings();
    }
    return false;
  }
}
