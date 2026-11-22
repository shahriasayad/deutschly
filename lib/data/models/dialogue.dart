import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialogue.freezed.dart';
part 'dialogue.g.dart';

@freezed
abstract class DialogueLine with _$DialogueLine {
  const factory DialogueLine({
    required String speaker,
    required String text,
  }) = _DialogueLine;

  factory DialogueLine.fromJson(Map<String, dynamic> json) =>
      _$DialogueLineFromJson(json);
}

@freezed
abstract class Dialogue with _$Dialogue {
  const factory Dialogue({
    required String id,
    required String title,
    @Default(<DialogueLine>[]) List<DialogueLine> lines,
  }) = _Dialogue;

  factory Dialogue.fromJson(Map<String, dynamic> json) =>
      _$DialogueFromJson(json);
}
