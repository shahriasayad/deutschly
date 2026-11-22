import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/home/widgets/course_header_card.dart';
import 'package:deutschly/features/home/widgets/lesson_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'German A1.1'),
      body: Obx(() {
        if (controller.isLoading && controller.course == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = controller.errorMessage;
        if (error != null && controller.course == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    error,
                    style: getTextStyle(
                      fontSize: 16,
                      color: colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'Retry',
                    width: 160,
                    onPressed: controller.retryLoadCourse,
                  ),
                ],
              ),
            ),
          );
        }

        final course = controller.course;
        final lessons = controller.lessons;
        if (course == null || lessons.isEmpty) {
          return Center(
            child: Text(
              'No lessons found.',
              style: getTextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CourseHeaderCard(
                course: course,
                overallProgress: controller.overallProgress,
                overallProgressPercent: controller.overallProgressPercent,
              ),
              const SizedBox(height: 24),
              Text(
                'Course Lessons',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              for (int index = 0; index < lessons.length; index++) ...<Widget>[
                LessonCard(
                  key: ValueKey<String>(lessons[index].id),
                  lesson: lessons[index],
                  progress: controller.getLessonProgress(lessons[index].id),
                  progressPercent:
                      controller.getLessonProgressPercent(lessons[index].id),
                  onTap: () {
                    context.push(AppRoutes.lessonDetail(lessons[index].id));
                  },
                ),
                if (index < lessons.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        );
      }),
    );
  }
}
