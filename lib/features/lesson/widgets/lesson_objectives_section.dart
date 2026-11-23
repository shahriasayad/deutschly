import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/lesson.dart';

class LessonObjectivesSection extends StatelessWidget {
  const LessonObjectivesSection({
    super.key,
    required this.lesson,
    required this.completedExercises,
    required this.canDoCount,
    required this.isObjectiveChecked,
    required this.onToggleObjective,
    required this.onSelectSection,
  });

  final Lesson lesson;
  final int completedExercises;
  final int canDoCount;
  final bool Function(String objective) isObjectiveChecked;
  final void Function(String objective, bool value) onToggleObjective;
  final ValueChanged<int> onSelectSection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Study Modules',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        10.vSpace,
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final itemWidth = (constraints.maxWidth - 10.w) / 2;
            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: <Widget>[
                SizedBox(
                  width: itemWidth,
                  child: _ModuleShortcutCard(
                    icon: Icons.translate_rounded,
                    title: 'Words',
                    subtitle: '${lesson.vocabulary.length} key terms',
                    accentColor: colorScheme.primary,
                    onTap: () => onSelectSection(1),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _ModuleShortcutCard(
                    icon: Icons.auto_stories_outlined,
                    title: 'Grammar',
                    subtitle: '${lesson.grammar.length} rules & tables',
                    accentColor: AppColors.secondary,
                    onTap: () => onSelectSection(2),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _ModuleShortcutCard(
                    icon: Icons.forum_outlined,
                    title: 'Dialogues',
                    subtitle: '${lesson.dialogues.length} conversations',
                    accentColor: AppColors.accent,
                    onTap: () => onSelectSection(3),
                  ),
                ),
                SizedBox(
                  width: itemWidth,
                  child: _ModuleShortcutCard(
                    icon: Icons.quiz_outlined,
                    title: 'Exercises',
                    subtitle:
                        '$completedExercises/${lesson.exercises.length} completed',
                    accentColor: AppColors.success,
                    onTap: () => onSelectSection(4),
                  ),
                ),
              ],
            );
          },
        ),
        18.vSpace,
        Material(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
            side: BorderSide(color: theme.dividerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.task_alt_rounded,
                      color: colorScheme.primary,
                      size: 20.r,
                    ),
                    8.hSpace,
                    Expanded(
                      child: Text(
                        'Can-Do Checklist',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        '$canDoCount / ${lesson.objectives.length}',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                6.vSpace,
                Text(
                  'Tick each skill once you can use it confidently without hints.',
                  style: getTextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                8.vSpace,
                for (int i = 0; i < lesson.objectives.length; i++) ...<Widget>[
                  CheckboxListTile(
                    value: isObjectiveChecked(lesson.objectives[i]),
                    onChanged: (bool? value) {
                      if (value != null) {
                        onToggleObjective(lesson.objectives[i], value);
                      }
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      lesson.objectives[i],
                      style: getTextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface,
                        height: 1.35,
                      ),
                    ),
                  ),
                  if (i < lesson.objectives.length - 1)
                    Divider(height: 1, color: theme.dividerColor),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ModuleShortcutCard extends StatelessWidget {
  const _ModuleShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 36.r,
                height: 36.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 19.r, color: accentColor),
              ),
              10.vSpace,
              Text(
                title,
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              2.vSpace,
              Text(
                subtitle,
                style: getTextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
