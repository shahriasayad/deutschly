import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/features/exercise/service/exercise_evaluator_service.dart';
import 'package:deutschly/features/home/controller/home_controller.dart';
import 'package:deutschly/features/lesson/controller/lesson_detail_controller.dart';

class ExerciseController extends GetxController {
  ExerciseController({
    required this.exercises,
    this.lessonId,
    int initialIndex = 0,
    ExerciseEvaluatorService? evaluatorService,
  })  : _evaluator = evaluatorService ?? const ExerciseEvaluatorService(),
        currentIndex = (initialIndex >= 0 && initialIndex < exercises.length
                ? initialIndex
                : 0)
            .obs;

  final List<Exercise> exercises;
  final String? lessonId;
  final ExerciseEvaluatorService _evaluator;

  final RxInt currentIndex;
  final RxBool isChecked = false.obs;
  final RxBool isCurrentCorrect = false.obs;
  final RxBool isFinished = false.obs;

  final RxMap<String, bool> exerciseResults = <String, bool>{}.obs;

  // Multiple choice state
  final RxnInt selectedOptionIndex = RxnInt();

  // Fill blank state
  final TextEditingController fillBlankTextController = TextEditingController();
  final RxString fillBlankText = ''.obs;

  // Matching state
  final RxnString selectedLeftItem = RxnString();
  final RxMap<String, String> matchedPairs = <String, String>{}.obs;
  final RxList<String> rightColumnOptions = <String>[].obs;

  // True/False state
  final RxnBool selectedTrueFalse = RxnBool();

  // Speaking prompt state
  final RxBool showSpeakingExample = false.obs;
  final RxnBool speakingSelfEvaluation = RxnBool();

  // Ordering state (stores indices into exercise.items)
  final RxList<int> orderingIndices = <int>[].obs;

  Exercise? get currentExercise {
    if (exercises.isEmpty ||
        currentIndex.value < 0 ||
        currentIndex.value >= exercises.length) {
      return null;
    }
    return exercises[currentIndex.value];
  }

  int get totalExercises => exercises.length;

  int get correctCount =>
      exerciseResults.values.where((bool correct) => correct).length;

  int get answeredCount => exerciseResults.length;

  bool get isLastExercise => currentIndex.value >= exercises.length - 1;

  @override
  void onInit() {
    super.onInit();
    _prepareCurrentExercise();
  }

  @override
  void onClose() {
    fillBlankTextController.dispose();
    super.onClose();
  }

  void _prepareCurrentExercise() {
    isChecked.value = false;
    isCurrentCorrect.value = false;
    selectedOptionIndex.value = null;
    fillBlankTextController.clear();
    fillBlankText.value = '';
    selectedLeftItem.value = null;
    matchedPairs.clear();
    rightColumnOptions.clear();
    selectedTrueFalse.value = null;
    showSpeakingExample.value = false;
    speakingSelfEvaluation.value = null;
    orderingIndices.clear();

    final exercise = currentExercise;
    if (exercise == null) {
      return;
    }

    switch (exercise) {
      case MatchingExercise(:final pairs):
        final rights = pairs.map((MatchingPair p) => p.right).toList();
        if (rights.length > 1) {
          // Deterministic rotation so options are not already aligned 1:1
          final rotated = <String>[
            ...rights.sublist(1),
            rights.first,
          ];
          rightColumnOptions.assignAll(rotated);
        } else {
          rightColumnOptions.assignAll(rights);
        }
      case OrderingExercise(:final items):
        orderingIndices.assignAll(
          List<int>.generate(items.length, (int index) => index),
        );
      default:
        break;
    }
  }

  bool get canCheck {
    if (isChecked.value) {
      return false;
    }
    final exercise = currentExercise;
    if (exercise == null) {
      return false;
    }
    return switch (exercise) {
      MultipleChoiceExercise() => selectedOptionIndex.value != null,
      FillBlankExercise() => fillBlankText.value.trim().isNotEmpty,
      MatchingExercise(:final pairs) => matchedPairs.length == pairs.length,
      TrueFalseExercise() => selectedTrueFalse.value != null,
      SpeakingPromptExercise() => speakingSelfEvaluation.value != null,
      OrderingExercise(:final items) => orderingIndices.length == items.length,
    };
  }

  void selectMultipleChoiceOption(int index) {
    if (isChecked.value) {
      return;
    }
    selectedOptionIndex.value = index;
  }

  void updateFillBlankText(String value) {
    if (isChecked.value) {
      return;
    }
    fillBlankText.value = value;
  }

  void insertCharacterInFillBlank(String character) {
    if (isChecked.value) {
      return;
    }
    final text = fillBlankTextController.text;
    final selection = fillBlankTextController.selection;
    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;
    final newText = text.replaceRange(start, end, character);
    fillBlankTextController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + character.length),
    );
    fillBlankText.value = newText;
  }

  void selectLeftMatchingItem(String left) {
    if (isChecked.value) {
      return;
    }
    if (selectedLeftItem.value == left) {
      selectedLeftItem.value = null;
    } else {
      selectedLeftItem.value = left;
    }
  }

  String? _findLeftForRight(String right) {
    for (final MapEntry<String, String> entry in matchedPairs.entries) {
      if (entry.value == right) {
        return entry.key;
      }
    }
    return null;
  }

  void selectRightMatchingItem(String right) {
    if (isChecked.value) {
      return;
    }
    final currentLeft = selectedLeftItem.value;
    if (currentLeft == null) {
      final existingKey = _findLeftForRight(right);
      if (existingKey != null) {
        matchedPairs.remove(existingKey);
      }
      return;
    }

    final previousLeftForRight = _findLeftForRight(right);
    if (previousLeftForRight != null) {
      matchedPairs.remove(previousLeftForRight);
    }

    matchedPairs[currentLeft] = right;
    selectedLeftItem.value = null;
  }

  void selectTrueFalse(bool value) {
    if (isChecked.value) {
      return;
    }
    selectedTrueFalse.value = value;
  }

  void toggleSpeakingExample() {
    showSpeakingExample.value = !showSpeakingExample.value;
  }

  void selectSpeakingSelfEvaluation(bool isCorrect) {
    if (isChecked.value) {
      return;
    }
    speakingSelfEvaluation.value = isCorrect;
    showSpeakingExample.value = true;
  }

  void reorderItems(int oldIndex, int newIndex) {
    if (isChecked.value) {
      return;
    }
    if (oldIndex < 0 ||
        oldIndex >= orderingIndices.length ||
        newIndex < 0 ||
        newIndex >= orderingIndices.length) {
      return;
    }
    final item = orderingIndices.removeAt(oldIndex);
    orderingIndices.insert(newIndex, item);
  }

  void moveOrderingItem(int index, int delta) {
    if (isChecked.value) {
      return;
    }
    final targetIndex = index + delta;
    if (index < 0 ||
        index >= orderingIndices.length ||
        targetIndex < 0 ||
        targetIndex >= orderingIndices.length) {
      return;
    }
    final item = orderingIndices.removeAt(index);
    orderingIndices.insert(targetIndex, item);
  }

  void checkAnswer() {
    final exercise = currentExercise;
    if (exercise == null || isChecked.value || !canCheck) {
      return;
    }

    final isCorrect = switch (exercise) {
      MultipleChoiceExercise() => _evaluator.evaluateMultipleChoice(
          exercise: exercise,
          selectedIndex: selectedOptionIndex.value,
        ),
      FillBlankExercise() => _evaluator.evaluateFillBlank(
          exercise: exercise,
          userInput: fillBlankText.value,
        ),
      MatchingExercise() => _evaluator.evaluateMatching(
          exercise: exercise,
          userMatches: matchedPairs,
        ),
      TrueFalseExercise() => _evaluator.evaluateTrueFalse(
          exercise: exercise,
          selectedValue: selectedTrueFalse.value,
        ),
      SpeakingPromptExercise() => _evaluator.evaluateSpeakingPrompt(
          exercise: exercise,
          selfEvaluatedCorrect: speakingSelfEvaluation.value,
        ),
      OrderingExercise() => _evaluator.evaluateOrdering(
          exercise: exercise,
          currentOrder: orderingIndices.toList(),
        ),
    };

    isCurrentCorrect.value = isCorrect;
    isChecked.value = true;
    exerciseResults[exercise.id] = isCorrect;

    if (exercise is SpeakingPromptExercise) {
      showSpeakingExample.value = true;
    }

    _syncLessonProgress(exercise.id, isCorrect);
  }

  void _syncLessonProgress(String exerciseId, bool isCorrect) {
    final currentLessonId = lessonId;
    if (currentLessonId == null) {
      return;
    }

    if (Get.isRegistered<LessonDetailController>(tag: currentLessonId)) {
      final lessonController =
          Get.find<LessonDetailController>(tag: currentLessonId);
      if (isCorrect) {
        lessonController.completedExerciseIds.add(exerciseId);
      }
      final lesson = lessonController.lesson;
      if (lesson != null &&
          lesson.exercises.isNotEmpty &&
          Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        homeController.lessonProgressMap[currentLessonId] =
            lessonController.completedCount / lesson.exercises.length;
      }
    } else if (isCorrect && Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      final completedInSession =
          exerciseResults.values.where((bool v) => v).length;
      if (exercises.isNotEmpty) {
        final previous =
            homeController.lessonProgressMap[currentLessonId] ?? 0.0;
        final updated = completedInSession / exercises.length;
        if (updated > previous) {
          homeController.lessonProgressMap[currentLessonId] = updated;
        }
      }
    }
  }

  String get currentCorrectAnswerSummary {
    final exercise = currentExercise;
    if (exercise == null) {
      return '';
    }
    return _evaluator.getCorrectAnswerSummary(exercise);
  }

  void nextExercise() {
    if (!isChecked.value) {
      return;
    }
    if (isLastExercise) {
      isFinished.value = true;
      return;
    }
    currentIndex.value += 1;
    _prepareCurrentExercise();
  }

  void restartExercises() {
    exerciseResults.clear();
    isFinished.value = false;
    currentIndex.value = 0;
    _prepareCurrentExercise();
  }
}
