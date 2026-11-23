import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/lesson.dart';

class LessonHeaderSection extends StatelessWidget {
  const LessonHeaderSection({
    super.key,
    required this.lesson,
    required this.completedExercises,
    required this.onStartExercises,
  });

  final Lesson lesson;
  final int completedExercises;
  final VoidCallback onStartExercises;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalExercises = lesson.exercises.length;
    final progress = totalExercises == 0
        ? 0.0
        : completedExercises / totalExercises;
    final isComplete =
        totalExercises > 0 && completedExercises >= totalExercises;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      lesson.title,
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    4.vSpace,
                    Text(
                      '$completedExercises / $totalExercises Completed',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isComplete
                            ? AppColors.success
                            : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              12.hSpace,
              CustomButton(
                label: isComplete
                    ? 'Practice'
                    : completedExercises > 0
                    ? 'Continue'
                    : 'Start',
                icon: Icons.play_arrow_rounded,
                width: 126.w,
                height: 40,
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                onPressed: onStartExercises,
              ),
            ],
          ),
          12.vSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7.h,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? AppColors.success : colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
