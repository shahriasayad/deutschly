import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';

class LessonVocabularyEntry {
  const LessonVocabularyEntry({
    required this.lessonId,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.item,
  });

  final String lessonId;
  final int lessonNumber;
  final String lessonTitle;
  final VocabularyItem item;
}

class VocabularyController extends GetxController {
  VocabularyController({CourseController? courseController})
    : _courseController = courseController ?? Get.find<CourseController>();

  final CourseController _courseController;

  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxnString selectedLessonId = RxnString();
  final RxBool hideTranslations = false.obs;
  final RxSet<String> revealedWordKeys = <String>{}.obs;
  final RxBool isDeckMode = false.obs;
  final RxInt deckIndex = 0.obs;
  final RxBool isDeckCardFlipped = false.obs;

  List<Lesson> get lessons =>
      _courseController.course.value?.lessons ?? const <Lesson>[];

  List<LessonVocabularyEntry> get allEntries {
    final entries = <LessonVocabularyEntry>[];
    for (final Lesson lesson in lessons) {
      for (final VocabularyItem item in lesson.vocabulary) {
        entries.add(
          LessonVocabularyEntry(
            lessonId: lesson.id,
            lessonNumber: lesson.number,
            lessonTitle: lesson.title,
            item: item,
          ),
        );
      }
    }
    return entries;
  }

  List<LessonVocabularyEntry> get filteredEntries {
    final filterLessonId = selectedLessonId.value;
    final query = searchQuery.value.trim().toLowerCase();

    return allEntries.where((LessonVocabularyEntry entry) {
      if (filterLessonId != null && entry.lessonId != filterLessonId) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return entry.item.de.toLowerCase().contains(query) ||
          entry.item.en.toLowerCase().contains(query) ||
          entry.item.bn.toLowerCase().contains(query);
    }).toList();
  }

  void _resetDeckPosition() {
    deckIndex.value = 0;
    isDeckCardFlipped.value = false;
  }

  void selectLessonFilter(String? lessonId) {
    selectedLessonId.value = lessonId;
    _resetDeckPosition();
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
    _resetDeckPosition();
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    _resetDeckPosition();
  }

  void clearFilters() {
    selectedLessonId.value = null;
    searchTextController.clear();
    searchQuery.value = '';
    _resetDeckPosition();
  }

  void toggleHideTranslations() {
    hideTranslations.value = !hideTranslations.value;
    revealedWordKeys.clear();
  }

  void setDeckMode(bool enabled) {
    isDeckMode.value = enabled;
    _resetDeckPosition();
  }

  void flipDeckCard() {
    isDeckCardFlipped.value = !isDeckCardFlipped.value;
  }

  void nextDeckCard(int totalCount) {
    if (totalCount <= 0) {
      return;
    }
    deckIndex.value = (deckIndex.value + 1) % totalCount;
    isDeckCardFlipped.value = false;
  }

  void previousDeckCard(int totalCount) {
    if (totalCount <= 0) {
      return;
    }
    deckIndex.value = (deckIndex.value - 1 + totalCount) % totalCount;
    isDeckCardFlipped.value = false;
  }

  void toggleWordReveal(String wordKey) {
    if (revealedWordKeys.contains(wordKey)) {
      revealedWordKeys.remove(wordKey);
    } else {
      revealedWordKeys.add(wordKey);
    }
  }

  bool isWordRevealed(String wordKey) {
    return !hideTranslations.value || revealedWordKeys.contains(wordKey);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
