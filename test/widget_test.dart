import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
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
    expect(
      find.text('Greet people at different times of day'),
      findsOneWidget,
    );
    expect(find.text('Vocabulary (18)'), findsOneWidget);
    expect(find.text('Guten Morgen'), findsOneWidget);
    expect(find.text('Grammar (3)'), findsOneWidget);
    expect(find.text('Personal pronouns & sein'), findsOneWidget);
    expect(find.text('Dialogues (2)'), findsOneWidget);
    expect(find.text('Meeting for the first time'), findsOneWidget);
    expect(find.text('Exercises (10)'), findsOneWidget);
    expect(find.text('What do you say in the morning?'), findsOneWidget);
    expect(find.text('Not started'), findsNWidgets(10));
    expect(find.text('Start Exercises'), findsNWidgets(2));

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('German A1.1'), findsOneWidget);
  });
}
