import 'package:flutter/material.dart';
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
    final progress =
        totalExercises == 0 ? 0.0 : completedExercises / totalExercises;

    return Container(
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
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Lesson ${lesson.number}',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$completedExercises / $totalExercises Completed',
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          14.vSpace,
          Text(
            lesson.title,
            style: getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          4.vSpace,
          Text(
            lesson.titleBn,
            style: getTextStyle(
              fontSize: 15,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          16.vSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: <Widget>[
              _StatChip(
                icon: Icons.flag_outlined,
                label: '${lesson.objectives.length} Objectives',
              ),
              _StatChip(
                icon: Icons.translate_rounded,
                label: '${lesson.vocabulary.length} Words',
              ),
              _StatChip(
                icon: Icons.auto_stories_outlined,
                label: '${lesson.grammar.length} Grammar',
              ),
              _StatChip(
                icon: Icons.forum_outlined,
                label: '${lesson.dialogues.length} Dialogues',
              ),
              _StatChip(
                icon: Icons.quiz_outlined,
                label: '${lesson.exercises.length} Exercises',
              ),
            ],
          ),
          16.vSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7.h,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          16.vSpace,
          CustomButton(
            label: 'Start Exercises',
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            onPressed: onStartExercises,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15.r, color: colorScheme.primary),
          6.hSpace,
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
