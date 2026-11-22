// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseMetadata {

 int get totalExercises; List<String> get exerciseTypes;@JsonKey(name: 'notes_for_developer') List<String> get notesForDeveloper;
/// Create a copy of CourseMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseMetadataCopyWith<CourseMetadata> get copyWith => _$CourseMetadataCopyWithImpl<CourseMetadata>(this as CourseMetadata, _$identity);

  /// Serializes this CourseMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseMetadata&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises)&&const DeepCollectionEquality().equals(other.exerciseTypes, exerciseTypes)&&const DeepCollectionEquality().equals(other.notesForDeveloper, notesForDeveloper));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalExercises,const DeepCollectionEquality().hash(exerciseTypes),const DeepCollectionEquality().hash(notesForDeveloper));

@override
String toString() {
  return 'CourseMetadata(totalExercises: $totalExercises, exerciseTypes: $exerciseTypes, notesForDeveloper: $notesForDeveloper)';
}


}

/// @nodoc
abstract mixin class $CourseMetadataCopyWith<$Res>  {
  factory $CourseMetadataCopyWith(CourseMetadata value, $Res Function(CourseMetadata) _then) = _$CourseMetadataCopyWithImpl;
@useResult
$Res call({
 int totalExercises, List<String> exerciseTypes,@JsonKey(name: 'notes_for_developer') List<String> notesForDeveloper
});




}
/// @nodoc
class _$CourseMetadataCopyWithImpl<$Res>
    implements $CourseMetadataCopyWith<$Res> {
  _$CourseMetadataCopyWithImpl(this._self, this._then);

  final CourseMetadata _self;
  final $Res Function(CourseMetadata) _then;

/// Create a copy of CourseMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalExercises = null,Object? exerciseTypes = null,Object? notesForDeveloper = null,}) {
  return _then(_self.copyWith(
totalExercises: null == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int,exerciseTypes: null == exerciseTypes ? _self.exerciseTypes : exerciseTypes // ignore: cast_nullable_to_non_nullable
as List<String>,notesForDeveloper: null == notesForDeveloper ? _self.notesForDeveloper : notesForDeveloper // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseMetadata].
extension CourseMetadataPatterns on CourseMetadata {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseMetadata() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseMetadata value)  $default,){
final _that = this;
switch (_that) {
case _CourseMetadata():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _CourseMetadata() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalExercises,  List<String> exerciseTypes, @JsonKey(name: 'notes_for_developer')  List<String> notesForDeveloper)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseMetadata() when $default != null:
return $default(_that.totalExercises,_that.exerciseTypes,_that.notesForDeveloper);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalExercises,  List<String> exerciseTypes, @JsonKey(name: 'notes_for_developer')  List<String> notesForDeveloper)  $default,) {final _that = this;
switch (_that) {
case _CourseMetadata():
return $default(_that.totalExercises,_that.exerciseTypes,_that.notesForDeveloper);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalExercises,  List<String> exerciseTypes, @JsonKey(name: 'notes_for_developer')  List<String> notesForDeveloper)?  $default,) {final _that = this;
switch (_that) {
case _CourseMetadata() when $default != null:
return $default(_that.totalExercises,_that.exerciseTypes,_that.notesForDeveloper);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseMetadata implements CourseMetadata {
  const _CourseMetadata({required this.totalExercises, final  List<String> exerciseTypes = const <String>[], @JsonKey(name: 'notes_for_developer') final  List<String> notesForDeveloper = const <String>[]}): _exerciseTypes = exerciseTypes,_notesForDeveloper = notesForDeveloper;
  factory _CourseMetadata.fromJson(Map<String, dynamic> json) => _$CourseMetadataFromJson(json);

@override final  int totalExercises;
 final  List<String> _exerciseTypes;
@override@JsonKey() List<String> get exerciseTypes {
  if (_exerciseTypes is EqualUnmodifiableListView) return _exerciseTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exerciseTypes);
}

 final  List<String> _notesForDeveloper;
@override@JsonKey(name: 'notes_for_developer') List<String> get notesForDeveloper {
  if (_notesForDeveloper is EqualUnmodifiableListView) return _notesForDeveloper;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notesForDeveloper);
}


/// Create a copy of CourseMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseMetadataCopyWith<_CourseMetadata> get copyWith => __$CourseMetadataCopyWithImpl<_CourseMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseMetadata&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises)&&const DeepCollectionEquality().equals(other._exerciseTypes, _exerciseTypes)&&const DeepCollectionEquality().equals(other._notesForDeveloper, _notesForDeveloper));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalExercises,const DeepCollectionEquality().hash(_exerciseTypes),const DeepCollectionEquality().hash(_notesForDeveloper));

@override
String toString() {
  return 'CourseMetadata(totalExercises: $totalExercises, exerciseTypes: $exerciseTypes, notesForDeveloper: $notesForDeveloper)';
}


}

/// @nodoc
abstract mixin class _$CourseMetadataCopyWith<$Res> implements $CourseMetadataCopyWith<$Res> {
  factory _$CourseMetadataCopyWith(_CourseMetadata value, $Res Function(_CourseMetadata) _then) = __$CourseMetadataCopyWithImpl;
@override @useResult
$Res call({
 int totalExercises, List<String> exerciseTypes,@JsonKey(name: 'notes_for_developer') List<String> notesForDeveloper
});




}
/// @nodoc
class __$CourseMetadataCopyWithImpl<$Res>
    implements _$CourseMetadataCopyWith<$Res> {
  __$CourseMetadataCopyWithImpl(this._self, this._then);

  final _CourseMetadata _self;
  final $Res Function(_CourseMetadata) _then;

/// Create a copy of CourseMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalExercises = null,Object? exerciseTypes = null,Object? notesForDeveloper = null,}) {
  return _then(_CourseMetadata(
totalExercises: null == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int,exerciseTypes: null == exerciseTypes ? _self._exerciseTypes : exerciseTypes // ignore: cast_nullable_to_non_nullable
as List<String>,notesForDeveloper: null == notesForDeveloper ? _self._notesForDeveloper : notesForDeveloper // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$Course {

@JsonKey(readValue: _readCourseField) String get id;@JsonKey(readValue: _readCourseField) String get title;@JsonKey(readValue: _readCourseField) String get level;@JsonKey(readValue: _readCourseField) String get language;@JsonKey(readValue: _readCourseField) String get description;@JsonKey(readValue: _readCourseField) int get totalLessons;@JsonKey(readValue: _readCourseField) String get version;@JsonKey(readValue: _readCourseField) String get created; List<Lesson> get lessons; CourseMetadata? get metadata;
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCopyWith<Course> get copyWith => _$CourseCopyWithImpl<Course>(this as Course, _$identity);

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Course&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.level, level) || other.level == level)&&(identical(other.language, language) || other.language == language)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalLessons, totalLessons) || other.totalLessons == totalLessons)&&(identical(other.version, version) || other.version == version)&&(identical(other.created, created) || other.created == created)&&const DeepCollectionEquality().equals(other.lessons, lessons)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,level,language,description,totalLessons,version,created,const DeepCollectionEquality().hash(lessons),metadata);

@override
String toString() {
  return 'Course(id: $id, title: $title, level: $level, language: $language, description: $description, totalLessons: $totalLessons, version: $version, created: $created, lessons: $lessons, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $CourseCopyWith<$Res>  {
  factory $CourseCopyWith(Course value, $Res Function(Course) _then) = _$CourseCopyWithImpl;
@useResult
$Res call({
@JsonKey(readValue: _readCourseField) String id,@JsonKey(readValue: _readCourseField) String title,@JsonKey(readValue: _readCourseField) String level,@JsonKey(readValue: _readCourseField) String language,@JsonKey(readValue: _readCourseField) String description,@JsonKey(readValue: _readCourseField) int totalLessons,@JsonKey(readValue: _readCourseField) String version,@JsonKey(readValue: _readCourseField) String created, List<Lesson> lessons, CourseMetadata? metadata
});


$CourseMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$CourseCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._self, this._then);

  final Course _self;
  final $Res Function(Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? level = null,Object? language = null,Object? description = null,Object? totalLessons = null,Object? version = null,Object? created = null,Object? lessons = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,totalLessons: null == totalLessons ? _self.totalLessons : totalLessons // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as CourseMetadata?,
  ));
}
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $CourseMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [Course].
extension CoursePatterns on Course {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Course value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Course value)  $default,){
final _that = this;
switch (_that) {
case _Course():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Course value)?  $default,){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readCourseField)  String id, @JsonKey(readValue: _readCourseField)  String title, @JsonKey(readValue: _readCourseField)  String level, @JsonKey(readValue: _readCourseField)  String language, @JsonKey(readValue: _readCourseField)  String description, @JsonKey(readValue: _readCourseField)  int totalLessons, @JsonKey(readValue: _readCourseField)  String version, @JsonKey(readValue: _readCourseField)  String created,  List<Lesson> lessons,  CourseMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.title,_that.level,_that.language,_that.description,_that.totalLessons,_that.version,_that.created,_that.lessons,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(readValue: _readCourseField)  String id, @JsonKey(readValue: _readCourseField)  String title, @JsonKey(readValue: _readCourseField)  String level, @JsonKey(readValue: _readCourseField)  String language, @JsonKey(readValue: _readCourseField)  String description, @JsonKey(readValue: _readCourseField)  int totalLessons, @JsonKey(readValue: _readCourseField)  String version, @JsonKey(readValue: _readCourseField)  String created,  List<Lesson> lessons,  CourseMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _Course():
return $default(_that.id,_that.title,_that.level,_that.language,_that.description,_that.totalLessons,_that.version,_that.created,_that.lessons,_that.metadata);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(readValue: _readCourseField)  String id, @JsonKey(readValue: _readCourseField)  String title, @JsonKey(readValue: _readCourseField)  String level, @JsonKey(readValue: _readCourseField)  String language, @JsonKey(readValue: _readCourseField)  String description, @JsonKey(readValue: _readCourseField)  int totalLessons, @JsonKey(readValue: _readCourseField)  String version, @JsonKey(readValue: _readCourseField)  String created,  List<Lesson> lessons,  CourseMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.title,_that.level,_that.language,_that.description,_that.totalLessons,_that.version,_that.created,_that.lessons,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Course implements Course {
  const _Course({@JsonKey(readValue: _readCourseField) required this.id, @JsonKey(readValue: _readCourseField) required this.title, @JsonKey(readValue: _readCourseField) required this.level, @JsonKey(readValue: _readCourseField) required this.language, @JsonKey(readValue: _readCourseField) required this.description, @JsonKey(readValue: _readCourseField) required this.totalLessons, @JsonKey(readValue: _readCourseField) required this.version, @JsonKey(readValue: _readCourseField) required this.created, final  List<Lesson> lessons = const <Lesson>[], this.metadata}): _lessons = lessons;
  factory _Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

@override@JsonKey(readValue: _readCourseField) final  String id;
@override@JsonKey(readValue: _readCourseField) final  String title;
@override@JsonKey(readValue: _readCourseField) final  String level;
@override@JsonKey(readValue: _readCourseField) final  String language;
@override@JsonKey(readValue: _readCourseField) final  String description;
@override@JsonKey(readValue: _readCourseField) final  int totalLessons;
@override@JsonKey(readValue: _readCourseField) final  String version;
@override@JsonKey(readValue: _readCourseField) final  String created;
 final  List<Lesson> _lessons;
@override@JsonKey() List<Lesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}

@override final  CourseMetadata? metadata;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCopyWith<_Course> get copyWith => __$CourseCopyWithImpl<_Course>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Course&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.level, level) || other.level == level)&&(identical(other.language, language) || other.language == language)&&(identical(other.description, description) || other.description == description)&&(identical(other.totalLessons, totalLessons) || other.totalLessons == totalLessons)&&(identical(other.version, version) || other.version == version)&&(identical(other.created, created) || other.created == created)&&const DeepCollectionEquality().equals(other._lessons, _lessons)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,level,language,description,totalLessons,version,created,const DeepCollectionEquality().hash(_lessons),metadata);

@override
String toString() {
  return 'Course(id: $id, title: $title, level: $level, language: $language, description: $description, totalLessons: $totalLessons, version: $version, created: $created, lessons: $lessons, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$CourseCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$CourseCopyWith(_Course value, $Res Function(_Course) _then) = __$CourseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(readValue: _readCourseField) String id,@JsonKey(readValue: _readCourseField) String title,@JsonKey(readValue: _readCourseField) String level,@JsonKey(readValue: _readCourseField) String language,@JsonKey(readValue: _readCourseField) String description,@JsonKey(readValue: _readCourseField) int totalLessons,@JsonKey(readValue: _readCourseField) String version,@JsonKey(readValue: _readCourseField) String created, List<Lesson> lessons, CourseMetadata? metadata
});


@override $CourseMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$CourseCopyWithImpl<$Res>
    implements _$CourseCopyWith<$Res> {
  __$CourseCopyWithImpl(this._self, this._then);

  final _Course _self;
  final $Res Function(_Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? level = null,Object? language = null,Object? description = null,Object? totalLessons = null,Object? version = null,Object? created = null,Object? lessons = null,Object? metadata = freezed,}) {
  return _then(_Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,totalLessons: null == totalLessons ? _self.totalLessons : totalLessons // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<Lesson>,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as CourseMetadata?,
  ));
}

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $CourseMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
