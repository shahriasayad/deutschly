import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_router.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                  const SizedBox(height: 16),
                  LessonObjectivesSection(objectives: lesson.objectives),
                  const SizedBox(height: 16),
                  LessonVocabularySection(
                    vocabulary: lesson.vocabulary,
                    isExpanded: controller.isVocabularyExpanded.value,
                    onToggleExpanded: controller.toggleVocabularyExpanded,
                  ),
                  const SizedBox(height: 16),
                  LessonGrammarSection(grammarPoints: lesson.grammar),
                  const SizedBox(height: 16),
                  LessonDialoguesSection(dialogues: lesson.dialogues),
                  const SizedBox(height: 16),
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
