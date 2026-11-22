import 'package:get/get.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';

class HomeController extends GetxController {
  HomeController({
    CourseController? courseController,
    ProgressController? progressController,
  }) : _courseController = courseController ?? Get.find<CourseController>(),
       _progressController = progressController;

  final CourseController _courseController;
  final ProgressController? _progressController;

  ProgressController get _resolvedProgressController {
    if (_progressController != null) {
      return _progressController;
    }
    if (Get.isRegistered<ProgressController>()) {
      return Get.find<ProgressController>();
    }
    return Get.put(ProgressController(courseController: _courseController));
  }

  Course? get course => _courseController.course.value;

  List<Lesson> get lessons => course?.lessons ?? const <Lesson>[];

  bool get isLoading => _courseController.isLoading.value;

  String? get errorMessage => _courseController.errorMessage.value;

  double getLessonProgress(String lessonId) {
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);
    return _resolvedProgressController.getLessonProgressRatio(
      lessonId,
      totalExercises: lesson?.exercises.length,
    );
  }

  int getLessonProgressPercent(String lessonId) {
    final lesson = lessons.firstWhereOrNull((Lesson l) => l.id == lessonId);
    return _resolvedProgressController.getLessonProgressPercent(
      lessonId,
      totalExercises: lesson?.exercises.length,
    );
  }

  double get overallProgress =>
      _resolvedProgressController.overallCourseProgress;

  int get overallProgressPercent =>
      _resolvedProgressController.overallCourseProgressPercent;

  Future<void> resetAllProgress() =>
      _resolvedProgressController.resetAllProgress();

  Future<void> retryLoadCourse() => _courseController.loadCourse();
}
