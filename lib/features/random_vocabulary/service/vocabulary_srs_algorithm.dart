import 'dart:math';

import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/features/random_vocabulary/models/vocabulary_review_card.dart';

/// SM-2 based spaced-repetition scheduler for vocabulary cards.
class VocabularySrsAlgorithm {
  const VocabularySrsAlgorithm._();

  static const double minEaseFactor = 1.3;
  static const double maxEaseFactor = 3.0;
  static const double defaultEaseFactor = 2.5;

  /// Computes the updated [VocabularyReviewCard] after a user rates recall.
  static VocabularyReviewCard scheduleReview({
    required VocabularyReviewCard current,
    required ReviewRating rating,
    required DateTime now,
  }) {
    var repetitions = current.repetitions;
    var intervalDays = current.intervalDays;
    var easeFactor = current.easeFactor;
    var lapses = current.lapses;
    late final DateTime nextDue;

    switch (rating) {
      case ReviewRating.again:
        repetitions = 0;
        intervalDays = 0;
        easeFactor = (easeFactor - 0.20).clamp(minEaseFactor, maxEaseFactor);
        lapses += 1;
        nextDue = now.add(const Duration(minutes: 1));
      case ReviewRating.hard:
        easeFactor = (easeFactor - 0.15).clamp(minEaseFactor, maxEaseFactor);
        if (repetitions == 0) {
          intervalDays = 0;
          nextDue = now.add(const Duration(hours: 12));
        } else {
          intervalDays = max(1, (intervalDays * 1.2).round());
          nextDue = now.add(Duration(days: intervalDays));
        }
        repetitions += 1;
      case ReviewRating.good:
        if (repetitions == 0) {
          intervalDays = 1;
        } else if (repetitions == 1) {
          intervalDays = 6;
        } else {
          intervalDays = max(
            intervalDays + 1,
            (intervalDays * easeFactor).round(),
          );
        }
        repetitions += 1;
        nextDue = now.add(Duration(days: intervalDays));
      case ReviewRating.easy:
        easeFactor = (easeFactor + 0.15).clamp(minEaseFactor, maxEaseFactor);
        if (repetitions == 0) {
          intervalDays = 4;
        } else if (repetitions == 1) {
          intervalDays = 10;
        } else {
          intervalDays = max(
            intervalDays + 2,
            (intervalDays * easeFactor * 1.3).round(),
          );
        }
        repetitions += 1;
        nextDue = now.add(Duration(days: intervalDays));
    }

    return VocabularyReviewCard(
      wordKey: current.wordKey,
      repetitions: repetitions,
      intervalDays: intervalDays,
      easeFactor: easeFactor,
      dueAt: nextDue,
      lastReviewedAt: now,
      lapses: lapses,
      totalReviews: current.totalReviews + 1,
      lastRating: rating,
    );
  }

  /// Human-readable next interval preview shown on rating buttons.
  static String previewIntervalLabel({
    required VocabularyReviewCard current,
    required ReviewRating rating,
  }) {
    final now = DateTime.utc(2026, 1, 1);
    final next = scheduleReview(current: current, rating: rating, now: now);
    final diff = next.dueAt!.difference(now);
    if (diff.inMinutes < 60) {
      return '${max(1, diff.inMinutes)}m';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h';
    }
    return '${diff.inDays}d';
  }

  /// Builds a randomized, priority-ordered study queue:
  /// 1. Due struggling cards (shuffled)
  /// 2. Other due cards (shuffled within overdue/ease tiers)
  /// 3. Unseen cards (shuffled, up to [maxNewCards] per session)
  /// If nothing is due or unseen and [includePracticeAhead] is true, returns
  /// cards ordered by lowest ease / soonest due with shuffling.
  static List<String> buildSessionQueue({
    required List<String> allWordKeys,
    required Map<String, VocabularyReviewCard> cardsByKey,
    required DateTime now,
    int maxNewCards = 15,
    bool includePracticeAhead = false,
    Random? random,
  }) {
    final rng = random ?? Random();
    final dueStruggling = <String>[];
    final dueOther = <String>[];
    final unseen = <String>[];
    final future = <String>[];

    for (final key in allWordKeys) {
      final card = cardsByKey[key];
      if (card == null || card.totalReviews == 0) {
        unseen.add(key);
      } else if (card.isDueAt(now)) {
        if (card.learningStatus == LearningStatus.struggling) {
          dueStruggling.add(key);
        } else {
          dueOther.add(key);
        }
      } else {
        future.add(key);
      }
    }

    dueStruggling.shuffle(rng);
    dueOther.shuffle(rng);
    unseen.shuffle(rng);

    final selectedNew = unseen.take(maxNewCards).toList();

    // Interleave due cards and new cards lightly so sessions feel dynamic
    // while still prioritizing struggling & due cards first.
    final queue = <String>[...dueStruggling];
    var dueIdx = 0;
    var newIdx = 0;
    while (dueIdx < dueOther.length || newIdx < selectedNew.length) {
      for (var i = 0; i < 2 && dueIdx < dueOther.length; i++) {
        queue.add(dueOther[dueIdx++]);
      }
      if (newIdx < selectedNew.length) {
        queue.add(selectedNew[newIdx++]);
      }
    }

    if (queue.isEmpty && includePracticeAhead && future.isNotEmpty) {
      future.sort((String a, String b) {
        final cardA = cardsByKey[a]!;
        final cardB = cardsByKey[b]!;
        final easeCompare = cardA.easeFactor.compareTo(cardB.easeFactor);
        if (easeCompare != 0) {
          return easeCompare;
        }
        return (cardA.dueAt ?? now).compareTo(cardB.dueAt ?? now);
      });
      final pool = future.take(20).toList()..shuffle(rng);
      queue.addAll(pool);
    }

    return queue;
  }
}
