import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/grammar_point.dart';

class LessonGrammarSection extends StatelessWidget {
  const LessonGrammarSection({
    super.key,
    required this.grammarPoints,
  });

  final List<GrammarPoint> grammarPoints;

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
                Icons.auto_stories_outlined,
                color: colorScheme.primary,
                size: 20.r,
              ),
              8.hSpace,
              Text(
                'Grammar (${grammarPoints.length})',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          14.vSpace,
          for (int i = 0; i < grammarPoints.length; i++) ...<Widget>[
            _GrammarPointCard(point: grammarPoints[i]),
            if (i < grammarPoints.length - 1) 12.vSpace,
          ],
        ],
      ),
    );
  }
}

class _GrammarPointCard extends StatelessWidget {
  const _GrammarPointCard({required this.point});

  final GrammarPoint point;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final table = point.table;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            point.title,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          4.vSpace,
          Text(
            point.explanation,
            style: getTextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          if (point.examples.isNotEmpty) ...<Widget>[
            10.vSpace,
            for (final String example in point.examples)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 6.h),
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    8.hSpace,
                    Expanded(
                      child: Text(
                        example,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (table != null && table.isNotEmpty) ...<Widget>[
            12.vSpace,
            for (final MapEntry<String, List<String>> entry
                in table.entries) ...<Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.key,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                    4.vSpace,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: entry.value
                          .map(
                            (String form) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              child: Text(
                                form,
                                style: getTextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
