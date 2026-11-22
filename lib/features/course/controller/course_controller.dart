import 'package:get/get.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/data/models/course.dart';
import 'package:deutschly/data/repositories/course_repository.dart';

class CourseController extends GetxController {
  CourseController({CourseRepository? repository})
      : _repository = repository ?? const CourseRepository();

  final CourseRepository _repository;

  final Rxn<Course> course = Rxn<Course>();
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadCourse();
  }

  Future<void> loadCourse() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final loadedCourse = await _repository.loadCourse();
      course.value = loadedCourse;
      ApiLogger.logInfo(
        'Loaded course "${loadedCourse.title}" with ${loadedCourse.lessons.length} lessons.',
      );
    } catch (error, stackTrace) {
      errorMessage.value = 'Failed to load course data.';
      ApiLogger.logError('CourseController.loadCourse failed', error, stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
