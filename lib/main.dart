import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:deutschly/core/Shared_preference_helper.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/service/progress_service.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
  } catch (error, stackTrace) {
    ApiLogger.logError(
      'Hive initialization failed; using fallback storage',
      error,
      stackTrace,
    );
  }
  try {
    await SharedPreferenceHelper.init();
  } catch (error, stackTrace) {
    ApiLogger.logError(
      'SharedPreferences initialization failed',
      error,
      stackTrace,
    );
  }

  final progressService = ProgressService();
  await progressService.init();

  const repository = CourseRepository();
  final courseController = Get.put(CourseController(repository: repository));
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
  Get.put(VocabularyController(courseController: courseController));

  runApp(const DeutschlyApp());
}

class DeutschlyApp extends StatelessWidget {
  const DeutschlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final easyLoadingBuilder = EasyLoading.init();
    return MaterialApp.router(
      title: 'Deutschly',
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      builder: (BuildContext context, Widget? child) {
        AppScreenUtil.init(context);
        return easyLoadingBuilder(context, child);
      },
    );
  }
}
