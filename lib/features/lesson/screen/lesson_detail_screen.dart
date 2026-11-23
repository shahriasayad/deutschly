import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/lesson/controller/lesson_detail_controller.dart';
import 'package:deutschly/features/lesson/widgets/lesson_dialogues_section.dart';
import 'package:deutschly/features/lesson/widgets/lesson_exercises_section.dart';
import 'package:deutschly/features/lesson/widgets/lesson_grammar_section.dart';
import 'package:deutschly/features/lesson/widgets/lesson_header_section.dart';
import 'package:deutschly/features/lesson/widgets/lesson_objectives_section.dart';
import 'package:deutschly/features/lesson/widgets/lesson_vocabulary_section.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  static const List<({String key, String label, IconData icon})> _tabs =
      <({String key, String label, IconData icon})>[
        (key: 'overview', label: 'Overview', icon: Icons.dashboard_outlined),
        (key: 'words', label: 'Words', icon: Icons.translate_rounded),
        (key: 'grammar', label: 'Grammar', icon: Icons.auto_stories_outlined),
        (key: 'dialogues', label: 'Dialogues', icon: Icons.forum_outlined),
        (key: 'exercises', label: 'Exercises', icon: Icons.quiz_outlined),
      ];

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final controller = Get.put(
      LessonDetailController(lessonId: lessonId),
      tag: lessonId,
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final lesson = controller.lesson;

      if (lesson == null) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Lesson Detail',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => _handleBack(context),
            ),
          ),
          body: Center(
            child: Text(
              'Lesson not found.',
              style: getTextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }

      final activeTab = controller.selectedTabIndex.value;
      final completedIds = controller.completedExerciseIds;

      return Scaffold(
        appBar: CustomAppBar(
          title: 'Lesson ${lesson.number}',
          subtitle: lesson.titleBn,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back',
            onPressed: () => _handleBack(context),
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: LessonHeaderSection(
                    lesson: lesson,
                    completedExercises: controller.completedCount,
                    onStartExercises: lesson.exercises.isEmpty
                        ? null
                        : () {
                            context.push(
                              AppRoutes.lessonExercises(
                                lesson.id,
                                initialIndex:
                                    controller.nextUncompletedExerciseIndex,
                              ),
                            );
                          },
                  ),
                ),
                12.vSpace,
                SizedBox(
                  height: 42.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    separatorBuilder: (_, _) => 8.hSpace,
                    itemBuilder: (BuildContext context, int index) {
                      final tab = _tabs[index];
                      final isSelected = activeTab == index;
                      return InkWell(
                        key: ValueKey<String>('lesson_tab_${tab.key}'),
                        onTap: () => controller.selectTab(index),
                        borderRadius: BorderRadius.circular(999.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surface,
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : theme.dividerColor,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                tab.icon,
                                size: 16.r,
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              6.hSpace,
                              Text(
                                tab.label,
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                12.vSpace,
                Expanded(
                  child: SingleChildScrollView(
                    key: ValueKey<String>('lesson_tab_body_$activeTab'),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                    child: switch (activeTab) {
                      0 => LessonObjectivesSection(
                        lesson: lesson,
                        completedExercises: controller.completedCount,
                        canDoCount: controller.canDoCount,
                        isObjectiveChecked: controller.canDoObjective,
                        onToggleObjective: (String objective, bool value) {
                          controller.toggleCanDoObjective(objective, value);
                        },
                        onSelectSection: controller.selectTab,
                      ),
                      1 => LessonVocabularySection(
                        lessonId: lesson.id,
                        vocabulary: lesson.vocabulary,
                        hideMeanings: controller.hideVocabularyMeanings.value,
                        revealedWordKeys: controller.revealedWordKeys.toSet(),
                        onToggleHideMeanings:
                            controller.toggleHideVocabularyMeanings,
                        onToggleWordReveal: controller.toggleWordReveal,
                      ),
                      2 => LessonGrammarSection(grammarPoints: lesson.grammar),
                      3 => LessonDialoguesSection(
                        lessonId: lesson.id,
                        dialogues: lesson.dialogues,
                        hideTranslations:
                            controller.hideDialogueTranslations.value,
                        revealedLineKeys:
                            controller.revealedDialogueKeys.toSet(),
                        onToggleHideTranslations:
                            controller.toggleHideDialogueTranslations,
                        onToggleLineReveal: controller.toggleDialogueLineReveal,
                      ),
                      _ => LessonExercisesSection(
                        exercises: lesson.exercises,
                        completedExerciseIds: completedIds,
                        selectedFilter: controller.exerciseFilter.value,
                        onFilterChanged: controller.setExerciseFilter,
                        onStartAllExercises: () {
                          context.push(
                            AppRoutes.lessonExercises(
                              lesson.id,
                              initialIndex:
                                  controller.nextUncompletedExerciseIndex,
                            ),
                          );
                        },
                        onSelectExercise: (int index) {
                          context.push(
                            AppRoutes.lessonExercises(
                              lesson.id,
                              initialIndex: index,
                            ),
                          );
                        },
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
