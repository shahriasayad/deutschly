import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deutschly/data/models/lesson.dart';

part 'course.freezed.dart';
part 'course.g.dart';

Object? _readCourseField(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey(key)) {
    return json[key];
  }
  final nestedCourse = json['course'];
  if (nestedCourse is Map<dynamic, dynamic>) {
    return nestedCourse[key];
  }
  return null;
}

@freezed
abstract class CourseMetadata with _$CourseMetadata {
  const factory CourseMetadata({
    required int totalExercises,
    @Default(<String>[]) List<String> exerciseTypes,
    @JsonKey(name: 'notes_for_developer')
    @Default(<String>[])
    List<String> notesForDeveloper,
  }) = _CourseMetadata;

  factory CourseMetadata.fromJson(Map<String, dynamic> json) =>
      _$CourseMetadataFromJson(json);
}

@freezed
abstract class Course with _$Course {
  const factory Course({
    @JsonKey(readValue: _readCourseField) required String id,
    @JsonKey(readValue: _readCourseField) required String title,
    @JsonKey(readValue: _readCourseField) required String level,
    @JsonKey(readValue: _readCourseField) required String language,
    @JsonKey(readValue: _readCourseField) required String description,
    @JsonKey(readValue: _readCourseField) required int totalLessons,
    @JsonKey(readValue: _readCourseField) required String version,
    @JsonKey(readValue: _readCourseField) required String created,
    @Default(<Lesson>[]) List<Lesson> lessons,
    CourseMetadata? metadata,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
