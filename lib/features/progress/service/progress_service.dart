import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:deutschly/core/Shared_preference_helper.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/data/models/lesson_progress.dart';

class ProgressService {
  ProgressService();

  static const String boxName = 'deutschly_progress_box';
  static const String storageKey = 'course_progress_v1';

  Box<dynamic>? _box;
  final Map<String, LessonProgress> _memoryCache = <String, LessonProgress>{};

  Future<void> init({Box<dynamic>? hiveBox}) async {
    if (hiveBox != null) {
      _box = hiveBox;
      return;
    }
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box<dynamic>(boxName);
      } else {
        _box = await Hive.openBox<dynamic>(boxName);
      }
    } catch (error, stackTrace) {
      ApiLogger.logError(
        'Hive box open fallback to SharedPreferences/memory',
        error,
        stackTrace,
      );
    }
  }

  Map<String, LessonProgress> loadAllProgress() {
    try {
      String? rawJson;
      if (_box != null && _box!.isOpen) {
        final dynamic boxVal = _box!.get(storageKey);
        if (boxVal is String) {
          rawJson = boxVal;
        } else if (boxVal is Map) {
          return _parseProgressMap(boxVal);
        }
      }
      rawJson ??= SharedPreferenceHelper.getString(storageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final decoded = jsonDecode(rawJson);
        if (decoded is Map) {
          final parsed = _parseProgressMap(decoded);
          _memoryCache
            ..clear()
            ..addAll(parsed);
          return Map<String, LessonProgress>.from(_memoryCache);
        }
      }
    } catch (error, stackTrace) {
      ApiLogger.logError('Failed to load progress', error, stackTrace);
    }
    return Map<String, LessonProgress>.from(_memoryCache);
  }

  Map<String, LessonProgress> _parseProgressMap(Map<dynamic, dynamic> rawMap) {
    final result = <String, LessonProgress>{};
    for (final MapEntry<dynamic, dynamic> entry in rawMap.entries) {
      final lessonId = entry.key.toString();
      final value = entry.value;
      if (value is Map) {
        result[lessonId] = LessonProgress.fromJson(value);
      }
    }
    return result;
  }

  Future<void> saveAllProgress(Map<String, LessonProgress> progressMap) async {
    _memoryCache
      ..clear()
      ..addAll(progressMap);

    final serializedMap = <String, dynamic>{
      for (final MapEntry<String, LessonProgress> entry in progressMap.entries)
        entry.key: entry.value.toJson(),
    };
    final encodedJson = jsonEncode(serializedMap);

    try {
      if (_box != null && _box!.isOpen) {
        await _box!.put(storageKey, encodedJson);
      }
    } catch (error, stackTrace) {
      ApiLogger.logError('Failed saving progress to Hive', error, stackTrace);
    }

    try {
      await SharedPreferenceHelper.setString(storageKey, encodedJson);
    } catch (_) {
      // Ignore if SharedPreferences plugin channel is unavailable in raw unit test
    }
  }

  Future<void> clearAllProgress() async {
    _memoryCache.clear();
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.delete(storageKey);
      }
    } catch (error, stackTrace) {
      ApiLogger.logError('Failed clearing Hive progress', error, stackTrace);
    }

    try {
      await SharedPreferenceHelper.setString(storageKey, '{}');
    } catch (_) {
      // Ignore if SharedPreferences plugin channel is unavailable in raw unit test
    }
  }
}
