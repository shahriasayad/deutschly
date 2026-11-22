import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';

class LessonDetailController extends GetxController {
  LessonDetailController({
    required this.lessonId,
    CourseController? courseController,
    ProgressController? progressController,
  }) : _courseController = courseController ?? Get.find<CourseController>(),
       _progressController = progressController;

  final String lessonId;
  final CourseController _courseController;
  final ProgressController? _progressController;

  final RxBool isVocabularyExpanded = true.obs;

  ProgressController get _resolvedProgressController {
    if (_progressController != null) {
      return _progressController;
    }
    if (Get.isRegistered<ProgressController>()) {
      return Get.find<ProgressController>();
    }
    return Get.put(ProgressController(courseController: _courseController));
  }

  Lesson? get lesson {
    final lessons = _courseController.course.value?.lessons ?? const <Lesson>[];
    return lessons.firstWhereOrNull((Lesson item) => item.id == lessonId);
  }

  void toggleVocabularyExpanded() {
    isVocabularyExpanded.value = !isVocabularyExpanded.value;
  }

  Set<String> get completedExerciseIds =>
      _resolvedProgressController.getCompletedExerciseIds(lessonId);

  bool isExerciseCompleted(String exerciseId) {
    return _resolvedProgressController.isExerciseCompleted(
      lessonId,
      exerciseId,
    );
  }

  int get completedCount {
    final currentLesson = lesson;
    if (currentLesson == null) {
      return 0;
    }
    final completedSet = completedExerciseIds;
    return currentLesson.exercises
        .where((Exercise ex) => completedSet.contains(ex.id))
        .length;
  }

  static String formatExerciseType(String type) {
    return switch (type) {
      'multiple_choice' => 'Multiple Choice',
      'fill_blank' => 'Fill in the Blank',
      'matching' => 'Matching',
      'true_false' => 'True / False',
      'speaking_prompt' => 'Speaking Prompt',
      'writing_prompt' => 'Writing Practice',
      'ordering' => 'Ordering',
      _ => type,
    };
  }
}
