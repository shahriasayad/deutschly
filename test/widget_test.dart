import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exercise/screen/exercise_screen.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';
import 'package:deutschly/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(Get.reset);

  test('CourseRepository loads 7 lessons and 70 exercises from assets JSON', () async {
    const repository = CourseRepository();
    final course = await repository.loadCourse();

    expect(course.id, 'german_a1_1_original');
    expect(course.level, 'A1.1');
    expect(course.totalLessons, 7);
    expect(course.lessons.length, 7);

    final allExercises =
        course.lessons.expand((lesson) => lesson.exercises).toList();
    expect(allExercises.length, 70);

    expect(allExercises.whereType<MultipleChoiceExercise>(), isNotEmpty);
    expect(allExercises.whereType<FillBlankExercise>(), isNotEmpty);
    expect(allExercises.whereType<MatchingExercise>(), isNotEmpty);
    expect(allExercises.whereType<TrueFalseExercise>(), isNotEmpty);
    expect(allExercises.whereType<SpeakingPromptExercise>(), isNotEmpty);
    expect(allExercises.whereType<OrderingExercise>(), isNotEmpty);
  });

  test('ProgressService persists completed exercises and score in Hive and reloads after restart', () async {
    final tempDir = await Directory.systemTemp.createTemp('deutschly_hive_test');
    Hive.init(tempDir.path);
    final box = await Hive.openBox<dynamic>('test_progress_box');

    final service1 = ProgressService();
    await service1.init(hiveBox: box);

    const repository = CourseRepository();
    final course = await repository.loadCourse();
    final courseController = Get.put(
      CourseController(repository: repository, initialCourse: course),
    );
    final progressController1 = ProgressController(
      progressService: service1,
      courseController: courseController,
    );
    progressController1.loadProgress();

    await progressController1.markExerciseCompleted(
      lessonId: 'lesson_01',
      exerciseId: 'ex1_1',
    );
    await progressController1.markExerciseCompleted(
      lessonId: 'lesson_01',
      exerciseId: 'ex1_3',
    );

    expect(progressController1.getLessonScore('lesson_01'), 2);
    expect(
      progressController1.getLessonProgressPercent('lesson_01', totalExercises: 10),
      20,
    );

    // Simulate app restart by creating a new service & controller reading the same Hive box
    final service2 = ProgressService();
    await service2.init(hiveBox: box);
    final progressController2 = ProgressController(
      progressService: service2,
      courseController: courseController,
    );
    progressController2.loadProgress();

    expect(
      progressController2.getCompletedExerciseIds('lesson_01'),
      containsAll(<String>['ex1_1', 'ex1_3']),
    );
    expect(progressController2.getLessonScore('lesson_01'), 2);
    expect(
      progressController2.getLessonProgressPercent('lesson_01', totalExercises: 10),
      20,
    );

    await progressController2.resetAllProgress();
    expect(progressController2.getLessonScore('lesson_01'), 0);

    await box.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets(
      'Completing exercise updates HomeScreen, LessonDetailScreen, VocabularyScreen, AboutScreen, and Reset Progress clears it',
      (WidgetTester tester) async {
    const repository = CourseRepository();
    final Course? course = await tester.runAsync(() => repository.loadCourse());
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
    Get.put(VocabularyController(courseController: courseController));

    await tester.pumpWidget(const DeutschlyApp());
    await tester.pumpAndSettle();

    expect(find.text('German A1.1'), findsOneWidget);

    // Mark 2 of 10 exercises in lesson_01 completed (20%)
    await progressController.markExerciseCompleted(
      lessonId: 'lesson_01',
      exerciseId: 'ex1_1',
    );
    await progressController.markExerciseCompleted(
      lessonId: 'lesson_01',
      exerciseId: 'ex1_2',
    );
    await tester.pumpAndSettle();

    expect(find.text('20%'), findsOneWidget);

    // Open Lesson 1 and verify completed status
    await tester.tap(find.byKey(const ValueKey<String>('lesson_01')));
    await tester.pumpAndSettle();

    expect(find.text('2 / 10 Completed'), findsOneWidget);
    expect(find.text('Completed'), findsNWidgets(2));
    expect(find.text('Not started'), findsNWidgets(8));

    // Navigate back to Home
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Navigate to Vocabulary tab
    await tester.tap(find.text('Vocabulary'));
    await tester.pumpAndSettle();
    expect(find.text('Vocabulary Review'), findsOneWidget);
    expect(find.text('Guten Morgen'), findsOneWidget);

    // Navigate to About tab
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('About & Info'), findsOneWidget);
    expect(find.text('100% Offline-First'), findsOneWidget);

    // Navigate back to Home and test Reset Progress dialog
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('home_reset_progress_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Reset Progress?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('confirm_reset_btn')));
    await tester.pumpAndSettle();

    expect(find.text('20%'), findsNothing);
    expect(find.text('0%'), findsNWidgets(8));
  });

  testWidgets(
      'ExercisePlayer renders and evaluates all 6 exercise types (correct & incorrect) and navigates between exercises',
      (WidgetTester tester) async {
    const sampleExercises = <Exercise>[
      Exercise.multipleChoice(
        id: 'mc_1',
        question: 'What do you say in the morning?',
        options: <String>['Guten Abend', 'Guten Morgen', 'Gute Nacht'],
        correctIndex: 1,
        explanation: 'Guten Morgen = Good morning',
      ),
      Exercise.fillBlank(
        id: 'fb_1',
        question: 'Complete: Ich _____ aus Bangladesch.',
        answer: 'komme',
        acceptableAnswers: <String>['komme'],
        explanation: 'Ich komme aus ...',
      ),
      Exercise.matching(
        id: 'm_1',
        question: 'Match the greeting',
        pairs: <MatchingPair>[
          MatchingPair(left: 'Morning', right: 'Guten Morgen'),
          MatchingPair(left: 'Night', right: 'Gute Nacht'),
        ],
      ),
      Exercise.trueFalse(
        id: 'tf_1',
        question: '"Tschüs" is formal.',
        correct: false,
        explanation: 'Tschüs is informal.',
      ),
      Exercise.speakingPrompt(
        id: 'sp_1',
        question: 'Introduce yourself.',
        exampleAnswer: 'Hallo! Ich heiße Karim.',
      ),
      Exercise.ordering(
        id: 'ord_1',
        question: 'Order the dialogue',
        items: <String>['Second line', 'First line'],
        correctOrder: <int>[1, 0],
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExercisePlayer(exercises: sampleExercises),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Multiple Choice
    await tester.tap(find.byKey(const ValueKey<String>('mc_option_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 2. Fill Blank
    await tester.enterText(find.byType(TextField), 'gehen');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Incorrect'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 3. Matching
    await tester.tap(find.byKey(const ValueKey<String>('match_left_Morning')));
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey<String>('match_right_Guten Morgen')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('match_left_Night')));
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey<String>('match_right_Gute Nacht')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 4. True / False
    await tester.tap(find.byKey(const ValueKey<String>('tf_false')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 5. Speaking Prompt
    await tester.tap(find.byKey(const ValueKey<String>('speaking_eval_good')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 6. Ordering
    await tester.tap(find.byKey(const ValueKey<String>('order_down_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Exercises Completed!'), findsOneWidget);
  });
}
