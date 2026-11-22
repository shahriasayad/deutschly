import 'package:deutschly/core/api_client.dart';
import 'package:deutschly/core/image_path.dart';
import 'package:deutschly/data/models/course.dart';

class CourseRepository {
  const CourseRepository({
    this.apiClient = const ApiClient(),
    this.assetPath = ImagePath.courseAsset,
  });

  final ApiClient apiClient;
  final String assetPath;

  Future<Course> loadCourse() async {
    final jsonMap = await apiClient.loadJsonAsset(assetPath);
    return Course.fromJson(jsonMap);
  }
}
