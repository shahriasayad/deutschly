import 'package:freezed_annotation/freezed_annotation.dart';

part 'grammar_point.freezed.dart';
part 'grammar_point.g.dart';

@freezed
abstract class GrammarPoint with _$GrammarPoint {
  const factory GrammarPoint({
    required String title,
    required String explanation,
    @Default(<String>[]) List<String> examples,
    Map<String, List<String>>? table,
  }) = _GrammarPoint;

  factory GrammarPoint.fromJson(Map<String, dynamic> json) =>
      _$GrammarPointFromJson(json);
}
