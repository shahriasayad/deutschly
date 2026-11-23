import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/widgets/reset_progress_dialog.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final progressController = Get.isRegistered<ProgressController>()
        ? Get.find<ProgressController>()
        : Get.put(ProgressController());
    final courseController = Get.find<CourseController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your Progress',
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            key: const ValueKey<String>('progress_about_icon_btn'),
            icon: const Icon(Icons.info_outline_rounded),
            tooltip: 'About & Info',
            onPressed: () => context.push(AppRoutes.about),
          ),
          IconButton(
            key: const ValueKey<String>('progress_reset_icon_btn'),
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Reset Progress',
            onPressed: () async {
              final confirmed = await showResetProgressDialog(context);
              if (confirmed) {
                await progressController.resetAllProgress();
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (courseController.isLoading.value &&
            courseController.course.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final lessons =
            courseController.course.value?.lessons ?? const <Lesson>[];
        if (lessons.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.insights_outlined,
            title: 'Progress Unavailable',
            subtitle:
                courseController.errorMessage.value ??
                'No course lessons were found.',
            actionLabel: courseController.errorMessage.value != null
                ? 'Retry'
                : null,
            onAction: courseController.errorMessage.value != null
                ? courseController.loadCourse
                : null,
          );
        }
        final overallRatio = progressController.overallCourseProgress;
        final overallPercent = progressController.overallCourseProgressPercent;
        final completedTotal = progressController.totalCompletedExercises;
        final courseTotal = progressController.totalCourseExercises;
        final masteredLessons = lessons
            .where(
              (Lesson lesson) =>
                  progressController.getLessonProgressPercent(
                    lesson.id,
                    totalExercises: lesson.exercises.length,
                  ) ==
                  100,
            )
            .length;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Overall Course Progress',
                                style: getTextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Text(
                              '$overallPercent%',
                              style: getTextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        6.vSpace,
                        Text(
                          '$completedTotal of $courseTotal exercises completed',
                          style: getTextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        14.vSpace,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999.r),
                          child: LinearProgressIndicator(
                            value: overallRatio,
                            minHeight: 9.h,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                          ),
                        ),
                        16.vSpace,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _ProgressStatPill(
                                label: 'Lessons Mastered',
                                value: '$masteredLessons / ${lessons.length}',
                              ),
                            ),
                            10.hSpace,
                            Expanded(
                              child: _ProgressStatPill(
                                label: 'Abilities Checked',
                                value:
                                    '${progressController.completedCanDoObjectives} / ${progressController.totalCanDoObjectives}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  24.vSpace,
                  _CanDoProgressSection(
                    lessons: lessons,
                    controller: progressController,
                  ),
                  24.vSpace,
                  Text(
                    'Lesson Breakdown',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  4.vSpace,
                  Text(
                    'Tap any lesson to continue studying or practicing.',
                    style: getTextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  12.vSpace,
                  for (int i = 0; i < lessons.length; i++) ...<Widget>[
                    Builder(
                      builder: (BuildContext context) {
                        final lesson = lessons[i];
                        final completed = progressController.getCompletedCount(
                          lesson.id,
                        );
                        final total = lesson.exercises.length;
                        final ratio = progressController.getLessonProgressRatio(
                          lesson.id,
                          totalExercises: total,
                        );
                        final percent = progressController
                            .getLessonProgressPercent(
                              lesson.id,
                              totalExercises: total,
                            );

                        return Material(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          child: InkWell(
                            onTap: () =>
                                context.push(AppRoutes.lessonDetail(lesson.id)),
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Lesson ${lesson.number}: ${lesson.title}',
                                          style: getTextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      8.hSpace,
                                      Text(
                                        '$completed / $total ($percent%)',
                                        style: getTextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: percent == 100
                                              ? AppColors.success
                                              : colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.vSpace,
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999.r),
                                    child: LinearProgressIndicator(
                                      value: ratio,
                                      minHeight: 6.h,
                                      backgroundColor:
                                          colorScheme.surfaceContainerHighest,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        percent == 100
                                            ? AppColors.success
                                            : colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (i < lessons.length - 1) 10.vSpace,
                  ],
                  24.vSpace,
                  CustomButton(
                    key: const ValueKey<String>('reset_progress_full_btn'),
                    label: 'Reset Progress',
                    icon: Icons.restart_alt_rounded,
                    backgroundColor: AppColors.error,
                    textColor: Colors.white,
                    onPressed: () async {
                      final confirmed = await showResetProgressDialog(context);
                      if (confirmed) {
                        await progressController.resetAllProgress();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ProgressStatPill extends StatelessWidget {
  const _ProgressStatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          2.vSpace,
          Text(
            label,
            style: getTextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CanDoProgressSection extends StatelessWidget {
  const _CanDoProgressSection({
    required this.lessons,
    required this.controller,
  });

  final List<Lesson> lessons;
  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = controller.totalCanDoObjectives;
    final completed = controller.completedCanDoObjectives;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'What you can do',
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        6.vSpace,
        Text(
          'Check an ability when you can do it without help. Synced with each lesson overview.',
          style: getTextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        12.vSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$completed of $total abilities',
                    style: getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '${controller.canDoProgressPercent}%',
                    style: getTextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              10.vSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: controller.canDoProgressRatio,
                  minHeight: 7.h,
                  backgroundColor: colorScheme.surface.withValues(alpha: 0.55),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        12.vSpace,
        for (final lesson in lessons) ...<Widget>[
          Material(
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(color: theme.dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
              childrenPadding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
              title: Text(
                'Lesson ${lesson.number}: ${lesson.title}',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                '${controller.getCanDoObjectiveCount(lesson)} of ${lesson.objectives.length} abilities',
                style: getTextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              children: <Widget>[
                for (int index = 0; index < lesson.objectives.length; index++)
                  CheckboxListTile(
                    key: ValueKey<String>('can_do_${lesson.id}_$index'),
                    value: controller.canDoObjective(
                      lesson.id,
                      lesson.objectives[index],
                    ),
                    onChanged: (bool? value) {
                      if (value == null) {
                        return;
                      }
                      controller.setCanDoObjective(
                        lessonId: lesson.id,
                        objective: lesson.objectives[index],
                        canDo: value,
                      );
                    },
                    title: Text(
                      lesson.objectives[index],
                      style: getTextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface,
                        height: 1.35,
                      ),
                    ),
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  ),
              ],
            ),
          ),
          if (lesson != lessons.last) 8.vSpace,
        ],
      ],
    );
  }
}
