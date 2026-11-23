import 'package:flutter/material.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';

class RandomVocabularyBannerCard extends StatelessWidget {
  const RandomVocabularyBannerCard({
    super.key,
    required this.dueCount,
    required this.masteredCount,
    required this.strugglingCount,
    required this.totalWords,
    required this.onTap,
    this.compact = false,
  });

  final int dueCount;
  final int masteredCount;
  final int strugglingCount;
  final int totalWords;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasStruggling = strugglingCount > 0;
    final accentStatus = hasStruggling
        ? LearningStatus.struggling
        : dueCount > 0
        ? LearningStatus.good
        : LearningStatus.mastered;
    final accentColor = AppColors.statusColor(context, accentStatus);
    final accentBg = AppColors.statusContainerColor(context, accentStatus);

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(compact ? 14.w : 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: compact ? 38.r : 42.r,
                height: compact ? 38.r : 42.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.shuffle_rounded,
                  size: compact ? 20.r : 22.r,
                  color: accentColor,
                ),
              ),
              12.hSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Random Vocabulary',
                      style: getTextStyle(
                        fontSize: compact ? 14 : 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    2.vSpace,
                    Text(
                      dueCount > 0
                          ? '$dueCount due · $masteredCount/$totalWords mastered'
                          : 'Spaced flashcards · $masteredCount/$totalWords mastered',
                      style: getTextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              8.hSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Practice',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
