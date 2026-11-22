// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(Map<String, dynamic> json) => _Lesson(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  title: json['title'] as String,
  titleBn: json['titleBn'] as String,
  objectives:
      (json['objectives'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  vocabulary:
      (json['vocabulary'] as List<dynamic>?)
          ?.map((e) => VocabularyItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <VocabularyItem>[],
  grammar:
      (json['grammar'] as List<dynamic>?)
          ?.map((e) => GrammarPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GrammarPoint>[],
  dialogues:
      (json['dialogues'] as List<dynamic>?)
          ?.map((e) => Dialogue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Dialogue>[],
  exercises:
      (json['exercises'] as List<dynamic>?)
          ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Exercise>[],
);

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'title': instance.title,
  'titleBn': instance.titleBn,
  'objectives': instance.objectives,
  'vocabulary': instance.vocabulary,
  'grammar': instance.grammar,
  'dialogues': instance.dialogues,
  'exercises': instance.exercises,
};
