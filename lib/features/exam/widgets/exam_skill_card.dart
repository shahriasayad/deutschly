import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/exam/models/exam_skill.dart';

class ExamSkillCard extends StatelessWidget {
  const ExamSkillCard({
    super.key,
    required this.skill,
    required this.taskCount,
    required this.onStart,
  });

  final ExamSkill skill;
  final int taskCount;
  final VoidCallback? onStart;

  IconData get _icon => switch (skill) {
    ExamSkill.listening => Icons.headphones_rounded,
    ExamSkill.reading => Icons.menu_book_rounded,
    ExamSkill.writing => Icons.edit_note_rounded,
    ExamSkill.speaking => Icons.record_voice_over_rounded,
  };

  Color _accentColor(ColorScheme colorScheme) => switch (skill) {
    ExamSkill.listening => colorScheme.primary,
    ExamSkill.reading => AppColors.accent,
    ExamSkill.writing => AppColors.secondary,
    ExamSkill.speaking => const Color(0xFF7C3AED),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = _accentColor(colorScheme);

    return Container(
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
            children: <Widget>[
              Container(
                width: 44.r,
                height: 44.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(_icon, size: 22.r, color: accent),
              ),
              12.hSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      skill.title,
                      style: getTextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      skill.germanTitle,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  '${skill.durationMinutes} min',
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          12.vSpace,
          Text(
            skill.description,
            style: getTextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          14.vSpace,
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '$taskCount practice ${taskCount == 1 ? 'task' : 'tasks'}',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              CustomButton(
                label: 'Start section',
                icon: Icons.play_arrow_rounded,
                width: 152.w,
                height: 40,
                backgroundColor: colorScheme.primary,
                textColor: colorScheme.onPrimary,
                onPressed: taskCount == 0 ? null : onStart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
