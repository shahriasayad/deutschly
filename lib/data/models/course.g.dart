// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseMetadata _$CourseMetadataFromJson(Map<String, dynamic> json) =>
    _CourseMetadata(
      totalExercises: (json['totalExercises'] as num).toInt(),
      exerciseTypes:
          (json['exerciseTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      notesForDeveloper:
          (json['notes_for_developer'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$CourseMetadataToJson(_CourseMetadata instance) =>
    <String, dynamic>{
      'totalExercises': instance.totalExercises,
      'exerciseTypes': instance.exerciseTypes,
      'notes_for_developer': instance.notesForDeveloper,
    };

_Course _$CourseFromJson(Map<String, dynamic> json) => _Course(
  id: _readCourseField(json, 'id') as String,
  title: _readCourseField(json, 'title') as String,
  level: _readCourseField(json, 'level') as String,
  language: _readCourseField(json, 'language') as String,
  description: _readCourseField(json, 'description') as String,
  totalLessons: (_readCourseField(json, 'totalLessons') as num).toInt(),
  version: _readCourseField(json, 'version') as String,
  created: _readCourseField(json, 'created') as String,
  lessons:
      (json['lessons'] as List<dynamic>?)
          ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Lesson>[],
  metadata: json['metadata'] == null
      ? null
      : CourseMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CourseToJson(_Course instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'level': instance.level,
  'language': instance.language,
  'description': instance.description,
  'totalLessons': instance.totalLessons,
  'version': instance.version,
  'created': instance.created,
  'lessons': instance.lessons,
  'metadata': instance.metadata,
};
