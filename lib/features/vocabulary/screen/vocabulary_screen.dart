import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';
import 'package:deutschly/features/vocabulary/widgets/vocabulary_filter_bar.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final controller = Get.isRegistered<VocabularyController>()
        ? Get.find<VocabularyController>()
        : Get.put(VocabularyController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Vocabulary Review',
        centerTitle: false,
      ),
      body: Obx(() {
        final entries = controller.filteredEntries;
        final hideTranslations = controller.hideTranslations.value;
        final isDeckMode = controller.isDeckMode.value;
        final revealedSet = controller.revealedWordKeys.toSet();

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  VocabularyFilterBar(
                    searchController: controller.searchTextController,
                    lessons: controller.lessons,
                    selectedLessonId: controller.selectedLessonId.value,
                    hideTranslations: hideTranslations,
                    isDeckMode: isDeckMode,
                    hasSearchQuery: controller.searchQuery.value.isNotEmpty,
                    totalCount: entries.length,
                    onSearchChanged: controller.updateSearchQuery,
                    onClearSearch: controller.clearSearch,
                    onSelectLesson: controller.selectLessonFilter,
                    onToggleHideTranslations: controller.toggleHideTranslations,
                    onToggleDeckMode: controller.setDeckMode,
                  ),
                  12.vSpace,
                  Expanded(
                    child: entries.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.search_off_rounded,
                            title: 'No Vocabulary Matches',
                            subtitle:
                                'No German, English, or Bengali words matched your current filter.',
                            actionLabel: 'Reset Filters',
                            onAction: controller.clearFilters,
                          )
                        : isDeckMode
                        ? _FlashcardDeckView(
                            entries: entries,
                            currentIndex: controller.deckIndex.value
                                .clamp(0, entries.length - 1)
                                .toInt(),
                            isFlipped: controller.isDeckCardFlipped.value,
                            onFlip: controller.flipDeckCard,
                            onPrevious: () =>
                                controller.previousDeckCard(entries.length),
                            onNext: () =>
                                controller.nextDeckCard(entries.length),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.only(bottom: 24.h),
                            itemCount: entries.length,
                            separatorBuilder: (_, _) => 10.vSpace,
                            itemBuilder: (BuildContext context, int index) {
                              final entry = entries[index];
                              final wordKey =
                                  '${entry.lessonId}_${entry.item.de}';
                              final isRevealed =
                                  !hideTranslations ||
                                  revealedSet.contains(wordKey);

                              return Material(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(16.r),
                                child: InkWell(
                                  key: ValueKey<String>('vocab_card_$wordKey'),
                                  onTap: hideTranslations
                                      ? () =>
                                            controller.toggleWordReveal(wordKey)
                                      : null,
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: hideTranslations && isRevealed
                                            ? colorScheme.primary.withValues(
                                                alpha: 0.45,
                                              )
                                            : theme.dividerColor,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Text(
                                            'L${entry.lessonNumber}',
                                            style: getTextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                        12.hSpace,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                entry.item.de,
                                                style: getTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: colorScheme.onSurface,
                                                ),
                                              ),
                                              if (entry
                                                      .item
                                                      .pronunciationBn
                                                      ?.isNotEmpty ==
                                                  true) ...<Widget>[
                                                4.vSpace,
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 2.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: colorScheme
                                                        .surfaceContainerHighest,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6.r,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'উচ্চারণ: ${entry.item.pronunciationBn}',
                                                    style: getTextStyle(
                                                      fontSize: 11,
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              6.vSpace,
                                              if (isRevealed) ...<Widget>[
                                                Text(
                                                  entry.item.en,
                                                  style: getTextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: colorScheme.primary,
                                                  ),
                                                ),
                                                2.vSpace,
                                                Text(
                                                  entry.item.bn,
                                                  style: getTextStyle(
                                                    fontSize: 13,
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                              ] else
                                                Text(
                                                  'Tap to reveal meaning',
                                                  style: getTextStyle(
                                                    fontSize: 13,
                                                    color: colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        8.hSpace,
                                        PronunciationIconButton(
                                          text: entry.item.de,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _FlashcardDeckView extends StatelessWidget {
  const _FlashcardDeckView({
    required this.entries,
    required this.currentIndex,
    required this.isFlipped,
    required this.onFlip,
    required this.onPrevious,
    required this.onNext,
  });

  final List<LessonVocabularyEntry> entries;
  final int currentIndex;
  final bool isFlipped;
  final VoidCallback onFlip;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entry = entries[currentIndex];

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Card ${currentIndex + 1} of ${entries.length}',
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text(
                'Lesson ${entry.lessonNumber}',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          8.vSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / entries.length,
              minHeight: 6.h,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          20.vSpace,
          Material(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24.r),
            child: InkWell(
              key: const ValueKey<String>('vocab_deck_card'),
              onTap: onFlip,
              borderRadius: BorderRadius.circular(24.r),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 240.h),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isFlipped ? colorScheme.primary : theme.dividerColor,
                    width: isFlipped ? 1.6.w : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            isFlipped ? 'Meaning' : 'German',
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        PronunciationIconButton(text: entry.item.de),
                      ],
                    ),
                    24.vSpace,
                    Text(
                      entry.item.de,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (entry.item.pronunciationBn?.isNotEmpty == true) ...<Widget>[
                      8.vSpace,
                      Text(
                        'উচ্চারণ: ${entry.item.pronunciationBn}',
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    20.vSpace,
                    if (isFlipped) ...<Widget>[
                      Divider(color: theme.dividerColor),
                      16.vSpace,
                      Text(
                        entry.item.en,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      6.vSpace,
                      Text(
                        entry.item.bn,
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ] else
                      Text(
                        'Tap card to flip and see translation',
                        style: getTextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          20.vSpace,
          Row(
            children: <Widget>[
              Expanded(
                child: CustomButton(
                  label: 'Previous',
                  icon: Icons.arrow_back_rounded,
                  isOutlined: true,
                  onPressed: entries.length > 1 ? onPrevious : null,
                ),
              ),
              12.hSpace,
              Expanded(
                child: CustomButton(
                  label: isFlipped ? 'Next Card' : 'Reveal',
                  icon: isFlipped
                      ? Icons.arrow_forward_rounded
                      : Icons.flip_rounded,
                  backgroundColor: colorScheme.primary,
                  textColor: colorScheme.onPrimary,
                  onPressed: isFlipped ? onNext : onFlip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
