import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:deutschly/core/Shared_preference_helper.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await SharedPreferenceHelper.init();

  final progressService = ProgressService();
  await progressService.init();

  const repository = CourseRepository();
  final course = await repository.loadCourse();
  ApiLogger.logInfo('Loaded lessons count: ${course.lessons.length}');

  final courseController = Get.put(
    CourseController(repository: repository, initialCourse: course),
  );
  final progressController = Get.put(
    ProgressController(
      progressService: progressService,
      courseController: courseController,
    ),
  );
  Get.put(
    HomeController(
      courseController: courseController,
      progressController: progressController,
    ),
  );
  Get.put(
    VocabularyController(courseController: courseController),
  );

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
