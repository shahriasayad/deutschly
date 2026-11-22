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
    final box = _box;
    if (box != null && box.isOpen) {
      try {
        final dynamic storedValue = box.get(storageKey);
        final parsed = switch (storedValue) {
          Map<dynamic, dynamic>() => _parseProgressMap(storedValue),
          String value => _decodeProgress(value),
          _ => null,
        };
        if (parsed != null) {
          return _cacheProgress(parsed);
        }
      } catch (error, stackTrace) {
        ApiLogger.logError(
          'Failed to load progress from Hive',
          error,
          stackTrace,
        );
      }
    }

    try {
      final rawJson = SharedPreferenceHelper.getString(storageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final parsed = _decodeProgress(rawJson);
        if (parsed != null) {
          return _cacheProgress(parsed);
        }
      }
    } catch (error, stackTrace) {
      ApiLogger.logError(
        'Failed to load progress from SharedPreferences',
        error,
        stackTrace,
      );
    }
    return Map<String, LessonProgress>.from(_memoryCache);
  }

  Map<String, LessonProgress>? _decodeProgress(String rawJson) {
    final decoded = jsonDecode(rawJson);
    return decoded is Map ? _parseProgressMap(decoded) : null;
  }

  Map<String, LessonProgress> _cacheProgress(
    Map<String, LessonProgress> progress,
  ) {
    _memoryCache
      ..clear()
      ..addAll(progress);
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
