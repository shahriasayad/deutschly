import 'package:flutter/foundation.dart';

class ApiLogger {
  const ApiLogger._();

  static void logInfo(String message) {
    debugPrint('[INFO] $message');
  }

  static void logError(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) {
      debugPrint('Error details: $error');
    }
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }
}
