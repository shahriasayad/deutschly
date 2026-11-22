import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';

class LessonDetailController extends GetxController {
  LessonDetailController({
    required this.lessonId,
    CourseController? courseController,
  }) : _courseController = courseController ?? Get.find<CourseController>();

  final String lessonId;
  final CourseController _courseController;

  final RxBool isVocabularyExpanded = true.obs;
  final RxSet<String> completedExerciseIds = <String>{}.obs;

  Lesson? get lesson {
    final lessons = _courseController.course.value?.lessons ?? const <Lesson>[];
    return lessons.firstWhereOrNull((Lesson item) => item.id == lessonId);
  }

  void toggleVocabularyExpanded() {
    isVocabularyExpanded.value = !isVocabularyExpanded.value;
  }

  bool isExerciseCompleted(String exerciseId) {
    return completedExerciseIds.contains(exerciseId);
  }

  int get completedCount {
    final currentLesson = lesson;
    if (currentLesson == null) {
      return 0;
    }
    return currentLesson.exercises
        .where((Exercise ex) => completedExerciseIds.contains(ex.id))
        .length;
  }

  static String formatExerciseType(String type) {
    return switch (type) {
      'multiple_choice' => 'Multiple Choice',
      'fill_blank' => 'Fill in the Blank',
      'matching' => 'Matching',
      'true_false' => 'True / False',
      'speaking_prompt' => 'Speaking Prompt',
      'ordering' => 'Ordering',
      _ => type,
    };
  }
}
