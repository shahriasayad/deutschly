import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exercise/screen/exercise_screen.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
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

  testWidgets(
      'HomeScreen shows all 7 lessons and LessonDetailScreen displays objectives, vocabulary, grammar, dialogues, and exercises',
      (WidgetTester tester) async {
    const repository = CourseRepository();
    final Course? course = await tester.runAsync(() => repository.loadCourse());
    expect(course, isNotNull);

    final courseController = Get.put(
      CourseController(repository: repository, initialCourse: course),
    );
    Get.put(HomeController(courseController: courseController));

    await tester.pumpWidget(const DeutschlyApp());
    await tester.pumpAndSettle();

    expect(find.text('German A1.1'), findsOneWidget);

    for (final lesson in course!.lessons) {
      expect(find.byKey(ValueKey<String>(lesson.id)), findsOneWidget);
      expect(find.text(lesson.title), findsOneWidget);
    }

    await tester.tap(find.byKey(const ValueKey<String>('lesson_01')));
    await tester.pumpAndSettle();

    expect(find.text('Lesson 1'), findsWidgets);
    expect(
      find.text('Guten Tag! – Greetings & Introductions'),
      findsOneWidget,
    );
    expect(find.text('Learning Objectives'), findsOneWidget);
    expect(find.text('Vocabulary (18)'), findsOneWidget);
    expect(find.text('Grammar (3)'), findsOneWidget);
    expect(find.text('Dialogues (2)'), findsOneWidget);
    expect(find.text('Exercises (10)'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('German A1.1'), findsOneWidget);
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

    // 1. Multiple Choice (correct answer: index 1)
    expect(find.text('Exercise 1 of 6'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('mc_option_1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Guten Morgen = Good morning'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 2. Fill Blank (incorrect answer check)
    expect(find.text('Exercise 2 of 6'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'gehen');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Incorrect'), findsOneWidget);
    expect(find.text('Correct answer: komme'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 3. Matching (correct match)
    expect(find.text('Exercise 3 of 6'), findsOneWidget);
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

    // 4. True / False (correct answer: false)
    expect(find.text('Exercise 4 of 6'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('tf_false')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Tschüs is informal.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 5. Speaking Prompt (self evaluation: good)
    expect(find.text('Exercise 5 of 6'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('speaking_eval_good')));
    await tester.pump();
    expect(find.text('Hallo! Ich heiße Karim.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // 6. Ordering (move position 0 down so order becomes [1, 0])
    expect(find.text('Exercise 6 of 6'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('order_down_0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('exercise_check_btn')));
    await tester.pump();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('exercise_next_btn')));
    await tester.pumpAndSettle();

    // Summary screen shows 5 / 6 correct
    expect(find.text('Exercises Completed!'), findsOneWidget);
    expect(find.textContaining('You scored 5 out of 6'), findsOneWidget);
  });
}
