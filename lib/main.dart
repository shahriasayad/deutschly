import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const repository = CourseRepository();
  final course = await repository.loadCourse();
  ApiLogger.logInfo('Loaded lessons count: ${course.lessons.length}');
  final courseController = Get.put(CourseController(repository: repository));
  courseController.course.value = course;
  Get.put(HomeController(courseController: courseController));
  runApp(const DeutschlyApp());
}

class DeutschlyApp extends StatelessWidget {
  const DeutschlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'German A1.1',
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      builder: EasyLoading.init(),
    );
  }
}
