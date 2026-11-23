import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exam/controller/exam_practice_controller.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(Get.reset);

  test(
    'exam practice builds tasks for all four skills across lessons',
    () async {
      final course = await const CourseRepository().loadCourse();
      final controller = ExamPracticeController(
        courseController: CourseController(initialCourse: course),
      );

      final reading = controller.practiceExercisesFor(ExamSkill.reading);
      final writing = controller.practiceExercisesFor(ExamSkill.writing);
      final speaking = controller.practiceExercisesFor(ExamSkill.speaking);
      final listening = controller.listeningTasks;

      expect(reading, isNotEmpty);
      expect(writing, isNotEmpty);
      expect(speaking, isNotEmpty);
      expect(listening.length, ExamSkill.listening.practiceTaskLimit);
      expect(
        reading.map((item) => item.lessonId).toSet().length,
        greaterThan(1),
      );
      expect(
        writing.every((item) => item.exercise is WritingPromptExercise),
        isTrue,
      );
      expect(
        speaking.every((item) => item.exercise is SpeakingPromptExercise),
        isTrue,
      );
      expect(listening.every((task) => task.options.length == 4), isTrue);
      expect(
        listening.every(
          (task) => task.options[task.correctIndex] == task.spokenText,
        ),
        isTrue,
      );
    },
  );

  test('exam skills expose current A1 section timing and parse safely', () {
    expect(ExamSkill.listening.durationMinutes, 20);
    expect(ExamSkill.reading.durationMinutes, 25);
    expect(ExamSkill.writing.durationMinutes, 20);
    expect(ExamSkill.speaking.durationMinutes, 15);
    expect(ExamSkill.parse('speaking'), ExamSkill.speaking);
    expect(ExamSkill.parse('unknown'), isNull);
  });

  test('timed mode can be changed independently', () async {
    final course = await const CourseRepository().loadCourse();
    final controller = ExamPracticeController(
      courseController: CourseController(initialCourse: course),
    );
    expect(controller.isTimedMode.value, isFalse);
    controller.setTimedMode(true);
    expect(controller.isTimedMode.value, isTrue);
    controller.setTimedMode(false);
    expect(controller.isTimedMode.value, isFalse);
  });
}
