import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:deutschly/core/api_logger.dart';

class ApiClient {
  const ApiClient({this.assetBundle});

  final AssetBundle? assetBundle;

  Future<Map<String, dynamic>> loadJsonAsset(String assetPath) async {
    try {
      final bundle = assetBundle ?? rootBundle;
      final rawJson = await bundle.loadString(assetPath);
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected top-level JSON object.');
      }
      return decoded;
    } catch (error, stackTrace) {
      ApiLogger.logError('Failed to load JSON asset: $assetPath', error, stackTrace);
      rethrow;
    }
  }
}
