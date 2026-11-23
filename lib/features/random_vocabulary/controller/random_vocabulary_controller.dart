import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/random_vocabulary/models/vocabulary_review_card.dart';
import 'package:deutschly/features/random_vocabulary/service/vocabulary_example_service.dart';
import 'package:deutschly/features/random_vocabulary/service/vocabulary_srs_algorithm.dart';
import 'package:deutschly/features/random_vocabulary/service/vocabulary_srs_service.dart';

class RandomVocabularyController extends GetxController {
  RandomVocabularyController({
    VocabularySrsService? srsService,
    CourseController? courseController,
    Random? random,
  }) : _srsService = srsService ?? VocabularySrsService(),
       _courseController = courseController ?? Get.find<CourseController>(),
       _random = random ?? Random();

  final VocabularySrsService _srsService;
  final CourseController _courseController;
  final Random _random;

  final RxMap<String, VocabularyReviewCard> cardsByKey =
      <String, VocabularyReviewCard>{}.obs;
  final RxList<String> sessionQueue = <String>[].obs;
  final RxInt currentQueueIndex = 0.obs;
  final RxBool isCardFlipped = false.obs;
  final RxInt sessionReviewedCount = 0.obs;
  final RxBool isPracticeAheadSession = false.obs;

  static String normalizeWordKey(String wordDe) =>
      wordDe.trim().toLowerCase();

  @override
  void onInit() {
    super.onInit();
    loadCards();
    startSession();
  }

  void loadCards() {
    cardsByKey.assignAll(_srsService.loadAllCards());
  }

  /// Deduplicated vocabulary pool sourced across all lessons in the course.
  List<RandomVocabularyCardItem> get uniqueVocabularyPool {
    final lessons =
        _courseController.course.value?.lessons ?? const <Lesson>[];
    final seen = <String>{};
    final pool = <RandomVocabularyCardItem>[];

    for (final Lesson lesson in lessons) {
      for (final VocabularyItem item in lesson.vocabulary) {
        final key = normalizeWordKey(item.de);
        if (key.isEmpty || !seen.add(key)) {
          continue;
        }
        final example = VocabularyExampleService.resolve(item);
        pool.add(
          RandomVocabularyCardItem(
            wordKey: key,
            lessonId: lesson.id,
            lessonNumber: lesson.number,
            lessonTitle: lesson.title,
            item: item,
            exampleDe: example.de,
            exampleEn: example.en,
          ),
        );
      }
    }
    return pool;
  }

  Map<String, RandomVocabularyCardItem> get _poolByKey =>
      <String, RandomVocabularyCardItem>{
        for (final item in uniqueVocabularyPool) item.wordKey: item,
      };

  VocabularyReviewCard getCardForWord(String wordKey) {
    return cardsByKey[wordKey] ?? VocabularyReviewCard(wordKey: wordKey);
  }

  LearningStatus getStatusForWord(String wordDe) {
    final key = normalizeWordKey(wordDe);
    return getCardForWord(key).learningStatus;
  }

  int get totalUniqueWords => uniqueVocabularyPool.length;

  int getDueCount({DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    return uniqueVocabularyPool.where((RandomVocabularyCardItem item) {
      final card = cardsByKey[item.wordKey];
      return card != null && card.totalReviews > 0 && card.isDueAt(currentTime);
    }).length;
  }

  int get unseenCount => uniqueVocabularyPool.where((item) {
    final card = cardsByKey[item.wordKey];
    return card == null || card.totalReviews == 0;
  }).length;

  int get strugglingCount => uniqueVocabularyPool.where((item) {
    return getCardForWord(item.wordKey).learningStatus ==
        LearningStatus.struggling;
  }).length;

  int get learningCount => uniqueVocabularyPool.where((item) {
    final status = getCardForWord(item.wordKey).learningStatus;
    return status == LearningStatus.learning || status == LearningStatus.good;
  }).length;

  int get masteredCount => uniqueVocabularyPool.where((item) {
    return getCardForWord(item.wordKey).learningStatus ==
        LearningStatus.mastered;
  }).length;

  RandomVocabularyCardItem? get currentCardItem {
    if (currentQueueIndex.value >= sessionQueue.length) {
      return null;
    }
    final key = sessionQueue[currentQueueIndex.value];
    return _poolByKey[key];
  }

  VocabularyReviewCard? get currentReviewCard {
    final item = currentCardItem;
    if (item == null) {
      return null;
    }
    return getCardForWord(item.wordKey);
  }

  bool get isSessionComplete =>
      sessionQueue.isEmpty || currentQueueIndex.value >= sessionQueue.length;

  void startSession({
    bool includePracticeAhead = false,
    DateTime? now,
  }) {
    unawaited(GermanPronunciationPlayer.stop());
    final poolKeys = uniqueVocabularyPool
        .map((RandomVocabularyCardItem item) => item.wordKey)
        .toList(growable: false);
    final queue = VocabularySrsAlgorithm.buildSessionQueue(
      allWordKeys: poolKeys,
      cardsByKey: cardsByKey,
      now: now ?? DateTime.now(),
      includePracticeAhead: includePracticeAhead,
      random: _random,
    );
    sessionQueue.assignAll(queue);
    currentQueueIndex.value = 0;
    isCardFlipped.value = false;
    sessionReviewedCount.value = 0;
    isPracticeAheadSession.value = includePracticeAhead;
  }

  void flipCard() {
    if (!isCardFlipped.value) {
      isCardFlipped.value = true;
    }
  }

  String previewInterval(ReviewRating rating) {
    final card = currentReviewCard;
    if (card == null) {
      return '';
    }
    return VocabularySrsAlgorithm.previewIntervalLabel(
      current: card,
      rating: rating,
    );
  }

  Future<void> rateCurrentCard(
    ReviewRating rating, {
    DateTime? now,
  }) async {
    final item = currentCardItem;
    if (item == null) {
      return;
    }

    await GermanPronunciationPlayer.stop();

    final current = getCardForWord(item.wordKey);
    final updated = VocabularySrsAlgorithm.scheduleReview(
      current: current,
      rating: rating,
      now: now ?? DateTime.now(),
    );
    cardsByKey[item.wordKey] = updated;
    await _srsService.saveAllCards(
      Map<String, VocabularyReviewCard>.from(cardsByKey),
    );

    sessionReviewedCount.value += 1;

    // Re-queue forgotten words ("Again") later in the same session for
    // immediate active recall, provided there are other cards remaining.
    if (rating == ReviewRating.again) {
      final remaining = sessionQueue.length - (currentQueueIndex.value + 1);
      if (remaining > 0) {
        final insertIndex = min(
          currentQueueIndex.value + 4,
          sessionQueue.length,
        );
        sessionQueue.insert(insertIndex, item.wordKey);
      }
    }

    currentQueueIndex.value += 1;
    isCardFlipped.value = false;
  }

  Future<void> resetAllSrsData() async {
    await GermanPronunciationPlayer.stop();
    cardsByKey.clear();
    await _srsService.clearAllCards();
    startSession();
  }

  @override
  void onClose() {
    unawaited(GermanPronunciationPlayer.stop());
    super.onClose();
  }
}
