import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/lesson.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.progress,
    required this.progressPercent,
    required this.onTap,
    this.isCurrentFocus = false,
    this.isFirst = false,
    this.isLast = false,
  });

  final Lesson lesson;
  final double progress;
  final int progressPercent;
  final VoidCallback onTap;
  final bool isCurrentFocus;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = progressPercent == 100;
    final isStarted = progressPercent > 0 && !isCompleted;

    final nodeColor = isCompleted
        ? AppColors.success
        : isCurrentFocus || isStarted
        ? colorScheme.primary
        : theme.dividerColor;

    final statusLabel = isCompleted
        ? 'Mastered'
        : isStarted
        ? 'In progress'
        : isCurrentFocus
        ? 'Up next'
        : null;

    final statusBg = isCompleted
        ? AppColors.success.withValues(alpha: 0.14)
        : colorScheme.primaryContainer;
    final statusFg = isCompleted ? AppColors.success : colorScheme.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 32.w,
            child: Column(
              children: <Widget>[
                Container(
                  width: 2.w,
                  height: 22.h,
                  color: isFirst ? Colors.transparent : theme.dividerColor,
                ),
                Container(
                  width: 28.r,
                  height: 28.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success
                        : isCurrentFocus || isStarted
                        ? colorScheme.primary
                        : colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: nodeColor,
                      width: (isCurrentFocus ? 2.5 : 1.5).w,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(
                          Icons.check_rounded,
                          size: 16.r,
                          color: Colors.white,
                        )
                      : Text(
                          '${lesson.number}',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isCurrentFocus || isStarted
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: isLast ? Colors.transparent : theme.dividerColor,
                  ),
                ),
              ],
            ),
          ),
          10.hSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  side: BorderSide(
                    color: isCurrentFocus
                        ? colorScheme.primary.withValues(alpha: 0.55)
                        : isCompleted
                        ? AppColors.success.withValues(alpha: 0.4)
                        : theme.dividerColor,
                    width: isCurrentFocus ? 1.5.w : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
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
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Lesson ${lesson.number}',
                                        style: getTextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      if (statusLabel != null) ...<Widget>[
                                        8.hSpace,
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusBg,
                                            borderRadius: BorderRadius.circular(
                                              999.r,
                                            ),
                                          ),
                                          child: Text(
                                            statusLabel,
                                            style: getTextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: statusFg,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  4.vSpace,
                                  Text(
                                    lesson.title,
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  2.vSpace,
                                  Text(
                                    lesson.titleBn,
                                    style: getTextStyle(
                                      fontSize: 13,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            8.hSpace,
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 22.r,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                        12.vSpace,
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 4.h,
                          children: <Widget>[
                            _LessonMetaItem(
                              icon: Icons.translate_rounded,
                              text: '${lesson.vocabulary.length} words',
                            ),
                            _LessonMetaItem(
                              icon: Icons.auto_stories_outlined,
                              text: '${lesson.grammar.length} grammar',
                            ),
                            _LessonMetaItem(
                              icon: Icons.quiz_outlined,
                              text: '${lesson.exercises.length} exercises',
                            ),
                          ],
                        ),
                        10.vSpace,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999.r),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6.h,
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isCompleted
                                        ? AppColors.success
                                        : colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            10.hSpace,
                            Text(
                              '$progressPercent%',
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isCompleted
                                    ? AppColors.success
                                    : colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonMetaItem extends StatelessWidget {
  const _LessonMetaItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14.r, color: colorScheme.onSurfaceVariant),
        4.hSpace,
        Text(
          text,
          style: getTextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
