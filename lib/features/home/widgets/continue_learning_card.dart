import 'package:flutter/material.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    super.key,
    required this.exerciseCount,
    required this.reviewCount,
    required this.onStart,
  });

  final int exerciseCount;
  final int reviewCount;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasSession = exerciseCount > 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: hasSession
              ? colorScheme.secondary.withValues(alpha: 0.45)
              : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 36.r,
                height: 36.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  size: 20.r,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              12.hSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Continue learning',
                      style: getTextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      hasSession
                          ? 'Daily 2-minute spaced practice'
                          : 'All course exercises completed',
                      style: getTextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasSession)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '$exerciseCount tasks',
                    style: getTextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
            ],
          ),
          12.vSpace,
          Text(
            hasSession
                ? reviewCount > 0
                      ? '$reviewCount review ${reviewCount == 1 ? 'item is' : 'items are'} due, paired with ${exerciseCount - reviewCount} new ${exerciseCount - reviewCount == 1 ? 'exercise' : 'exercises'}.'
                      : 'A focused session with $exerciseCount new ${exerciseCount == 1 ? 'exercise' : 'exercises'} from your next lesson.'
                : 'You have completed every lesson exercise. Revisit any lesson or test yourself in Exam Prep.',
            style: getTextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          14.vSpace,
          CustomButton(
            label: hasSession ? 'Start short practice' : 'Course complete',
            icon: hasSession ? Icons.play_arrow_rounded : Icons.verified_rounded,
            onPressed: onStart,
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
