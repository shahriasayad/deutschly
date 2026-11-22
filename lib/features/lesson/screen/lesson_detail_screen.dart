import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({
    super.key,
    required this.lessonId,
  });

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final courseController = Get.find<CourseController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final lessons = courseController.course.value?.lessons ?? const <Lesson>[];
      final lesson = lessons.firstWhereOrNull(
        (Lesson item) => item.id == lessonId,
      );

      if (lesson == null) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Lesson Detail'),
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
        appBar: CustomAppBar(title: 'Lesson ${lesson.number}'),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                lesson.title,
                style: getTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                lesson.titleBn,
                style: getTextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Lesson Detail Placeholder',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vocabulary: ${lesson.vocabulary.length} items\n'
                      'Grammar Points: ${lesson.grammar.length}\n'
                      'Dialogues: ${lesson.dialogues.length}\n'
                      'Exercises: ${lesson.exercises.length}',
                      style: getTextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
