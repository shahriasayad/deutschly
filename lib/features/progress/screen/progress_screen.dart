import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';
import 'package:deutschly/features/progress/widgets/reset_progress_dialog.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressController = Get.isRegistered<ProgressController>()
        ? Get.find<ProgressController>()
        : Get.put(ProgressController());
    final courseController = Get.find<CourseController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your Progress',
        actions: <Widget>[
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
        final lessons =
            courseController.course.value?.lessons ?? const <Lesson>[];
        final overallRatio = progressController.overallCourseProgress;
        final overallPercent = progressController.overallCourseProgressPercent;
        final completedTotal = progressController.totalCompletedExercises;
        final courseTotal = progressController.totalCourseExercises;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Overall Course Progress',
                              style: getTextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '$overallPercent%',
                              style: getTextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$completedTotal of $courseTotal exercises completed',
                          style: getTextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: overallRatio,
                            minHeight: 9,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _CanDoProgressSection(
                    lessons: lessons,
                    controller: progressController,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Lesson Breakdown',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
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

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
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
                                  const SizedBox(width: 8),
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
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: ratio,
                                  minHeight: 6,
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
                        );
                      },
                    ),
                    if (i < lessons.length - 1) const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 24),
                  CustomButton(
                    key: const ValueKey<String>('reset_progress_full_btn'),
                    label: 'Reset Progress',
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
        const SizedBox(height: 6),
        Text(
          'Check an ability when you can do it without help. Your self-checks are saved on this device.',
          style: getTextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: controller.canDoProgressRatio,
                  minHeight: 7,
                  backgroundColor: colorScheme.surface.withValues(alpha: 0.55),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final lesson in lessons) ...<Widget>[
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
              ],
            ),
          ),
          if (lesson != lessons.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}
