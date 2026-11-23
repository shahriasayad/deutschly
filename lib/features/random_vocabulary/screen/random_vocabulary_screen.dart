import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:deutschly/core/app_colors.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/custom_button.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/pronunciation_button.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/features/random_vocabulary/controller/random_vocabulary_controller.dart';
import 'package:deutschly/features/random_vocabulary/models/vocabulary_review_card.dart';

class RandomVocabularyScreen extends StatelessWidget {
  const RandomVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppScreenUtil.init(context);
    final controller = Get.isRegistered<RandomVocabularyController>()
        ? Get.find<RandomVocabularyController>()
        : Get.put(RandomVocabularyController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Random Vocabulary',
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
          onPressed: () {
            GermanPronunciationPlayer.stop();
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: <Widget>[
          IconButton(
            key: const ValueKey<String>('random_vocab_reshuffle_btn'),
            tooltip: 'New Random Session',
            icon: const Icon(Icons.shuffle_rounded),
            onPressed: () => controller.startSession(includePracticeAhead: true),
          ),
        ],
      ),
      body: Obx(() {
        final totalWords = controller.totalUniqueWords;
        if (totalWords == 0) {
          return const EmptyStateWidget(
            icon: Icons.style_outlined,
            title: 'No Vocabulary Available',
            subtitle: 'Add lessons with vocabulary to start spaced review.',
          );
        }

        final currentItem = controller.currentCardItem;
        final currentCard = controller.currentReviewCard;
        final isFlipped = controller.isCardFlipped.value;
        final queueLength = controller.sessionQueue.length;
        final currentIndex = controller.currentQueueIndex.value;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _MasteryStatusStrip(
                    strugglingCount: controller.strugglingCount,
                    learningCount: controller.learningCount,
                    masteredCount: controller.masteredCount,
                    dueCount: controller.getDueCount(),
                  ),
                  14.vSpace,
                  if (currentItem == null || currentCard == null)
                    Expanded(
                      child: _SessionCompleteView(
                        reviewedCount: controller.sessionReviewedCount.value,
                        totalWords: totalWords,
                        masteredCount: controller.masteredCount,
                        onPracticeMore: () =>
                            controller.startSession(includePracticeAhead: true),
                      ),
                    )
                  else ...<Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Card ${currentIndex + 1} of $queueLength',
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Reviewed: ${controller.sessionReviewedCount.value}',
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
                        value: queueLength == 0
                            ? 0
                            : ((currentIndex + 1) / queueLength).clamp(0.0, 1.0),
                        minHeight: 6.h,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.statusColor(
                            context,
                            currentCard.learningStatus,
                          ),
                        ),
                      ),
                    ),
                    16.vSpace,
                    Expanded(
                      child: SingleChildScrollView(
                        child: _RandomFlashcard(
                          item: currentItem,
                          card: currentCard,
                          isFlipped: isFlipped,
                          onFlip: controller.flipCard,
                        ),
                      ),
                    ),
                    14.vSpace,
                    if (!isFlipped)
                      CustomButton(
                        key: const ValueKey<String>('random_vocab_reveal_btn'),
                        label: 'Show Answer',
                        icon: Icons.flip_rounded,
                        backgroundColor: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                        onPressed: controller.flipCard,
                      )
                    else
                      _RatingButtonsRow(
                        againLabel: controller.previewInterval(
                          ReviewRating.again,
                        ),
                        hardLabel: controller.previewInterval(
                          ReviewRating.hard,
                        ),
                        goodLabel: controller.previewInterval(
                          ReviewRating.good,
                        ),
                        easyLabel: controller.previewInterval(
                          ReviewRating.easy,
                        ),
                        onRate: controller.rateCurrentCard,
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MasteryStatusStrip extends StatelessWidget {
  const _MasteryStatusStrip({
    required this.strugglingCount,
    required this.learningCount,
    required this.masteredCount,
    required this.dueCount,
  });

  final int strugglingCount;
  final int learningCount;
  final int masteredCount;
  final int dueCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _StatusChip(
            label: 'Due: $dueCount',
            status: LearningStatus.good,
          ),
          8.hSpace,
          _StatusChip(
            label: 'Struggling: $strugglingCount',
            status: LearningStatus.struggling,
          ),
          8.hSpace,
          _StatusChip(
            label: 'Learning: $learningCount',
            status: LearningStatus.learning,
          ),
          8.hSpace,
          _StatusChip(
            label: 'Mastered: $masteredCount',
            status: LearningStatus.mastered,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.status});

  final String label;
  final LearningStatus status;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.statusColor(context, status);
    final bg = AppColors.statusContainerColor(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          6.hSpace,
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _RandomFlashcard extends StatelessWidget {
  const _RandomFlashcard({
    required this.item,
    required this.card,
    required this.isFlipped,
    required this.onFlip,
  });

  final RandomVocabularyCardItem item;
  final VocabularyReviewCard card;
  final bool isFlipped;
  final VoidCallback onFlip;

  String _statusLabel(LearningStatus status) => switch (status) {
    LearningStatus.unseen => 'New Word',
    LearningStatus.struggling => 'Needs Practice',
    LearningStatus.learning => 'Learning',
    LearningStatus.good => 'Familiar',
    LearningStatus.mastered => 'Mastered',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = card.learningStatus;
    final statusColor = AppColors.statusColor(context, status);
    final statusBg = AppColors.statusContainerColor(context, status);

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        key: const ValueKey<String>('random_vocab_flashcard'),
        onTap: isFlipped ? null : onFlip,
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 280.h),
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isFlipped
                  ? statusColor.withValues(alpha: 0.65)
                  : theme.dividerColor,
              width: isFlipped ? 1.6.w : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      _statusLabel(status),
                      style: getTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                  8.hSpace,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      'Lesson ${item.lessonNumber}',
                      style: getTextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PronunciationIconButton(
                    key: const ValueKey<String>('random_vocab_word_audio_btn'),
                    text: item.item.de,
                    tooltip: 'Listen to German word',
                  ),
                ],
              ),
              28.vSpace,
              Text(
                item.item.de,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              if (!isFlipped) ...<Widget>[
                36.vSpace,
                Text(
                  'Tap card to reveal meaning & example',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ] else ...<Widget>[
                16.vSpace,
                Text(
                  item.item.en,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
                if (item.item.pronunciationBn?.isNotEmpty == true) ...<Widget>[
                  10.vSpace,
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        'উচ্চারণ: ${item.item.pronunciationBn}',
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
                20.vSpace,
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.55,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Example Sentence',
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          PronunciationIconButton(
                            key: const ValueKey<String>(
                              'random_vocab_example_audio_btn',
                            ),
                            text: item.exampleDe,
                            tooltip: 'Listen to example sentence',
                            size: 32,
                          ),
                        ],
                      ),
                      6.vSpace,
                      Text(
                        item.exampleDe,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      4.vSpace,
                      Text(
                        item.exampleEn,
                        style: getTextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingButtonsRow extends StatelessWidget {
  const _RatingButtonsRow({
    required this.againLabel,
    required this.hardLabel,
    required this.goodLabel,
    required this.easyLabel,
    required this.onRate,
  });

  final String againLabel;
  final String hardLabel;
  final String goodLabel;
  final String easyLabel;
  final ValueChanged<ReviewRating> onRate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _RatingButton(
            key: const ValueKey<String>('srs_rate_again'),
            title: 'Again',
            interval: againLabel,
            status: LearningStatus.struggling,
            onTap: () => onRate(ReviewRating.again),
          ),
        ),
        8.hSpace,
        Expanded(
          child: _RatingButton(
            key: const ValueKey<String>('srs_rate_hard'),
            title: 'Hard',
            interval: hardLabel,
            status: LearningStatus.learning,
            onTap: () => onRate(ReviewRating.hard),
          ),
        ),
        8.hSpace,
        Expanded(
          child: _RatingButton(
            key: const ValueKey<String>('srs_rate_good'),
            title: 'Good',
            interval: goodLabel,
            status: LearningStatus.good,
            onTap: () => onRate(ReviewRating.good),
          ),
        ),
        8.hSpace,
        Expanded(
          child: _RatingButton(
            key: const ValueKey<String>('srs_rate_easy'),
            title: 'Easy',
            interval: easyLabel,
            status: LearningStatus.mastered,
            onTap: () => onRate(ReviewRating.easy),
          ),
        ),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    super.key,
    required this.title,
    required this.interval,
    required this.status,
    required this.onTap,
  });

  final String title;
  final String interval;
  final LearningStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.statusColor(context, status);
    final bg = AppColors.statusContainerColor(context, status);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: fg.withValues(alpha: 0.45)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              2.vSpace,
              Text(
                interval,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: fg.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCompleteView extends StatelessWidget {
  const _SessionCompleteView({
    required this.reviewedCount,
    required this.totalWords,
    required this.masteredCount,
    required this.onPracticeMore,
  });

  final int reviewedCount;
  final int totalWords;
  final int masteredCount;
  final VoidCallback onPracticeMore;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.verified_rounded,
      title: reviewedCount > 0 ? 'Session Complete!' : 'All Caught Up!',
      subtitle: reviewedCount > 0
          ? 'You reviewed $reviewedCount cards. $masteredCount of $totalWords words mastered so far.'
          : 'No words are currently due for review. You can still practice a random mix.',
      actionLabel: 'Practice Random Mix',
      onAction: onPracticeMore,
    );
  }
}
