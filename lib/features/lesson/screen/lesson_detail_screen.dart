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
  const LessonDetailScreen({
    super.key,
    required this.lessonId,
  });

  final String lessonId;

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
    final colorScheme = Theme.of(context).colorScheme;

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

      return Scaffold(
        appBar: CustomAppBar(
          title: 'Lesson ${lesson.number}',
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
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LessonHeaderSection(
                    lesson: lesson,
                    completedExercises: controller.completedCount,
                    onStartExercises: () {
                      context.push(AppRoutes.lessonExercises(lesson.id));
                    },
                  ),
                  16.vSpace,
                  LessonObjectivesSection(objectives: lesson.objectives),
                  16.vSpace,
                  LessonVocabularySection(
                    vocabulary: lesson.vocabulary,
                    isExpanded: controller.isVocabularyExpanded.value,
                    onToggleExpanded: controller.toggleVocabularyExpanded,
                  ),
                  16.vSpace,
                  LessonGrammarSection(grammarPoints: lesson.grammar),
                  16.vSpace,
                  LessonDialoguesSection(dialogues: lesson.dialogues),
                  16.vSpace,
                  LessonExercisesSection(
                    exercises: lesson.exercises,
                    completedExerciseIds:
                        controller.completedExerciseIds.toSet(),
                    onStartAllExercises: () {
                      context.push(AppRoutes.lessonExercises(lesson.id));
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
