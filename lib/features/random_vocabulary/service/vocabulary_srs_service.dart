import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:deutschly/core/Shared_preference_helper.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/features/random_vocabulary/models/vocabulary_review_card.dart';

class VocabularySrsService {
  VocabularySrsService();

  static const String boxName = 'deutschly_srs_box';
  static const String storageKey = 'vocab_srs_v1';

  Box<dynamic>? _box;
  final Map<String, VocabularyReviewCard> _memoryCache =
      <String, VocabularyReviewCard>{};

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
        'SRS Hive box open fallback to SharedPreferences/memory',
        error,
        stackTrace,
      );
    }
  }

  Map<String, VocabularyReviewCard> loadAllCards() {
    final box = _box;
    if (box != null && box.isOpen) {
      try {
        final dynamic storedValue = box.get(storageKey);
        final parsed = switch (storedValue) {
          Map<dynamic, dynamic>() => _parseCardMap(storedValue),
          String value => _decodeCards(value),
          _ => null,
        };
        if (parsed != null) {
          return _cacheCards(parsed);
        }
      } catch (error, stackTrace) {
        ApiLogger.logError(
          'Failed to load SRS cards from Hive',
          error,
          stackTrace,
        );
      }
    }

    try {
      final rawJson = SharedPreferenceHelper.getString(storageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final parsed = _decodeCards(rawJson);
        if (parsed != null) {
          return _cacheCards(parsed);
        }
      }
    } catch (error, stackTrace) {
      ApiLogger.logError(
        'Failed to load SRS cards from SharedPreferences',
        error,
        stackTrace,
      );
    }

    return Map<String, VocabularyReviewCard>.from(_memoryCache);
  }

  Map<String, VocabularyReviewCard>? _decodeCards(String rawJson) {
    final decoded = jsonDecode(rawJson);
    return decoded is Map ? _parseCardMap(decoded) : null;
  }

  Map<String, VocabularyReviewCard> _cacheCards(
    Map<String, VocabularyReviewCard> cards,
  ) {
    _memoryCache
      ..clear()
      ..addAll(cards);
    return Map<String, VocabularyReviewCard>.from(_memoryCache);
  }

  Map<String, VocabularyReviewCard> _parseCardMap(
    Map<dynamic, dynamic> rawMap,
  ) {
    final result = <String, VocabularyReviewCard>{};
    for (final MapEntry<dynamic, dynamic> entry in rawMap.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is Map) {
        final card = VocabularyReviewCard.fromJson(key, value);
        if (card != null) {
          result[key] = card;
        }
      }
    }
    return result;
  }

  Future<void> saveAllCards(Map<String, VocabularyReviewCard> cards) async {
    _memoryCache
      ..clear()
      ..addAll(cards);

    final serialized = <String, dynamic>{
      for (final entry in cards.entries) entry.key: entry.value.toJson(),
    };
    final encoded = jsonEncode(serialized);

    try {
      if (_box != null && _box!.isOpen) {
        await _box!.put(storageKey, encoded);
      }
    } catch (error, stackTrace) {
      ApiLogger.logError('Failed saving SRS cards to Hive', error, stackTrace);
    }

    try {
      await SharedPreferenceHelper.setString(storageKey, encoded);
    } catch (_) {
      // Ignore if SharedPreferences plugin channel is unavailable in raw unit test
    }
  }

  Future<void> clearAllCards() async {
    _memoryCache.clear();
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.delete(storageKey);
      }
    } catch (error, stackTrace) {
      ApiLogger.logError(
        'Failed clearing Hive SRS cards',
        error,
        stackTrace,
      );
    }

    try {
      await SharedPreferenceHelper.setString(storageKey, '{}');
    } catch (_) {
      // Ignore if SharedPreferences plugin channel is unavailable in raw unit test
    }
  }
}
