import 'package:flutter/foundation.dart';

abstract class BaseEndpoints {
  /// Base API URL dynamically resolving localhost vs emulator
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:4000/api/v1';
    }
    // Android emulator loops back to host via 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:4000/api/v1';
    }
    // Windows, macOS, iOS, Linux
    return 'http://localhost:4000/api/v1';
  }
}
