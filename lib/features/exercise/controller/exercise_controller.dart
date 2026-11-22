import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/features/exercise/service/exercise_evaluator_service.dart';
import 'package:deutschly/features/progress/controller/progress_controller.dart';

class ExerciseController extends GetxController {
  ExerciseController({
    required this.exercises,
    this.lessonId,
    int initialIndex = 0,
    ExerciseEvaluatorService? evaluatorService,
    ProgressController? progressController,
  }) : _evaluator = evaluatorService ?? const ExerciseEvaluatorService(),
       _progressController = progressController,
       currentIndex =
           (initialIndex >= 0 && initialIndex < exercises.length
                   ? initialIndex
                   : 0)
               .obs;

  final List<Exercise> exercises;
  final String? lessonId;
  final ExerciseEvaluatorService _evaluator;
  final ProgressController? _progressController;

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

  // Writing prompt state
  final TextEditingController writingTextController = TextEditingController();
  final RxString writingText = ''.obs;
  final RxBool showWritingExample = false.obs;
  final RxnBool writingSelfEvaluation = RxnBool();

  // Ordering state (stores indices into exercise.items)
  final RxList<int> orderingIndices = <int>[].obs;

  late final List<int> _sessionQueue = List<int>.generate(
    exercises.length,
    (int index) => index,
  );
  final Set<int> _missedExerciseIndexes = <int>{};
  final RxBool isReviewRound = false.obs;

  ProgressController get _resolvedProgressController {
    if (_progressController != null) {
      return _progressController;
    }
    if (Get.isRegistered<ProgressController>()) {
      return Get.find<ProgressController>();
    }
    return Get.put(ProgressController());
  }

  Exercise? get currentExercise {
    if (currentIndex.value < 0 || currentIndex.value >= _sessionQueue.length) {
      return null;
    }
    return exercises[_sessionQueue[currentIndex.value]];
  }

  int get totalExercises => exercises.length;

  int get correctCount =>
      exerciseResults.values.where((bool correct) => correct).length;

  int get answeredCount => exerciseResults.length;

  bool get isLastExercise => currentIndex.value >= _sessionQueue.length - 1;

  int get missedExerciseCount => _missedExerciseIndexes.length;

  int get reviewExerciseNumber => currentIndex.value - exercises.length + 1;

  double get currentProgress => isReviewRound.value
      ? (reviewExerciseNumber / missedExerciseCount).clamp(0.0, 1.0)
      : (currentIndex.value + 1) / totalExercises;

  String get currentProgressLabel => isReviewRound.value
      ? 'Review $reviewExerciseNumber of $missedExerciseCount'
      : 'Exercise ${currentIndex.value + 1} of $totalExercises';

  String get nextButtonLabel {
    if (!isLastExercise) {
      return 'Next';
    }
    if (!isReviewRound.value && _missedExerciseIndexes.isNotEmpty) {
      return 'Review mistakes';
    }
    return 'Finish';
  }

  @override
  void onInit() {
    super.onInit();
    _prepareCurrentExercise();
  }

  @override
  void onClose() {
    fillBlankTextController.dispose();
    writingTextController.dispose();
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
    writingTextController.clear();
    writingText.value = '';
    showWritingExample.value = false;
    writingSelfEvaluation.value = null;
    orderingIndices.clear();

    final exercise = currentExercise;
    if (exercise == null) {
      return;
    }

    switch (exercise) {
      case MatchingExercise(:final pairs):
        final rights = pairs.map((MatchingPair p) => p.right).toList();
        if (rights.length > 1) {
          final rotated = <String>[...rights.sublist(1), rights.first];
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
      WritingPromptExercise() =>
        writingText.value.trim().isNotEmpty &&
            writingSelfEvaluation.value != null,
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

  void updateWritingText(String value) {
    if (isChecked.value) {
      return;
    }
    writingText.value = value;
  }

  void toggleWritingExample() {
    showWritingExample.value = !showWritingExample.value;
  }

  void selectWritingSelfEvaluation(bool includedKeyDetails) {
    if (isChecked.value) {
      return;
    }
    writingSelfEvaluation.value = includedKeyDetails;
    showWritingExample.value = true;
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
      WritingPromptExercise() => writingSelfEvaluation.value ?? false,
    };

    isCurrentCorrect.value = isCorrect;
    isChecked.value = true;
    exerciseResults[exercise.id] = isCorrect;

    if (!isCorrect && !isReviewRound.value) {
      _missedExerciseIndexes.add(_sessionQueue[currentIndex.value]);
    }

    if (exercise is SpeakingPromptExercise) {
      showSpeakingExample.value = true;
    }
    if (exercise is WritingPromptExercise) {
      showWritingExample.value = true;
    }

    final currentLessonId = lessonId;
    if (isCorrect && currentLessonId != null) {
      _resolvedProgressController.markExerciseCompleted(
        lessonId: currentLessonId,
        exerciseId: exercise.id,
      );
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
      if (!isReviewRound.value && _missedExerciseIndexes.isNotEmpty) {
        final missedIndexes = _missedExerciseIndexes.toList()..sort();
        _sessionQueue.addAll(missedIndexes);
        isReviewRound.value = true;
        currentIndex.value += 1;
        _prepareCurrentExercise();
        return;
      }
      isFinished.value = true;
      return;
    }
    currentIndex.value += 1;
    _prepareCurrentExercise();
  }

  void restartExercises() {
    exerciseResults.clear();
    _sessionQueue
      ..clear()
      ..addAll(List<int>.generate(exercises.length, (int index) => index));
    _missedExerciseIndexes.clear();
    isReviewRound.value = false;
    isFinished.value = false;
    currentIndex.value = 0;
    _prepareCurrentExercise();
  }
}
