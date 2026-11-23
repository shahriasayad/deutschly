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
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onStartAllExercises,
    required this.onSelectExercise,
  });

  final List<Exercise> exercises;
  final Set<String> completedExerciseIds;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onStartAllExercises;
  final ValueChanged<int> onSelectExercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final completedCount = exercises
        .where((Exercise ex) => completedExerciseIds.contains(ex.id))
        .length;
    final todoCount = exercises.length - completedCount;

    final indexedExercises = <({int originalIndex, Exercise exercise})>[
      for (int i = 0; i < exercises.length; i++)
        if (selectedFilter == 'all' ||
            (selectedFilter == 'todo' &&
                !completedExerciseIds.contains(exercises[i].id)) ||
            (selectedFilter == 'completed' &&
                completedExerciseIds.contains(exercises[i].id)))
          (originalIndex: i, exercise: exercises[i]),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomButton(
          label: completedCount > 0 && completedCount < exercises.length
              ? 'Continue Next Exercise'
              : 'Start Exercises',
          icon: Icons.play_arrow_rounded,
          backgroundColor: colorScheme.primary,
          textColor: colorScheme.onPrimary,
          onPressed: onStartAllExercises,
        ),
        14.vSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _ExerciseFilterPill(
                label: 'All (${exercises.length})',
                isSelected: selectedFilter == 'all',
                onTap: () => onFilterChanged('all'),
              ),
              8.hSpace,
              _ExerciseFilterPill(
                label: 'To do ($todoCount)',
                isSelected: selectedFilter == 'todo',
                onTap: () => onFilterChanged('todo'),
              ),
              8.hSpace,
              _ExerciseFilterPill(
                label: 'Completed ($completedCount)',
                isSelected: selectedFilter == 'completed',
                onTap: () => onFilterChanged('completed'),
              ),
            ],
          ),
        ),
        14.vSpace,
        if (indexedExercises.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Text(
              selectedFilter == 'todo'
                  ? 'Every exercise in this lesson is completed!'
                  : 'Complete an exercise to see it here.',
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (int i = 0; i < indexedExercises.length; i++) ...<Widget>[
            _ExerciseListTile(
              index: indexedExercises[i].originalIndex,
              exercise: indexedExercises[i].exercise,
              isCompleted: completedExerciseIds.contains(
                indexedExercises[i].exercise.id,
              ),
              onTap: () => onSelectExercise(indexedExercises[i].originalIndex),
            ),
            if (i < indexedExercises.length - 1) 10.vSpace,
          ],
      ],
    );
  }
}

class _ExerciseFilterPill extends StatelessWidget {
  const _ExerciseFilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? colorScheme.primary : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
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
    final statusColor = isCompleted
        ? AppColors.success
        : colorScheme.onSurfaceVariant;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: 0.45)
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
                      ? AppColors.success.withValues(alpha: 0.14)
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
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6.r),
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
      ),
    );
  }
}
