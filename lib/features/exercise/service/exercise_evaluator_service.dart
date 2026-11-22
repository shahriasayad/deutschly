import 'package:flutter/foundation.dart';
import 'package:deutschly/data/models/exercise.dart';

class ExerciseEvaluatorService {
  const ExerciseEvaluatorService();

  static String _normalizeText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('...', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool evaluateMultipleChoice({
    required MultipleChoiceExercise exercise,
    required int? selectedIndex,
  }) {
    if (selectedIndex == null) {
      return false;
    }
    return selectedIndex == exercise.correctIndex;
  }

  bool evaluateFillBlank({
    required FillBlankExercise exercise,
    required String userInput,
  }) {
    final normalizedInput = _normalizeText(userInput);
    if (normalizedInput.isEmpty) {
      return false;
    }

    final candidates = <String>{
      _normalizeText(exercise.answer),
      ...exercise.acceptableAnswers.map(_normalizeText),
    };
    return candidates.contains(normalizedInput);
  }

  bool evaluateMatching({
    required MatchingExercise exercise,
    required Map<String, String> userMatches,
  }) {
    if (userMatches.length != exercise.pairs.length) {
      return false;
    }
    for (final MatchingPair pair in exercise.pairs) {
      if (userMatches[pair.left] != pair.right) {
        return false;
      }
    }
    return true;
  }

  bool evaluateTrueFalse({
    required TrueFalseExercise exercise,
    required bool? selectedValue,
  }) {
    if (selectedValue == null) {
      return false;
    }
    return selectedValue == exercise.correct;
  }

  bool evaluateSpeakingPrompt({
    required SpeakingPromptExercise exercise,
    required bool? selfEvaluatedCorrect,
  }) {
    return selfEvaluatedCorrect ?? false;
  }

  bool evaluateOrdering({
    required OrderingExercise exercise,
    required List<int> currentOrder,
  }) {
    return listEquals(currentOrder, exercise.correctOrder);
  }

  String getCorrectAnswerSummary(Exercise exercise) {
    return switch (exercise) {
      MultipleChoiceExercise(:final options, :final correctIndex) =>
        (correctIndex >= 0 && correctIndex < options.length)
            ? options[correctIndex]
            : '',
      FillBlankExercise(:final answer) => answer,
      MatchingExercise(:final pairs) =>
        pairs.map((MatchingPair p) => '${p.left} → ${p.right}').join(', '),
      TrueFalseExercise(:final correct) => correct ? 'True' : 'False',
      SpeakingPromptExercise(:final exampleAnswer) => exampleAnswer,
      OrderingExercise(:final items, :final correctOrder) =>
        correctOrder
            .where((int idx) => idx >= 0 && idx < items.length)
            .map((int idx) => items[idx])
            .join(' → '),
      WritingPromptExercise(:final exampleAnswer) => exampleAnswer,
    };
  }
}
