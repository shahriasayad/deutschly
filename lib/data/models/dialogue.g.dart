// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialogueLine _$DialogueLineFromJson(Map<String, dynamic> json) =>
    _DialogueLine(
      speaker: json['speaker'] as String,
      text: json['text'] as String,
      pronunciationBn: json['pronunciationBn'] as String?,
    );

Map<String, dynamic> _$DialogueLineToJson(_DialogueLine instance) =>
    <String, dynamic>{
      'speaker': instance.speaker,
      'text': instance.text,
      'pronunciationBn': instance.pronunciationBn,
    };

_Dialogue _$DialogueFromJson(Map<String, dynamic> json) => _Dialogue(
  id: json['id'] as String,
  title: json['title'] as String,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => DialogueLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DialogueLine>[],
);

Map<String, dynamic> _$DialogueToJson(_Dialogue instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'lines': instance.lines,
};
