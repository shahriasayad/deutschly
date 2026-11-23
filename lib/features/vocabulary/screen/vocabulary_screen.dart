import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
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
      appBar: const CustomAppBar(title: 'Vocabulary Review'),
      body: Obx(() {
        final entries = controller.filteredEntries;
        final hideTranslations = controller.hideTranslations.value;
        final revealedSet = controller.revealedWordKeys.toSet();

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  VocabularyFilterBar(
                    searchController: controller.searchTextController,
                    lessons: controller.lessons,
                    selectedLessonId: controller.selectedLessonId.value,
                    hideTranslations: hideTranslations,
                    totalCount: entries.length,
                    onSearchChanged: controller.updateSearchQuery,
                    onSelectLesson: controller.selectLessonFilter,
                    onToggleHideTranslations: controller.toggleHideTranslations,
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

                              return InkWell(
                                key: ValueKey<String>('vocab_card_$wordKey'),
                                onTap: hideTranslations
                                    ? () => controller.toggleWordReveal(wordKey)
                                    : null,
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: theme.dividerColor,
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
                                            color:
                                                colorScheme.onPrimaryContainer,
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
                                              3.vSpace,
                                              Text(
                                                'উচ্চারণ (আনুমানিক): ${entry.item.pronunciationBn}',
                                                style: getTextStyle(
                                                  fontSize: 12,
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                            4.vSpace,
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
                                    ],
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
