import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';

enum ReviewRating {
  again,
  hard,
  good,
  easy;

  String get key => name;

  static ReviewRating? parse(String? raw) {
    for (final value in ReviewRating.values) {
      if (value.name == raw) {
        return value;
      }
    }
    return null;
  }
}

class VocabularyReviewCard {
  const VocabularyReviewCard({
    required this.wordKey,
    this.repetitions = 0,
    this.intervalDays = 0,
    this.easeFactor = 2.5,
    this.dueAt,
    this.lastReviewedAt,
    this.lapses = 0,
    this.totalReviews = 0,
    this.lastRating,
  });

  final String wordKey;
  final int repetitions;
  final int intervalDays;
  final double easeFactor;
  final DateTime? dueAt;
  final DateTime? lastReviewedAt;
  final int lapses;
  final int totalReviews;
  final ReviewRating? lastRating;

  bool isDueAt(DateTime now) {
    if (dueAt == null) {
      return true;
    }
    return !dueAt!.isAfter(now);
  }

  LearningStatus get learningStatus {
    if (totalReviews == 0) {
      return LearningStatus.unseen;
    }
    if (lastRating == ReviewRating.again ||
        (lapses > 0 && repetitions == 0) ||
        (easeFactor < 1.8 && repetitions < 2)) {
      return LearningStatus.struggling;
    }
    if ((repetitions >= 2 && intervalDays >= 6) ||
        (lastRating == ReviewRating.easy && intervalDays >= 4)) {
      return LearningStatus.mastered;
    }
    if (lastRating == ReviewRating.good && repetitions >= 1) {
      return LearningStatus.good;
    }
    return LearningStatus.learning;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wordKey': wordKey,
    'repetitions': repetitions,
    'intervalDays': intervalDays,
    'easeFactor': easeFactor,
    'dueAt': dueAt?.toIso8601String(),
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    'lapses': lapses,
    'totalReviews': totalReviews,
    'lastRating': lastRating?.key,
  };

  static VocabularyReviewCard? fromJson(
    String key,
    Map<dynamic, dynamic> json,
  ) {
    final rawDue = json['dueAt'];
    final rawLast = json['lastReviewedAt'];
    return VocabularyReviewCard(
      wordKey: (json['wordKey'] ?? key).toString(),
      repetitions: _readInt(json['repetitions']),
      intervalDays: _readInt(json['intervalDays']),
      easeFactor: _readDouble(json['easeFactor'], fallback: 2.5).clamp(1.3, 3.0),
      dueAt: rawDue is String ? DateTime.tryParse(rawDue) : null,
      lastReviewedAt: rawLast is String ? DateTime.tryParse(rawLast) : null,
      lapses: _readInt(json['lapses']),
      totalReviews: _readInt(json['totalReviews']),
      lastRating: ReviewRating.parse(json['lastRating']?.toString()),
    );
  }

  static int _readInt(dynamic value, {int fallback = 0}) {
    if (value is int && value >= 0) {
      return value;
    }
    final parsed = int.tryParse(value?.toString() ?? '');
    return parsed != null && parsed >= 0 ? parsed : fallback;
  }

  static double _readDouble(dynamic value, {double fallback = 2.5}) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class RandomVocabularyCardItem {
  const RandomVocabularyCardItem({
    required this.wordKey,
    required this.lessonId,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.item,
    required this.exampleDe,
    required this.exampleEn,
  });

  final String wordKey;
  final String lessonId;
  final int lessonNumber;
  final String lessonTitle;
  final VocabularyItem item;
  final String exampleDe;
  final String exampleEn;
}
