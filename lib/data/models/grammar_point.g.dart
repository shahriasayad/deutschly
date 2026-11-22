// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrammarPoint _$GrammarPointFromJson(Map<String, dynamic> json) =>
    _GrammarPoint(
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      examples:
          (json['examples'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      table: (json['table'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

Map<String, dynamic> _$GrammarPointToJson(_GrammarPoint instance) =>
    <String, dynamic>{
      'title': instance.title,
      'explanation': instance.explanation,
      'examples': instance.examples,
      'table': instance.table,
    };
