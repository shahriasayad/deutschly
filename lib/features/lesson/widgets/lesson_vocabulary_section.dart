import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';

class LessonVocabularySection extends StatelessWidget {
  const LessonVocabularySection({
    super.key,
    required this.vocabulary,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  final List<VocabularyItem> vocabulary;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

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
          InkWell(
            onTap: onToggleExpanded,
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.translate_rounded,
                  color: colorScheme.primary,
                  size: 20.r,
                ),
                8.hSpace,
                Expanded(
                  child: Text(
                    'Vocabulary (${vocabulary.length})',
                    style: getTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 22.r,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          if (isExpanded) ...<Widget>[
            14.vSpace,
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isWide = constraints.maxWidth >= 600;
                if (isWide) {
                  final itemWidth = (constraints.maxWidth - 12.w) / 2;
                  return Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: vocabulary
                        .map(
                          (VocabularyItem item) => SizedBox(
                            width: itemWidth,
                            child: _VocabularyTile(item: item),
                          ),
                        )
                        .toList(),
                  );
                }
                return Column(
                  children: <Widget>[
                    for (int i = 0; i < vocabulary.length; i++) ...<Widget>[
                      _VocabularyTile(item: vocabulary[i]),
                      if (i < vocabulary.length - 1) 10.vSpace,
                    ],
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _VocabularyTile extends StatelessWidget {
  const _VocabularyTile({required this.item});

  final VocabularyItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.de,
                  style: getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (item.pronunciationBn?.isNotEmpty == true) ...<Widget>[
                  3.vSpace,
                  Text(
                    'উচ্চারণ (আনুমানিক): ${item.pronunciationBn}',
                    style: getTextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                4.vSpace,
                Text(
                  item.en,
                  style: getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          12.hSpace,
          Flexible(
            child: Text(
              item.bn,
              style: getTextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
