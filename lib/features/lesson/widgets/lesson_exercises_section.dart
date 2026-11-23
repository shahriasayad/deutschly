import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/features/lesson/controller/lesson_detail_controller.dart';

class LessonExercisesSection extends StatelessWidget {
  const LessonExercisesSection({
    super.key,
    required this.exercises,
    required this.completedExerciseIds,
    required this.onStartAllExercises,
    required this.onSelectExercise,
  });

  final List<Exercise> exercises;
  final Set<String> completedExerciseIds;
  final VoidCallback onStartAllExercises;
  final ValueChanged<int> onSelectExercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.quiz_outlined,
                color: colorScheme.primary,
                size: 20.r,
              ),
              8.hSpace,
              Expanded(
                child: Text(
                  'Exercises (${exercises.length})',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          14.vSpace,
          for (int i = 0; i < exercises.length; i++) ...<Widget>[
            _ExerciseListTile(
              index: i,
              exercise: exercises[i],
              isCompleted: completedExerciseIds.contains(exercises[i].id),
              onTap: () => onSelectExercise(i),
            ),
            if (i < exercises.length - 1) 10.vSpace,
          ],
          16.vSpace,
          CustomButton(
            label: 'Start Exercises',
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            onPressed: onStartAllExercises,
          ),
        ],
      ),
    );
  }
}

class _ExerciseListTile extends StatelessWidget {
  const _ExerciseListTile({
    required this.index,
    required this.exercise,
    required this.isCompleted,
    required this.onTap,
  });

  final int index;
  final Exercise exercise;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor =
        isCompleted ? AppColors.success : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.5)
                : theme.dividerColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 32.r,
              height: 32.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.15)
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 18.r,
                      color: AppColors.success,
                    )
                  : Text(
                      '${index + 1}',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
            ),
            12.hSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Text(
                          LessonDetailController.formatExerciseType(
                            exercise.type,
                          ),
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        isCompleted ? 'Completed' : 'Not started',
                        style: getTextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  6.vSpace,
                  Text(
                    exercise.question,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
