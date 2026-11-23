import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/lesson.dart';
import 'package:deutschly/features/course/controller/course_controller.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';

class LessonDetailController extends GetxController {
  LessonDetailController({
    required this.lessonId,
    CourseController? courseController,
    ProgressController? progressController,
  }) : _courseController = courseController ?? Get.find<CourseController>(),
       _progressController = progressController;

  final String lessonId;
  final CourseController _courseController;
  final ProgressController? _progressController;

  final RxInt selectedTabIndex = 0.obs;
  final RxBool isVocabularyExpanded = true.obs;
  final RxBool hideVocabularyMeanings = false.obs;
  final RxBool showHardVocabularyOnly = false.obs;
  final RxSet<String> revealedWordKeys = <String>{}.obs;
  final RxBool hideDialogueTranslations = false.obs;
  final RxSet<String> revealedDialogueKeys = <String>{}.obs;
  final RxString exerciseFilter = 'all'.obs;

  ProgressController get _resolvedProgressController {
    if (_progressController != null) {
      return _progressController;
    }
    if (Get.isRegistered<ProgressController>()) {
      return Get.find<ProgressController>();
    }
    return Get.put(ProgressController(courseController: _courseController));
  }

  Lesson? get lesson {
    final lessons = _courseController.course.value?.lessons ?? const <Lesson>[];
    return lessons.firstWhereOrNull((Lesson item) => item.id == lessonId);
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void toggleVocabularyExpanded() {
    isVocabularyExpanded.value = !isVocabularyExpanded.value;
  }

  void toggleHideVocabularyMeanings() {
    hideVocabularyMeanings.value = !hideVocabularyMeanings.value;
    revealedWordKeys.clear();
  }

  void setShowHardVocabularyOnly(bool value) {
    showHardVocabularyOnly.value = value;
  }

  Set<String> get hardWords => _resolvedProgressController.getHardWords(lessonId);

  bool isWordHard(String wordDe) =>
      _resolvedProgressController.isWordHard(lessonId, wordDe);

  Future<void> toggleWordHard(String wordDe) => _resolvedProgressController
      .toggleWordHard(lessonId: lessonId, wordDe: wordDe);

  void toggleWordReveal(String wordKey) {
    if (revealedWordKeys.contains(wordKey)) {
      revealedWordKeys.remove(wordKey);
    } else {
      revealedWordKeys.add(wordKey);
    }
  }

  bool isWordRevealed(String wordKey) =>
      !hideVocabularyMeanings.value || revealedWordKeys.contains(wordKey);

  void toggleHideDialogueTranslations() {
    hideDialogueTranslations.value = !hideDialogueTranslations.value;
    revealedDialogueKeys.clear();
  }

  void toggleDialogueLineReveal(String lineKey) {
    if (revealedDialogueKeys.contains(lineKey)) {
      revealedDialogueKeys.remove(lineKey);
    } else {
      revealedDialogueKeys.add(lineKey);
    }
  }

  bool isDialogueLineRevealed(String lineKey) =>
      !hideDialogueTranslations.value || revealedDialogueKeys.contains(lineKey);

  void setExerciseFilter(String filter) {
    exerciseFilter.value = filter;
  }

  Set<String> get completedExerciseIds =>
      _resolvedProgressController.getCompletedExerciseIds(lessonId);

  bool isExerciseCompleted(String exerciseId) {
    return _resolvedProgressController.isExerciseCompleted(
      lessonId,
      exerciseId,
    );
  }

  int get completedCount {
    final currentLesson = lesson;
    if (currentLesson == null) {
      return 0;
    }
    final completedSet = completedExerciseIds;
    return currentLesson.exercises
        .where((Exercise ex) => completedSet.contains(ex.id))
        .length;
  }

  int get nextUncompletedExerciseIndex {
    final currentLesson = lesson;
    if (currentLesson == null) {
      return 0;
    }
    final completedSet = completedExerciseIds;
    final index = currentLesson.exercises.indexWhere(
      (Exercise ex) => !completedSet.contains(ex.id),
    );
    return index >= 0 ? index : 0;
  }

  bool canDoObjective(String objective) =>
      _resolvedProgressController.canDoObjective(lessonId, objective);

  int get canDoCount {
    final currentLesson = lesson;
    if (currentLesson == null) {
      return 0;
    }
    return _resolvedProgressController.getCanDoObjectiveCount(currentLesson);
  }

  Future<void> toggleCanDoObjective(String objective, bool canDo) =>
      _resolvedProgressController.setCanDoObjective(
        lessonId: lessonId,
        objective: objective,
        canDo: canDo,
      );

  static String formatExerciseType(String type) {
    return switch (type) {
      'multiple_choice' => 'Multiple Choice',
      'fill_blank' => 'Fill in the Blank',
      'matching' => 'Matching',
      'true_false' => 'True / False',
      'speaking_prompt' => 'Speaking Prompt',
      'writing_prompt' => 'Writing Practice',
      'ordering' => 'Ordering',
      _ => type,
    };
  }
}
