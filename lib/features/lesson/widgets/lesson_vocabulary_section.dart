import 'package:flutter/material.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';

class LessonVocabularySection extends StatelessWidget {
  const LessonVocabularySection({
    super.key,
    required this.lessonId,
    required this.vocabulary,
    required this.hideMeanings,
    required this.revealedWordKeys,
    required this.onToggleHideMeanings,
    required this.onToggleWordReveal,
  });

  final String lessonId;
  final List<VocabularyItem> vocabulary;
  final bool hideMeanings;
  final Set<String> revealedWordKeys;
  final VoidCallback onToggleHideMeanings;
  final ValueChanged<String> onToggleWordReveal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${vocabulary.length} Vocabulary Words',
                style: getTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            InkWell(
              onTap: onToggleHideMeanings,
              borderRadius: BorderRadius.circular(999.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: hideMeanings
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: hideMeanings
                        ? colorScheme.primary
                        : theme.dividerColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      hideMeanings
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 15.r,
                      color: colorScheme.primary,
                    ),
                    6.hSpace,
                    Text(
                      hideMeanings ? 'Flashcard: ON' : 'Flashcard: OFF',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        12.vSpace,
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final isWide = constraints.maxWidth >= 600;
            if (isWide) {
              final itemWidth = (constraints.maxWidth - 12.w) / 2;
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: vocabulary.map((VocabularyItem item) {
                  final wordKey = '${lessonId}_${item.de}';
                  final isRevealed =
                      !hideMeanings || revealedWordKeys.contains(wordKey);
                  return SizedBox(
                    width: itemWidth,
                    child: _VocabularyTile(
                      item: item,
                      isRevealed: isRevealed,
                      isFlashcardMode: hideMeanings,
                      onTap: hideMeanings
                          ? () => onToggleWordReveal(wordKey)
                          : null,
                    ),
                  );
                }).toList(),
              );
            }
            return Column(
              children: <Widget>[
                for (int i = 0; i < vocabulary.length; i++) ...<Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      final item = vocabulary[i];
                      final wordKey = '${lessonId}_${item.de}';
                      final isRevealed =
                          !hideMeanings || revealedWordKeys.contains(wordKey);
                      return _VocabularyTile(
                        item: item,
                        isRevealed: isRevealed,
                        isFlashcardMode: hideMeanings,
                        onTap: hideMeanings
                            ? () => onToggleWordReveal(wordKey)
                            : null,
                      );
                    },
                  ),
                  if (i < vocabulary.length - 1) 10.vSpace,
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _VocabularyTile extends StatelessWidget {
  const _VocabularyTile({
    required this.item,
    required this.isRevealed,
    required this.isFlashcardMode,
    this.onTap,
  });

  final VocabularyItem item;
  final bool isRevealed;
  final bool isFlashcardMode;
  final VoidCallback? onTap;

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
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isFlashcardMode && isRevealed
                  ? colorScheme.primary.withValues(alpha: 0.45)
                  : theme.dividerColor,
            ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (item.pronunciationBn?.isNotEmpty == true) ...<Widget>[
                      4.vSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'উচ্চারণ: ${item.pronunciationBn}',
                          style: getTextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                    8.vSpace,
                    if (isRevealed) ...<Widget>[
                      Text(
                        item.en,
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      2.vSpace,
                      Text(
                        item.bn,
                        style: getTextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ] else
                      Text(
                        'Tap card to reveal meaning',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              8.hSpace,
              PronunciationIconButton(text: item.de),
            ],
          ),
        ),
      ),
    );
  }
}
