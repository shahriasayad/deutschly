import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/random_vocabulary/controller/random_vocabulary_controller.dart';
import 'package:deutschly/features/random_vocabulary/models/vocabulary_review_card.dart';
import 'package:deutschly/features/random_vocabulary/service/vocabulary_srs_algorithm.dart';
import 'package:deutschly/features/random_vocabulary/service/vocabulary_srs_service.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';
import 'package:deutschly/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(Get.reset);

  test('SM-2 scheduler handles Again, Hard, Good, Easy and queue priority', () {
    final baseTime = DateTime.utc(2026, 11, 23, 10, 0);
    const initial = VocabularyReviewCard(wordKey: 'hallo');
    expect(initial.learningStatus, LearningStatus.unseen);

    final afterAgain = VocabularySrsAlgorithm.scheduleReview(
      current: initial,
      rating: ReviewRating.again,
      now: baseTime,
    );
    expect(afterAgain.repetitions, 0);
    expect(afterAgain.lapses, 1);
    expect(afterAgain.easeFactor, lessThan(2.5));
    expect(afterAgain.learningStatus, LearningStatus.struggling);
    expect(afterAgain.dueAt, baseTime.add(const Duration(minutes: 1)));

    final afterHard = VocabularySrsAlgorithm.scheduleReview(
      current: initial,
      rating: ReviewRating.hard,
      now: baseTime,
    );
    expect(afterHard.repetitions, 1);
    expect(afterHard.learningStatus, LearningStatus.learning);
    expect(afterHard.dueAt, baseTime.add(const Duration(hours: 12)));

    final afterGood1 = VocabularySrsAlgorithm.scheduleReview(
      current: initial,
      rating: ReviewRating.good,
      now: baseTime,
    );
    expect(afterGood1.intervalDays, 1);
    expect(afterGood1.learningStatus, LearningStatus.good);

    final afterGood2 = VocabularySrsAlgorithm.scheduleReview(
      current: afterGood1,
      rating: ReviewRating.good,
      now: baseTime.add(const Duration(days: 1)),
    );
    expect(afterGood2.intervalDays, 6);
    expect(afterGood2.learningStatus, LearningStatus.mastered);

    final afterEasy = VocabularySrsAlgorithm.scheduleReview(
      current: initial,
      rating: ReviewRating.easy,
      now: baseTime,
    );
    expect(afterEasy.intervalDays, 4);
    expect(afterEasy.easeFactor, greaterThan(2.5));
    expect(afterEasy.learningStatus, LearningStatus.mastered);

    // Queue prioritization: due struggling word comes before unseen words
    final queue = VocabularySrsAlgorithm.buildSessionQueue(
      allWordKeys: const <String>['new_1', 'hallo', 'new_2'],
      cardsByKey: <String, VocabularyReviewCard>{
        'hallo': afterAgain,
      },
      now: baseTime.add(const Duration(minutes: 5)),
      random: Random(42),
    );
    expect(queue.first, 'hallo');
  });

  test(
    'RandomVocabularyController deduplicates across all lessons and persists SRS data in Hive',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'deutschly_srs_test',
      );
      Hive.init(tempDir.path);
      final box = await Hive.openBox<dynamic>('test_srs_box');

      const repository = CourseRepository();
      final course = await repository.loadCourse();
      final courseController = Get.put(
        CourseController(repository: repository, initialCourse: course),
      );

      final srsService1 = VocabularySrsService();
      await srsService1.init(hiveBox: box);
      final controller1 = RandomVocabularyController(
        srsService: srsService1,
        courseController: courseController,
        random: Random(7),
      )..onInit();

      // 407 total entries in JSON -> 396 unique German words
      expect(controller1.totalUniqueWords, 396);
      expect(
        controller1.uniqueVocabularyPool.every(
          (item) => item.exampleDe.isNotEmpty && item.exampleEn.isNotEmpty,
        ),
        isTrue,
      );

      final firstWord = controller1.currentCardItem!;
      await controller1.rateCurrentCard(
        ReviewRating.easy,
        now: DateTime.utc(2026, 11, 23, 12, 0),
      );
      expect(controller1.masteredCount, 1);

      // Simulate app restart
      final srsService2 = VocabularySrsService();
      await srsService2.init(hiveBox: box);
      final controller2 = RandomVocabularyController(
        srsService: srsService2,
        courseController: courseController,
        random: Random(7),
      )..onInit();

      expect(controller2.masteredCount, 1);
      expect(
        controller2.getStatusForWord(firstWord.item.de),
        LearningStatus.mastered,
      );
      expect(
        controller2.getCardForWord(firstWord.wordKey).lastRating,
        ReviewRating.easy,
      );

      await box.close();
      await tempDir.delete(recursive: true);
    },
  );

  testWidgets(
    'RandomVocabularyScreen flips card, reveals translations & example, and updates mastery',
    (WidgetTester tester) async {
      const repository = CourseRepository();
      final Course? course = await tester.runAsync(
        () => repository.loadCourse(),
      );
      expect(course, isNotNull);

      final courseController = Get.put(
        CourseController(repository: repository, initialCourse: course),
      );
      final progressController = Get.put(
        ProgressController(courseController: courseController),
      );
      Get.put(
        HomeController(
          courseController: courseController,
          progressController: progressController,
        ),
      );
      Get.put(
        VocabularyController(
          courseController: courseController,
          progressController: progressController,
        ),
      );
      final srsController = Get.put(
        RandomVocabularyController(
          courseController: courseController,
          random: Random(11),
        ),
      );

      await tester.pumpWidget(const DeutschlyApp());
      await tester.pumpAndSettle();

      // Open Random Vocabulary from HomeScreen
      final homeCard = find.byKey(
        const ValueKey<String>('home_random_vocab_card'),
      );
      await tester.ensureVisible(homeCard);
      await tester.tap(homeCard);
      await tester.pumpAndSettle();

      expect(find.text('Random Vocabulary'), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('random_vocab_word_audio_btn')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('random_vocab_reveal_btn')),
        findsOneWidget,
      );
      expect(find.text('Example Sentence'), findsNothing);

      // Flip card
      await tester.tap(
        find.byKey(const ValueKey<String>('random_vocab_reveal_btn')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Example Sentence'), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('random_vocab_example_audio_btn')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey<String>('srs_rate_again')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('srs_rate_hard')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('srs_rate_good')), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('srs_rate_easy')), findsOneWidget);

      // Rate as Easy -> mastered count becomes 1
      await tester.tap(find.byKey(const ValueKey<String>('srs_rate_easy')));
      await tester.pumpAndSettle();

      expect(srsController.masteredCount, 1);
      expect(find.text('Mastered: 1'), findsOneWidget);
      expect(find.text('Reviewed: 1'), findsOneWidget);

      // Navigate back and check ProgressScreen shows Vocabulary Mastery
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      expect(find.text('Vocabulary Mastery'), findsOneWidget);
      expect(find.text('Mastered: 1'), findsOneWidget);
    },
  );
}
