import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${grammarPoints.length} Grammar Guides',
          style: getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        12.vSpace,
        for (int i = 0; i < grammarPoints.length; i++) ...<Widget>[
          _GrammarPointCard(index: i + 1, point: grammarPoints[i]),
          if (i < grammarPoints.length - 1) 12.vSpace,
        ],
      ],
    );
  }
}

class _GrammarPointCard extends StatelessWidget {
  const _GrammarPointCard({
    required this.index,
    required this.point,
  });

  final int index;
  final GrammarPoint point;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final table = point.table;

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
              Container(
                width: 28.r,
                height: 28.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '$index',
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              10.hSpace,
              Expanded(
                child: Text(
                  point.title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          10.vSpace,
          Text(
            point.explanation,
            style: getTextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          if (point.examples.isNotEmpty) ...<Widget>[
            12.vSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Examples',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                  8.vSpace,
                  for (int i = 0; i < point.examples.length; i++) ...<Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            point.examples[i],
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                              height: 1.35,
                            ),
                          ),
                        ),
                        8.hSpace,
                        PronunciationIconButton(
                          text: point.examples[i],
                          size: 30,
                        ),
                      ],
                    ),
                    if (i < point.examples.length - 1) 8.vSpace,
                  ],
                ],
              ),
            ),
          ],
          if (table != null && table.isNotEmpty) ...<Widget>[
            12.vSpace,
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < table.entries.length; i++) ...<Widget>[
                      Builder(
                        builder: (BuildContext context) {
                          final entry = table.entries.elementAt(i);
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            color: i.isEven
                                ? colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.35)
                                : colorScheme.surface,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 108.w,
                                  child: Text(
                                    entry.key,
                                    style: getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                8.hSpace,
                                Expanded(
                                  child: Text(
                                    entry.value.join(' · '),
                                    style: getTextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (i < table.entries.length - 1)
                        Divider(height: 1, color: theme.dividerColor),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
