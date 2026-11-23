import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';
import 'package:deutschly/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(Get.reset);

  test(
    'Hard vocabulary selections persist per lesson in Hive and reload after restart',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'deutschly_hard_vocab_test',
      );
      Hive.init(tempDir.path);
      final box = await Hive.openBox<dynamic>('test_hard_vocab_box');

      final service1 = ProgressService();
      await service1.init(hiveBox: box);

      const repository = CourseRepository();
      final course = await repository.loadCourse();
      final courseController = Get.put(
        CourseController(repository: repository, initialCourse: course),
      );

      final progress1 = ProgressController(
        progressService: service1,
        courseController: courseController,
      )..loadProgress();

      await progress1.setWordHard(
        lessonId: 'lesson_01',
        wordDe: 'Guten Morgen',
        isHard: true,
      );
      await progress1.setWordHard(
        lessonId: 'lesson_02',
        wordDe: 'die Familie',
        isHard: true,
      );

      expect(progress1.isWordHard('lesson_01', 'Guten Morgen'), isTrue);
      expect(progress1.isWordHard('lesson_02', 'Guten Morgen'), isFalse);
      expect(progress1.isWordHard('lesson_02', 'die Familie'), isTrue);

      // Simulate app restart
      final service2 = ProgressService();
      await service2.init(hiveBox: box);
      final progress2 = ProgressController(
        progressService: service2,
        courseController: courseController,
      )..loadProgress();

      expect(
        progress2.getHardWords('lesson_01'),
        equals(<String>{'Guten Morgen'}),
      );
      expect(
        progress2.getHardWords('lesson_02'),
        equals(<String>{'die Familie'}),
      );

      // Unselect a word
      await progress2.toggleWordHard(
        lessonId: 'lesson_01',
        wordDe: 'Guten Morgen',
      );
      expect(progress2.getHardWords('lesson_01'), isEmpty);

      final service3 = ProgressService();
      await service3.init(hiveBox: box);
      final progress3 = ProgressController(
        progressService: service3,
        courseController: courseController,
      )..loadProgress();

      expect(progress3.getHardWords('lesson_01'), isEmpty);
      expect(
        progress3.getHardWords('lesson_02'),
        equals(<String>{'die Familie'}),
      );

      await box.close();
      await tempDir.delete(recursive: true);
    },
  );

  testWidgets(
    'Hard Vocabulary works under each lesson Words tab and stays synchronized with VocabularyScreen',
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

      await tester.pumpWidget(const DeutschlyApp());
      await tester.pumpAndSettle();

      // Open Lesson 1 -> Words tab
      final lesson1Card = find.byKey(const ValueKey<String>('lesson_01'));
      await tester.ensureVisible(lesson1Card);
      await tester.tap(lesson1Card);
      await tester.pumpAndSettle();

      final wordsTab = find.byKey(const ValueKey<String>('lesson_tab_words'));
      await tester.ensureVisible(wordsTab);
      await tester.tap(wordsTab);
      await tester.pumpAndSettle();

      expect(find.text('Hard Vocabulary (0)'), findsOneWidget);

      // Mark "Guten Morgen" as hard in Lesson 1
      final l1WordBtn = find.byKey(
        const ValueKey<String>('lesson_word_hard_lesson_01_Guten Morgen'),
      );
      await tester.ensureVisible(l1WordBtn);
      await tester.tap(l1WordBtn);
      await tester.pumpAndSettle();

      expect(find.text('Hard Vocabulary (1)'), findsOneWidget);

      // Switch to Hard Vocabulary list under Lesson 1
      final hardTab = find.byKey(
        const ValueKey<String>('lesson_vocab_hard_tab'),
      );
      await tester.ensureVisible(hardTab);
      await tester.tap(hardTab);
      await tester.pumpAndSettle();

      expect(find.text('Guten Morgen'), findsOneWidget);
      expect(find.text('1 Hard Vocabulary'), findsOneWidget);

      // Navigate back to Home -> Vocabulary Review tab
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();

      expect(find.text('Hard (1)'), findsOneWidget);

      // Filter to Hard Only in VocabularyScreen
      await tester.tap(
        find.byKey(const ValueKey<String>('vocab_hard_only_toggle')),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 words'), findsOneWidget);
      expect(find.text('Guten Morgen'), findsOneWidget);

      // Unselect directly from Hard list in VocabularyScreen
      await tester.tap(
        find.byKey(const ValueKey<String>('vocab_hard_lesson_01_Guten Morgen')),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Hard Vocabulary Yet'), findsOneWidget);
      expect(find.text('Hard (0)'), findsOneWidget);

      // Verify Lesson 1 Words tab is synchronized (now 0 hard words)
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(lesson1Card);
      await tester.tap(lesson1Card);
      await tester.pumpAndSettle();
      await tester.ensureVisible(wordsTab);
      await tester.tap(wordsTab);
      await tester.pumpAndSettle();

      expect(find.text('Hard Vocabulary (0)'), findsOneWidget);

      // Switch back to All Words, mark again, switch to Hard Vocabulary tab, and unselect directly there
      final allTab = find.byKey(
        const ValueKey<String>('lesson_vocab_all_tab'),
      );
      await tester.ensureVisible(allTab);
      await tester.tap(allTab);
      await tester.pumpAndSettle();

      await tester.ensureVisible(l1WordBtn);
      await tester.tap(l1WordBtn);
      await tester.pumpAndSettle();
      await tester.ensureVisible(hardTab);
      await tester.tap(hardTab);
      await tester.pumpAndSettle();
      expect(find.text('Guten Morgen'), findsOneWidget);

      await tester.ensureVisible(l1WordBtn);
      await tester.tap(l1WordBtn);
      await tester.pumpAndSettle();
      expect(find.text('No Hard Vocabulary Yet'), findsOneWidget);
      expect(find.text('Hard Vocabulary (0)'), findsOneWidget);
    },
  );
}
