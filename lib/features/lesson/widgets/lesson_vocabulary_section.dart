import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';
import 'package:deutschly/features/random_vocabulary/controller/random_vocabulary_controller.dart';
import 'package:deutschly/features/random_vocabulary/widgets/vocabulary_status_badge.dart';
import 'package:deutschly/features/vocabulary/widgets/hard_vocabulary_toggle_button.dart';

class LessonVocabularySection extends StatelessWidget {
  const LessonVocabularySection({
    super.key,
    required this.lessonId,
    required this.vocabulary,
    required this.hideMeanings,
    required this.revealedWordKeys,
    required this.hardWords,
    required this.showHardOnly,
    required this.onToggleHideMeanings,
    required this.onToggleWordReveal,
    required this.onSelectShowHardOnly,
    required this.onToggleWordHard,
  });

  final String lessonId;
  final List<VocabularyItem> vocabulary;
  final bool hideMeanings;
  final Set<String> revealedWordKeys;
  final Set<String> hardWords;
  final bool showHardOnly;
  final VoidCallback onToggleHideMeanings;
  final ValueChanged<String> onToggleWordReveal;
  final ValueChanged<bool> onSelectShowHardOnly;
  final ValueChanged<String> onToggleWordHard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (vocabulary.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.translate_rounded,
        title: 'No Vocabulary Yet',
        subtitle: 'This lesson does not contain vocabulary items.',
      );
    }

    final hardVocabulary = vocabulary
        .where((VocabularyItem item) => hardWords.contains(item.de))
        .toList(growable: false);
    final displayedVocabulary = showHardOnly ? hardVocabulary : vocabulary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                showHardOnly
                    ? '${displayedVocabulary.length} Hard Vocabulary'
                    : '${vocabulary.length} Vocabulary Words',
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
        10.vSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _VocabularyFilterPill(
                key: const ValueKey<String>('lesson_vocab_all_tab'),
                label: 'All Words (${vocabulary.length})',
                isSelected: !showHardOnly,
                onTap: () => onSelectShowHardOnly(false),
              ),
              8.hSpace,
              _VocabularyFilterPill(
                key: const ValueKey<String>('lesson_vocab_hard_tab'),
                label: 'Hard Vocabulary (${hardVocabulary.length})',
                icon: Icons.bookmark_rounded,
                isSelected: showHardOnly,
                onTap: () => onSelectShowHardOnly(true),
              ),
            ],
          ),
        ),
        12.vSpace,
        if (displayedVocabulary.isEmpty)
          EmptyStateWidget(
            icon: Icons.bookmark_border_rounded,
            title: 'No Hard Vocabulary Yet',
            subtitle:
                'Tap the bookmark icon on any word to add it to this lesson\'s Hard Vocabulary list.',
            actionLabel: 'Show All Words',
            onAction: () => onSelectShowHardOnly(false),
          )
        else
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final isWide = constraints.maxWidth >= 600;
              if (isWide) {
                final itemWidth = (constraints.maxWidth - 12.w) / 2;
                return Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: displayedVocabulary.map((VocabularyItem item) {
                    final wordKey = '${lessonId}_${item.de}';
                    final isRevealed =
                        !hideMeanings || revealedWordKeys.contains(wordKey);
                    return SizedBox(
                      width: itemWidth,
                      child: _VocabularyTile(
                        item: item,
                        isRevealed: isRevealed,
                        isFlashcardMode: hideMeanings,
                        isHard: hardWords.contains(item.de),
                        hardButtonKey: ValueKey<String>(
                          'lesson_word_hard_${lessonId}_${item.de}',
                        ),
                        onToggleHard: () => onToggleWordHard(item.de),
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
                  for (int i = 0; i < displayedVocabulary.length; i++) ...<Widget>[
                    Builder(
                      builder: (BuildContext context) {
                        final item = displayedVocabulary[i];
                        final wordKey = '${lessonId}_${item.de}';
                        final isRevealed =
                            !hideMeanings || revealedWordKeys.contains(wordKey);
                        return _VocabularyTile(
                          item: item,
                          isRevealed: isRevealed,
                          isFlashcardMode: hideMeanings,
                          isHard: hardWords.contains(item.de),
                          hardButtonKey: ValueKey<String>(
                            'lesson_word_hard_${lessonId}_${item.de}',
                          ),
                          onToggleHard: () => onToggleWordHard(item.de),
                          onTap: hideMeanings
                              ? () => onToggleWordReveal(wordKey)
                              : null,
                        );
                      },
                    ),
                    if (i < displayedVocabulary.length - 1) 10.vSpace,
                  ],
                ],
              );
            },
          ),
      ],
    );
  }
}

class _VocabularyFilterPill extends StatelessWidget {
  const _VocabularyFilterPill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? colorScheme.primary : theme.dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                size: 14.r,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.secondary,
              ),
              5.hSpace,
            ],
            Text(
              label,
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VocabularyTile extends StatelessWidget {
  const _VocabularyTile({
    required this.item,
    required this.isRevealed,
    required this.isFlashcardMode,
    required this.isHard,
    required this.onToggleHard,
    this.hardButtonKey,
    this.onTap,
  });

  final VocabularyItem item;
  final bool isRevealed;
  final bool isFlashcardMode;
  final bool isHard;
  final VoidCallback onToggleHard;
  final Key? hardButtonKey;
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item.de,
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (Get.isRegistered<
                            RandomVocabularyController>()) ...<Widget>[
                          6.hSpace,
                          VocabularyStatusBadge(
                            status: Get.find<RandomVocabularyController>()
                                .getStatusForWord(item.de),
                          ),
                        ],
                      ],
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HardVocabularyToggleButton(
                    key: hardButtonKey,
                    isHard: isHard,
                    onPressed: onToggleHard,
                  ),
                  PronunciationIconButton(text: item.de),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
