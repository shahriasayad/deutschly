// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lesson {

 String get id; int get number; String get title; String get titleBn; List<String> get objectives; List<VocabularyItem> get vocabulary; List<GrammarPoint> get grammar; List<Dialogue> get dialogues; List<Exercise> get exercises;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleBn, titleBn) || other.titleBn == titleBn)&&const DeepCollectionEquality().equals(other.objectives, objectives)&&const DeepCollectionEquality().equals(other.vocabulary, vocabulary)&&const DeepCollectionEquality().equals(other.grammar, grammar)&&const DeepCollectionEquality().equals(other.dialogues, dialogues)&&const DeepCollectionEquality().equals(other.exercises, exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,title,titleBn,const DeepCollectionEquality().hash(objectives),const DeepCollectionEquality().hash(vocabulary),const DeepCollectionEquality().hash(grammar),const DeepCollectionEquality().hash(dialogues),const DeepCollectionEquality().hash(exercises));

@override
String toString() {
  return 'Lesson(id: $id, number: $number, title: $title, titleBn: $titleBn, objectives: $objectives, vocabulary: $vocabulary, grammar: $grammar, dialogues: $dialogues, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, int number, String title, String titleBn, List<String> objectives, List<VocabularyItem> vocabulary, List<GrammarPoint> grammar, List<Dialogue> dialogues, List<Exercise> exercises
});




}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? title = null,Object? titleBn = null,Object? objectives = null,Object? vocabulary = null,Object? grammar = null,Object? dialogues = null,Object? exercises = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleBn: null == titleBn ? _self.titleBn : titleBn // ignore: cast_nullable_to_non_nullable
as String,objectives: null == objectives ? _self.objectives : objectives // ignore: cast_nullable_to_non_nullable
as List<String>,vocabulary: null == vocabulary ? _self.vocabulary : vocabulary // ignore: cast_nullable_to_non_nullable
as List<VocabularyItem>,grammar: null == grammar ? _self.grammar : grammar // ignore: cast_nullable_to_non_nullable
as List<GrammarPoint>,dialogues: null == dialogues ? _self.dialogues : dialogues // ignore: cast_nullable_to_non_nullable
as List<Dialogue>,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,
  ));
}

}


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String title,  String titleBn,  List<String> objectives,  List<VocabularyItem> vocabulary,  List<GrammarPoint> grammar,  List<Dialogue> dialogues,  List<Exercise> exercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.titleBn,_that.objectives,_that.vocabulary,_that.grammar,_that.dialogues,_that.exercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String title,  String titleBn,  List<String> objectives,  List<VocabularyItem> vocabulary,  List<GrammarPoint> grammar,  List<Dialogue> dialogues,  List<Exercise> exercises)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.number,_that.title,_that.titleBn,_that.objectives,_that.vocabulary,_that.grammar,_that.dialogues,_that.exercises);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String title,  String titleBn,  List<String> objectives,  List<VocabularyItem> vocabulary,  List<GrammarPoint> grammar,  List<Dialogue> dialogues,  List<Exercise> exercises)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.number,_that.title,_that.titleBn,_that.objectives,_that.vocabulary,_that.grammar,_that.dialogues,_that.exercises);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({required this.id, required this.number, required this.title, required this.titleBn, final  List<String> objectives = const <String>[], final  List<VocabularyItem> vocabulary = const <VocabularyItem>[], final  List<GrammarPoint> grammar = const <GrammarPoint>[], final  List<Dialogue> dialogues = const <Dialogue>[], final  List<Exercise> exercises = const <Exercise>[]}): _objectives = objectives,_vocabulary = vocabulary,_grammar = grammar,_dialogues = dialogues,_exercises = exercises;
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  int number;
@override final  String title;
@override final  String titleBn;
 final  List<String> _objectives;
@override@JsonKey() List<String> get objectives {
  if (_objectives is EqualUnmodifiableListView) return _objectives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_objectives);
}

 final  List<VocabularyItem> _vocabulary;
@override@JsonKey() List<VocabularyItem> get vocabulary {
  if (_vocabulary is EqualUnmodifiableListView) return _vocabulary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vocabulary);
}

 final  List<GrammarPoint> _grammar;
@override@JsonKey() List<GrammarPoint> get grammar {
  if (_grammar is EqualUnmodifiableListView) return _grammar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grammar);
}

 final  List<Dialogue> _dialogues;
@override@JsonKey() List<Dialogue> get dialogues {
  if (_dialogues is EqualUnmodifiableListView) return _dialogues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dialogues);
}

 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleBn, titleBn) || other.titleBn == titleBn)&&const DeepCollectionEquality().equals(other._objectives, _objectives)&&const DeepCollectionEquality().equals(other._vocabulary, _vocabulary)&&const DeepCollectionEquality().equals(other._grammar, _grammar)&&const DeepCollectionEquality().equals(other._dialogues, _dialogues)&&const DeepCollectionEquality().equals(other._exercises, _exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,number,title,titleBn,const DeepCollectionEquality().hash(_objectives),const DeepCollectionEquality().hash(_vocabulary),const DeepCollectionEquality().hash(_grammar),const DeepCollectionEquality().hash(_dialogues),const DeepCollectionEquality().hash(_exercises));

@override
String toString() {
  return 'Lesson(id: $id, number: $number, title: $title, titleBn: $titleBn, objectives: $objectives, vocabulary: $vocabulary, grammar: $grammar, dialogues: $dialogues, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String title, String titleBn, List<String> objectives, List<VocabularyItem> vocabulary, List<GrammarPoint> grammar, List<Dialogue> dialogues, List<Exercise> exercises
});




}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? title = null,Object? titleBn = null,Object? objectives = null,Object? vocabulary = null,Object? grammar = null,Object? dialogues = null,Object? exercises = null,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleBn: null == titleBn ? _self.titleBn : titleBn // ignore: cast_nullable_to_non_nullable
as String,objectives: null == objectives ? _self._objectives : objectives // ignore: cast_nullable_to_non_nullable
as List<String>,vocabulary: null == vocabulary ? _self._vocabulary : vocabulary // ignore: cast_nullable_to_non_nullable
as List<VocabularyItem>,grammar: null == grammar ? _self._grammar : grammar // ignore: cast_nullable_to_non_nullable
as List<GrammarPoint>,dialogues: null == dialogues ? _self._dialogues : dialogues // ignore: cast_nullable_to_non_nullable
as List<Dialogue>,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,
  ));
}


}

// dart format on
