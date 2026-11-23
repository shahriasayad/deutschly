import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/exam/controller/exam_practice_controller.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';
import 'package:deutschly/features/exam/widgets/exam_skill_card.dart';

class ExamPracticeScreen extends StatelessWidget {
  const ExamPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final controller = Get.isRegistered<ExamPracticeController>()
        ? Get.find<ExamPracticeController>()
        : Get.put(
            ExamPracticeController(
              courseController: Get.find<CourseController>(),
            ),
          );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'A1 Exam Practice',
        centerTitle: false,
      ),
      body: Obx(() {
        final course = Get.find<CourseController>().course.value;
        if (course == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(
                        alpha: 0.65,
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.school_rounded,
                              size: 22.r,
                              color: colorScheme.primary,
                            ),
                            8.hSpace,
                            Expanded(
                              child: Text(
                                'Practice all four exam skills',
                                style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        6.vSpace,
                        Text(
                          'Train Listening, Reading, Writing, and Speaking using your A1.1 course material. Independent practice aligned with Start Deutsch 1.',
                          style: getTextStyle(
                            fontSize: 13,
                            color: colorScheme.onPrimaryContainer,
                            height: 1.45,
                          ),
                        ),
                        12.vSpace,
                        Material(
                          color: colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            side: BorderSide(color: theme.dividerColor),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 4.h,
                            ),
                            child: Obx(
                              () => SwitchListTile.adaptive(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Timed section practice',
                                  style: getTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                subtitle: Text(
                                  controller.isTimedMode.value
                                      ? 'Countdown timer active per exam section.'
                                      : 'Practice at your own pace without a timer.',
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                value: controller.isTimedMode.value,
                                onChanged: controller.setTimedMode,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  18.vSpace,
                  Text(
                    'Exam Sections',
                    style: getTextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  12.vSpace,
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final isWide = constraints.maxWidth >= 600;
                      if (isWide) {
                        final cardWidth = (constraints.maxWidth - 12.w) / 2;
                        return Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          children: <Widget>[
                            for (final skill in ExamSkill.values)
                              SizedBox(
                                width: cardWidth,
                                child: ExamSkillCard(
                                  skill: skill,
                                  taskCount: controller.taskCount(skill),
                                  onStart: () => context.push(
                                    AppRoutes.examSection(
                                      skill.name,
                                      timed: controller.isTimedMode.value,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return Column(
                        children: <Widget>[
                          for (int i = 0; i < ExamSkill.values.length; i++) ...<Widget>[
                            ExamSkillCard(
                              skill: ExamSkill.values[i],
                              taskCount: controller.taskCount(
                                ExamSkill.values[i],
                              ),
                              onStart: () => context.push(
                                AppRoutes.examSection(
                                  ExamSkill.values[i].name,
                                  timed: controller.isTimedMode.value,
                                ),
                              ),
                            ),
                            if (i < ExamSkill.values.length - 1) 12.vSpace,
                          ],
                        ],
                      );
                    },
                  ),
                  14.vSpace,
                  Text(
                    'Section durations follow the published Goethe-Zertifikat A1: Start Deutsch 1 format. Listening audio uses your device’s German speech engine.',
                    style: getTextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
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
