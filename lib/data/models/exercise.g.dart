// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchingPair _$MatchingPairFromJson(Map<String, dynamic> json) =>
    _MatchingPair(left: json['left'] as String, right: json['right'] as String);

Map<String, dynamic> _$MatchingPairToJson(_MatchingPair instance) =>
    <String, dynamic>{'left': instance.left, 'right': instance.right};

MultipleChoiceExercise _$MultipleChoiceExerciseFromJson(
  Map<String, dynamic> json,
) => MultipleChoiceExercise(
  id: json['id'] as String,
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  correctIndex: (json['correctIndex'] as num).toInt(),
  explanation: json['explanation'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MultipleChoiceExerciseToJson(
  MultipleChoiceExercise instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'options': instance.options,
  'correctIndex': instance.correctIndex,
  'explanation': instance.explanation,
  'type': instance.$type,
};

FillBlankExercise _$FillBlankExerciseFromJson(Map<String, dynamic> json) =>
    FillBlankExercise(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      acceptableAnswers:
          (json['acceptableAnswers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      explanation: json['explanation'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$FillBlankExerciseToJson(FillBlankExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'acceptableAnswers': instance.acceptableAnswers,
      'explanation': instance.explanation,
      'type': instance.$type,
    };

MatchingExercise _$MatchingExerciseFromJson(Map<String, dynamic> json) =>
    MatchingExercise(
      id: json['id'] as String,
      question: json['question'] as String,
      pairs: (json['pairs'] as List<dynamic>)
          .map((e) => MatchingPair.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$MatchingExerciseToJson(MatchingExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'pairs': instance.pairs,
      'explanation': instance.explanation,
      'type': instance.$type,
    };

TrueFalseExercise _$TrueFalseExerciseFromJson(Map<String, dynamic> json) =>
    TrueFalseExercise(
      id: json['id'] as String,
      question: json['question'] as String,
      correct: json['correct'] as bool,
      explanation: json['explanation'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$TrueFalseExerciseToJson(TrueFalseExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'correct': instance.correct,
      'explanation': instance.explanation,
      'type': instance.$type,
    };

SpeakingPromptExercise _$SpeakingPromptExerciseFromJson(
  Map<String, dynamic> json,
) => SpeakingPromptExercise(
  id: json['id'] as String,
  question: json['question'] as String,
  exampleAnswer: json['exampleAnswer'] as String,
  explanation: json['explanation'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$SpeakingPromptExerciseToJson(
  SpeakingPromptExercise instance,
) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'exampleAnswer': instance.exampleAnswer,
  'explanation': instance.explanation,
  'type': instance.$type,
};

OrderingExercise _$OrderingExerciseFromJson(Map<String, dynamic> json) =>
    OrderingExercise(
      id: json['id'] as String,
      question: json['question'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      correctOrder: (json['correctOrder'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      explanation: json['explanation'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$OrderingExerciseToJson(OrderingExercise instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'items': instance.items,
      'correctOrder': instance.correctOrder,
      'explanation': instance.explanation,
      'type': instance.$type,
    };
