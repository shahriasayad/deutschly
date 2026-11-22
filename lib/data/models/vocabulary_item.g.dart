// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VocabularyItem _$VocabularyItemFromJson(Map<String, dynamic> json) =>
    _VocabularyItem(
      de: json['de'] as String,
      en: json['en'] as String,
      bn: json['bn'] as String,
      pronunciationBn: json['pronunciationBn'] as String?,
    );

Map<String, dynamic> _$VocabularyItemToJson(_VocabularyItem instance) =>
    <String, dynamic>{
      'de': instance.de,
      'en': instance.en,
      'bn': instance.bn,
      'pronunciationBn': instance.pronunciationBn,
    };
