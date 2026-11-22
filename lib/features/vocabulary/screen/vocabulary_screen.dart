import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/core/custom_appbar.dart';
import 'package:deutschly/core/empty_state_widget.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/features/vocabulary/controller/vocabulary_controller.dart';
import 'package:deutschly/features/vocabulary/widgets/vocabulary_filter_bar.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                    onToggleHideTranslations:
                        controller.toggleHideTranslations,
                  ),
                  const SizedBox(height: 12),
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
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: entries.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 10),
                            itemBuilder: (BuildContext context, int index) {
                              final entry = entries[index];
                              final wordKey =
                                  '${entry.lessonId}_${entry.item.de}';
                              final isRevealed = !hideTranslations ||
                                  revealedSet.contains(wordKey);

                              return InkWell(
                                key: ValueKey<String>('vocab_card_$wordKey'),
                                onTap: hideTranslations
                                    ? () => controller.toggleWordReveal(wordKey)
                                    : null,
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border:
                                        Border.all(color: theme.dividerColor),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      const SizedBox(width: 12),
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
                                            const SizedBox(height: 4),
                                            if (isRevealed) ...<Widget>[
                                              Text(
                                                entry.item.en,
                                                style: getTextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
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
