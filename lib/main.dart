import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/api_logger.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/repositories/course_repository.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const repository = CourseRepository();
  final course = await repository.loadCourse();
  ApiLogger.logInfo('Loaded lessons count: ${course.lessons.length}');
  final controller = Get.put(CourseController(repository: repository));
  controller.course.value = course;
  runApp(const DeutschlyApp());
}

class DeutschlyApp extends StatelessWidget {
  const DeutschlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Deutschly - German A1.1',
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system,
      builder: EasyLoading.init(),
      home: const CourseVerificationScreen(),
    );
  }
}

class CourseVerificationScreen extends StatelessWidget {
  const CourseVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Deutschly A1.1'),
      body: Obx(() {
        if (controller.isLoading.value && controller.course.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = controller.errorMessage.value;
        if (error != null && controller.course.value == null) {
          return Center(
            child: Text(
              error,
              style: getTextStyle(fontSize: 16, color: colorScheme.error),
            ),
          );
        }
        final loadedCourse = controller.course.value;
        if (loadedCourse == null) {
          return Center(
            child: Text(
              'No course data available.',
              style: getTextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loadedCourse.title,
                  style: getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Loaded lessons: ${loadedCourse.lessons.length}',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
