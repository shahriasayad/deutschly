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

  test(
    'CourseRepository loads all 7 lessons and expanded exercise types',
    () async {
      const repository = CourseRepository();
      final course = await repository.loadCourse();

      expect(course.id, 'german_a1_1_original');
      expect(course.level, 'A1.1');
      expect(course.totalLessons, 7);
      expect(course.lessons.length, 7);

      final allExercises = course.lessons
          .expand((lesson) => lesson.exercises)
          .toList();
      expect(allExercises.length, 304);
      expect(course.metadata?.totalExercises, allExercises.length);

      expect(
        course.lessons
            .expand((lesson) => lesson.vocabulary)
            .every((item) => item.pronunciationBn?.isNotEmpty == true),
        isTrue,
      );
      expect(
        course.lessons.every(
          (lesson) =>
              lesson.grammar.length >= 7 && lesson.dialogues.length >= 4,
        ),
        isTrue,
      );
      expect(
        course.lessons
            .expand((lesson) => lesson.dialogues)
            .expand((dialogue) => dialogue.lines)
            .every(
              (line) =>
                  line.pronunciationBn?.isNotEmpty == true &&
                  line.translationBn?.isNotEmpty == true,
            ),
        isTrue,
      );

      expect(allExercises.whereType<MultipleChoiceExercise>(), isNotEmpty);
      expect(allExercises.whereType<FillBlankExercise>(), isNotEmpty);
      expect(allExercises.whereType<MatchingExercise>(), isNotEmpty);
      expect(allExercises.whereType<TrueFalseExercise>(), isNotEmpty);
      expect(allExercises.whereType<SpeakingPromptExercise>(), isNotEmpty);
      expect(
        allExercises.whereType<SpeakingPromptExercise>().every(
          (exercise) => exercise.pronunciationBn?.isNotEmpty == true,
        ),
        isTrue,
      );
      expect(allExercises.whereType<OrderingExercise>(), isNotEmpty);
      expect(allExercises.whereType<WritingPromptExercise>(), isNotEmpty);
      expect(
        course.lessons[2].exercises.any((exercise) => exercise.id == 'ex3_46'),
        isTrue,
      );
      expect(
        course.lessons[3].grammar.any(
          (point) => point.title.toLowerCase().contains('gefallen'),
        ),
        isTrue,
      );
      expect(
        course.lessons[5].dialogues.any(
          (dialogue) => dialogue.title.contains('snack bar'),
        ),
        isTrue,
      );
      expect(
        course.lessons[6].vocabulary.any((item) => item.de == 'Ski fahren'),
        isTrue,
      );
    },
  );

  test(
    'ProgressService persists completed exercises and score in Hive and reloads after restart',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'deutschly_hive_test',
      );
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
        progressController1.getLessonProgressPercent(
          'lesson_01',
          totalExercises: 10,
        ),
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
        progressController2.getLessonProgressPercent(
          'lesson_01',
          totalExercises: 10,
        ),
        20,
      );

      await progressController2.resetAllProgress();
      expect(progressController2.getLessonScore('lesson_01'), 0);

      await box.put(ProgressService.storageKey, <String, dynamic>{
        'lesson_01': <String, dynamic>{
          'completedExercises': <String>['ex1_1'],
          'score': 1,
        },
      });
      final mapBackedService = ProgressService();
      await mapBackedService.init(hiveBox: box);
      expect(
        mapBackedService.loadAllProgress()['lesson_01']?.completedExercises,
        contains('ex1_1'),
      );

      await box.close();
      expect(
        mapBackedService.loadAllProgress()['lesson_01']?.completedExercises,
        contains('ex1_1'),
      );
      await tempDir.delete(recursive: true);
    },
  );

  testWidgets(
    'Completing exercise updates HomeScreen, LessonDetailScreen, VocabularyScreen, AboutScreen, and Reset Progress clears it',
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
      Get.put(VocabularyController(courseController: courseController));

      await tester.pumpWidget(const DeutschlyApp());
      await tester.pumpAndSettle();

      expect(find.text('German A1.1'), findsOneWidget);

      // Mark 2 of 39 exercises in lesson_01 completed.
      await progressController.markExerciseCompleted(
        lessonId: 'lesson_01',
        exerciseId: 'ex1_1',
      );
      await progressController.markExerciseCompleted(
        lessonId: 'lesson_01',
        exerciseId: 'ex1_2',
      );
      await tester.pumpAndSettle();

      expect(find.text('1%'), findsOneWidget);

      // Open Lesson 1 and verify tabbed study sections + completed status
      final lessonCard = find.byKey(const ValueKey<String>('lesson_01'));
      await tester.ensureVisible(lessonCard);
      await tester.tap(lessonCard);
      await tester.pumpAndSettle();

      expect(find.text('2 / 39 Completed'), findsOneWidget);
      // Open Dialogues tab and verify Bangla translation + Flashcard ON/OFF toggle
      final dialoguesTab = find.byKey(
        const ValueKey<String>('lesson_tab_dialogues'),
      );
      await tester.ensureVisible(dialoguesTab);
      await tester.tap(dialoguesTab);
      await tester.pumpAndSettle();

      expect(find.text('শুভ দিন। আমার নাম আনা মুলার।'), findsOneWidget);
      expect(find.textContaining('(আনুমানিক)'), findsNothing);
      expect(find.text('Flashcard: OFF'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey<String>('dialogues_flashcard_toggle')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Flashcard: ON'), findsOneWidget);
      expect(find.text('শুভ দিন। আমার নাম আনা মুলার।'), findsNothing);
      expect(find.text('Tap line to reveal translation'), findsWidgets);

      await tester.tap(
        find.byKey(const ValueKey<String>('dialogue_line_lesson_01_0_d1_0')),
      );
      await tester.pumpAndSettle();
      expect(find.text('শুভ দিন। আমার নাম আনা মুলার।'), findsOneWidget);

      final exercisesTab = find.byKey(
        const ValueKey<String>('lesson_tab_exercises'),
      );
      await tester.ensureVisible(exercisesTab);
      await tester.tap(exercisesTab);
      await tester.pumpAndSettle();
      expect(find.text('Completed'), findsNWidgets(2));
      expect(find.text('Not started'), findsNWidgets(37));

      // Navigate back to Home
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigate to Vocabulary tab and verify deck mode toggle
      await tester.tap(find.text('Vocabulary'));
      await tester.pumpAndSettle();
      expect(find.text('Vocabulary Review'), findsOneWidget);
      expect(find.text('Guten Morgen'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey<String>('vocab_deck_mode_toggle')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey<String>('vocab_deck_card')), findsOneWidget);

      // Navigate to Exam Prep tab
      await tester.tap(find.text('Exam Prep'));
      await tester.pumpAndSettle();
      expect(find.text('A1 Exam Practice'), findsOneWidget);
      expect(find.text('Listening'), findsOneWidget);

      // Navigate to Progress tab and open About & Info
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();
      expect(find.text('Your Progress'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey<String>('home_about_btn')));
      await tester.pumpAndSettle();
      expect(find.text('About & Info'), findsOneWidget);
      expect(find.text('100% Offline-First'), findsOneWidget);

      // Navigate back to Home and test Reset Progress dialog
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey<String>('home_reset_progress_btn')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reset Progress?'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('confirm_reset_btn')));
      await tester.pumpAndSettle();

      expect(find.text('10%'), findsNothing);
      expect(find.text('0%'), findsNWidgets(8));
    },
  );

  testWidgets(
    'ExercisePlayer renders and evaluates all 7 exercise types and reviews mistakes',
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
        Exercise.writingPrompt(
          id: 'write_1',
          question: 'Write a greeting in German.',
          exampleAnswer: 'Guten Tag! Ich heiße Karim.',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ExercisePlayer(exercises: sampleExercises)),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Multiple Choice
      await tester.tap(find.byKey(const ValueKey<String>('mc_option_1')));
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      // 2. Fill Blank
      await tester.enterText(find.byType(TextField), 'gehen');
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Incorrect'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      // 3. Matching
      await tester.tap(
        find.byKey(const ValueKey<String>('match_left_Morning')),
      );
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
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      // 4. True / False
      await tester.tap(find.byKey(const ValueKey<String>('tf_false')));
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      // 5. Speaking Prompt
      await tester.tap(
        find.byKey(const ValueKey<String>('speaking_eval_good')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Nice speaking practice!'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('exercise_next_btn')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      // 6. Ordering
      await tester.tap(find.byKey(const ValueKey<String>('order_down_0')));
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      // 7. Written response
      await tester.enterText(
        find.byKey(const ValueKey<String>('writing_response')),
        'Guten Tag! Ich heiße Karim.',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('writing_eval_ready')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('writing_eval_ready')),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Writing reviewed'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('exercise_next_btn')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Review 1 of 1'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'komme');
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey<String>('exercise_check_btn')),
      );
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Exercises Completed!'), findsOneWidget);
    },
  );

  testWidgets('ExercisePlayer starts a fresh session after it is removed', (
    WidgetTester tester,
  ) async {
    const exercises = <Exercise>[
      Exercise.multipleChoice(
        id: 'session_mc',
        question: 'Choose the greeting.',
        options: <String>['Guten Morgen'],
        correctIndex: 0,
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ExercisePlayer(exercises: exercises)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('mc_option_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();
    expect(find.text('Exercises Completed!'), findsOneWidget);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ExercisePlayer(exercises: exercises)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose the greeting.'), findsOneWidget);
    expect(find.text('Exercises Completed!'), findsNothing);
  });
}
