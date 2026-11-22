import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
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

    final allExercises = course.lessons.expand((lesson) => lesson.exercises).toList();
    expect(allExercises.length, 70);

    expect(allExercises.whereType<MultipleChoiceExercise>(), isNotEmpty);
    expect(allExercises.whereType<FillBlankExercise>(), isNotEmpty);
    expect(allExercises.whereType<MatchingExercise>(), isNotEmpty);
    expect(allExercises.whereType<TrueFalseExercise>(), isNotEmpty);
    expect(allExercises.whereType<SpeakingPromptExercise>(), isNotEmpty);
    expect(allExercises.whereType<OrderingExercise>(), isNotEmpty);
  });

  testWidgets('DeutschlyApp renders loaded lesson count', (WidgetTester tester) async {
    const repository = CourseRepository();
    final course = await repository.loadCourse();
    final controller = Get.put(CourseController(repository: repository));
    controller.course.value = course;

    await tester.pumpWidget(const DeutschlyApp());
    await tester.pumpAndSettle();

    expect(find.text('Loaded lessons: 7'), findsOneWidget);
  });
}
