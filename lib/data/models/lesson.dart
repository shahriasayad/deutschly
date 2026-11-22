import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deutschly/data/models/dialogue.dart';
import 'package:deutschly/data/models/exercise.dart';
import 'package:deutschly/data/models/grammar_point.dart';
import 'package:deutschly/data/models/vocabulary_item.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
abstract class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required int number,
    required String title,
    required String titleBn,
    @Default(<String>[]) List<String> objectives,
    @Default(<VocabularyItem>[]) List<VocabularyItem> vocabulary,
    @Default(<GrammarPoint>[]) List<GrammarPoint> grammar,
    @Default(<Dialogue>[]) List<Dialogue> dialogues,
    @Default(<Exercise>[]) List<Exercise> exercises,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}
