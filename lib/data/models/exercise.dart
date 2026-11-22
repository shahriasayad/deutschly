import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

@freezed
abstract class MatchingPair with _$MatchingPair {
  const factory MatchingPair({
    required String left,
    required String right,
  }) = _MatchingPair;

  factory MatchingPair.fromJson(Map<String, dynamic> json) =>
      _$MatchingPairFromJson(json);
}

@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
sealed class Exercise with _$Exercise {
  const Exercise._();

  @FreezedUnionValue('multiple_choice')
  const factory Exercise.multipleChoice({
    required String id,
    required String question,
    required List<String> options,
    required int correctIndex,
    String? explanation,
  }) = MultipleChoiceExercise;

  @FreezedUnionValue('fill_blank')
  const factory Exercise.fillBlank({
    required String id,
    required String question,
    required String answer,
    @Default(<String>[]) List<String> acceptableAnswers,
    String? explanation,
  }) = FillBlankExercise;

  @FreezedUnionValue('matching')
  const factory Exercise.matching({
    required String id,
    required String question,
    required List<MatchingPair> pairs,
    String? explanation,
  }) = MatchingExercise;

  @FreezedUnionValue('true_false')
  const factory Exercise.trueFalse({
    required String id,
    required String question,
    required bool correct,
    String? explanation,
  }) = TrueFalseExercise;

  @FreezedUnionValue('speaking_prompt')
  const factory Exercise.speakingPrompt({
    required String id,
    required String question,
    required String exampleAnswer,
    String? explanation,
  }) = SpeakingPromptExercise;

  @FreezedUnionValue('ordering')
  const factory Exercise.ordering({
    required String id,
    required String question,
    required List<String> items,
    required List<int> correctOrder,
    String? explanation,
  }) = OrderingExercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  String get type => switch (this) {
        MultipleChoiceExercise() => 'multiple_choice',
        FillBlankExercise() => 'fill_blank',
        MatchingExercise() => 'matching',
        TrueFalseExercise() => 'true_false',
        SpeakingPromptExercise() => 'speaking_prompt',
        OrderingExercise() => 'ordering',
      };
}
