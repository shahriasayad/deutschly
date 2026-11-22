import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
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
      'HomeScreen shows German A1.1, all 7 lessons with 0% progress, and navigates to LessonDetailScreen',
      (WidgetTester tester) async {
    const repository = CourseRepository();
    final course = await repository.loadCourse();
    final courseController = Get.put(CourseController(repository: repository));
    courseController.course.value = course;
    Get.put(HomeController(courseController: courseController));

    await tester.pumpWidget(const DeutschlyApp());
    await tester.pumpAndSettle();

    expect(find.text('German A1.1'), findsOneWidget);

    for (final lesson in course.lessons) {
      expect(find.byKey(ValueKey<String>(lesson.id)), findsOneWidget);
      expect(find.text(lesson.title), findsOneWidget);
    }
    expect(find.text('0%'), findsNWidgets(8));

    await tester.tap(find.byKey(const ValueKey<String>('lesson_01')));
    await tester.pumpAndSettle();

    expect(find.text('Lesson Detail Placeholder'), findsOneWidget);
    expect(
      find.text('Guten Tag! – Greetings & Introductions'),
      findsOneWidget,
    );
  });
}
