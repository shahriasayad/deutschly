import 'package:get/get.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';

class HomeController extends GetxController {
  HomeController({CourseController? courseController})
    : _courseController = courseController ?? Get.find<CourseController>();

  final CourseController _courseController;

  final RxMap<String, double> lessonProgressMap = <String, double>{}.obs;

  Course? get course => _courseController.course.value;

  List<Lesson> get lessons => course?.lessons ?? const <Lesson>[];

  bool get isLoading => _courseController.isLoading.value;

  String? get errorMessage => _courseController.errorMessage.value;

  double getLessonProgress(String lessonId) {
    return lessonProgressMap[lessonId] ?? 0.0;
  }

  int getLessonProgressPercent(String lessonId) {
    return (getLessonProgress(lessonId) * 100).round();
  }

  double get overallProgress {
    final allLessons = lessons;
    if (allLessons.isEmpty) {
      return 0.0;
    }
    final total = allLessons.fold<double>(
      0.0,
      (double sum, Lesson lesson) => sum + getLessonProgress(lesson.id),
    );
    return total / allLessons.length;
  }

  int get overallProgressPercent => (overallProgress * 100).round();

  Future<void> retryLoadCourse() => _courseController.loadCourse();
}
