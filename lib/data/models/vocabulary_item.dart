import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_item.freezed.dart';
part 'vocabulary_item.g.dart';

@freezed
abstract class VocabularyItem with _$VocabularyItem {
  const factory VocabularyItem({
    required String de,
    required String en,
    required String bn,
    String? pronunciationBn,
  }) = _VocabularyItem;

  factory VocabularyItem.fromJson(Map<String, dynamic> json) =>
      _$VocabularyItemFromJson(json);
}
