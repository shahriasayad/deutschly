import 'package:flutter/material.dart';
import 'package:deutschly/core/custom_text_field.dart';
import 'package:deutschly/core/global_text_style.dart';
import 'package:deutschly/core/screen_util.dart';
import 'package:deutschly/data/models/lesson.dart';

class VocabularyFilterBar extends StatelessWidget {
  const VocabularyFilterBar({
    super.key,
    required this.searchController,
    required this.lessons,
    required this.selectedLessonId,
    required this.hideTranslations,
    required this.totalCount,
    required this.onSearchChanged,
    required this.onSelectLesson,
    required this.onToggleHideTranslations,
  });

  final TextEditingController searchController;
  final List<Lesson> lessons;
  final String? selectedLessonId;
  final bool hideTranslations;
  final int totalCount;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSelectLesson;
  final VoidCallback onToggleHideTranslations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextField(
          controller: searchController,
          hintText: 'Search German, English, or Bengali...',
          prefixIcon: const Icon(Icons.search_rounded),
          onChanged: onSearchChanged,
        ),
        12.vSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _FilterChipItem(
                key: const ValueKey<String>('vocab_filter_all'),
                label: 'All Lessons',
                isSelected: selectedLessonId == null,
                onTap: () => onSelectLesson(null),
              ),
              for (final Lesson lesson in lessons) ...<Widget>[
                8.hSpace,
                _FilterChipItem(
                  key: ValueKey<String>('vocab_filter_${lesson.id}'),
                  label: 'Lesson ${lesson.number}',
                  isSelected: selectedLessonId == lesson.id,
                  onTap: () => onSelectLesson(lesson.id),
                ),
              ],
            ],
          ),
        ),
        12.vSpace,
        Row(
          children: <Widget>[
            Text(
              '$totalCount words',
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            InkWell(
              key: const ValueKey<String>('vocab_quiz_mode_toggle'),
              onTap: onToggleHideTranslations,
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: hideTranslations
                      ? colorScheme.primaryContainer
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: hideTranslations
                        ? colorScheme.primary
                        : theme.dividerColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      hideTranslations
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 16.r,
                      color: colorScheme.primary,
                    ),
                    6.hSpace,
                    Text(
                      hideTranslations
                          ? 'Flashcard Mode: ON'
                          : 'Flashcard Mode: OFF',
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
      ],
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? colorScheme.primary : theme.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
