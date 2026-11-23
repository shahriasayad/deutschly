import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/image_path.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/home/widgets/course_header_card.dart';
import 'package:deutschly/features/home/widgets/continue_learning_card.dart';
import 'package:deutschly/features/home/widgets/lesson_card.dart';
import 'package:deutschly/features/progress/widgets/reset_progress_dialog.dart';
import 'package:deutschly/features/exam/widgets/exam_practice_entry_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'German A1.1',
        leading: Padding(
          padding: EdgeInsets.all(10.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              ImagePath.appLogo,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.school_rounded),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            key: const ValueKey<String>('home_reset_progress_btn'),
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Reset Progress',
            onPressed: () async {
              final confirmed = await showResetProgressDialog(context);
              if (confirmed) {
                await controller.resetAllProgress();
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && controller.course == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = controller.errorMessage;
        if (error != null && controller.course == null) {
          return EmptyStateWidget(
            icon: Icons.error_outline_rounded,
            title: 'Could Not Load Course',
            subtitle: error,
            actionLabel: 'Retry',
            onAction: controller.retryLoadCourse,
          );
        }

        final course = controller.course;
        final lessons = controller.lessons;
        final nextSession = controller.nextPracticeSession;
        final sessionExerciseCount = nextSession?.items.length ?? 0;
        if (course == null || lessons.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.menu_book_outlined,
            title: 'No Lessons Available',
            subtitle: 'No course lessons were found in the local course asset.',
          );
        }

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CourseHeaderCard(
                    course: course,
                    overallProgress: controller.overallProgress,
                    overallProgressPercent: controller.overallProgressPercent,
                  ),
                  16.vSpace,
                  ContinueLearningCard(
                    exerciseCount: sessionExerciseCount,
                    reviewCount: nextSession?.reviewCount ?? 0,
                    onStart: nextSession == null || sessionExerciseCount == 0
                        ? null
                        : () => context.push(
                            AppRoutes.practiceSession(
                              nextSession.items.first.lessonId,
                              startIndex: 0,
                              exerciseCount: nextSession.items.length,
                            ),
                            extra: nextSession.items,
                          ),
                  ),
                  10.vSpace,
                  ExamPracticeEntryCard(
                    onTap: () => context.push(AppRoutes.examPractice),
                  ),
                  24.vSpace,
                  Text(
                    'Course Lessons',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  12.vSpace,
                  for (
                    int index = 0;
                    index < lessons.length;
                    index++
                  ) ...<Widget>[
                    LessonCard(
                      key: ValueKey<String>(lessons[index].id),
                      lesson: lessons[index],
                      progress: controller.getLessonProgress(lessons[index].id),
                      progressPercent: controller.getLessonProgressPercent(
                        lessons[index].id,
                      ),
                      onTap: () {
                        context.push(AppRoutes.lessonDetail(lessons[index].id));
                      },
                    ),
                    if (index < lessons.length - 1) 12.vSpace,
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
