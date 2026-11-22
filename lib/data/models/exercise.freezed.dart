// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchingPair {

 String get left; String get right;
/// Create a copy of MatchingPair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchingPairCopyWith<MatchingPair> get copyWith => _$MatchingPairCopyWithImpl<MatchingPair>(this as MatchingPair, _$identity);

  /// Serializes this MatchingPair to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchingPair&&(identical(other.left, left) || other.left == left)&&(identical(other.right, right) || other.right == right));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,left,right);

@override
String toString() {
  return 'MatchingPair(left: $left, right: $right)';
}


}

/// @nodoc
abstract mixin class $MatchingPairCopyWith<$Res>  {
  factory $MatchingPairCopyWith(MatchingPair value, $Res Function(MatchingPair) _then) = _$MatchingPairCopyWithImpl;
@useResult
$Res call({
 String left, String right
});




}
/// @nodoc
class _$MatchingPairCopyWithImpl<$Res>
    implements $MatchingPairCopyWith<$Res> {
  _$MatchingPairCopyWithImpl(this._self, this._then);

  final MatchingPair _self;
  final $Res Function(MatchingPair) _then;

/// Create a copy of MatchingPair
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? left = null,Object? right = null,}) {
  return _then(_self.copyWith(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as String,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchingPair].
extension MatchingPairPatterns on MatchingPair {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchingPair value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchingPair() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchingPair value)  $default,){
final _that = this;
switch (_that) {
case _MatchingPair():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchingPair value)?  $default,){
final _that = this;
switch (_that) {
case _MatchingPair() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String left,  String right)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchingPair() when $default != null:
return $default(_that.left,_that.right);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String left,  String right)  $default,) {final _that = this;
switch (_that) {
case _MatchingPair():
return $default(_that.left,_that.right);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String left,  String right)?  $default,) {final _that = this;
switch (_that) {
case _MatchingPair() when $default != null:
return $default(_that.left,_that.right);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchingPair implements MatchingPair {
  const _MatchingPair({required this.left, required this.right});
  factory _MatchingPair.fromJson(Map<String, dynamic> json) => _$MatchingPairFromJson(json);

@override final  String left;
@override final  String right;

/// Create a copy of MatchingPair
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchingPairCopyWith<_MatchingPair> get copyWith => __$MatchingPairCopyWithImpl<_MatchingPair>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchingPairToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchingPair&&(identical(other.left, left) || other.left == left)&&(identical(other.right, right) || other.right == right));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,left,right);

@override
String toString() {
  return 'MatchingPair(left: $left, right: $right)';
}


}

/// @nodoc
abstract mixin class _$MatchingPairCopyWith<$Res> implements $MatchingPairCopyWith<$Res> {
  factory _$MatchingPairCopyWith(_MatchingPair value, $Res Function(_MatchingPair) _then) = __$MatchingPairCopyWithImpl;
@override @useResult
$Res call({
 String left, String right
});




}
/// @nodoc
class __$MatchingPairCopyWithImpl<$Res>
    implements _$MatchingPairCopyWith<$Res> {
  __$MatchingPairCopyWithImpl(this._self, this._then);

  final _MatchingPair _self;
  final $Res Function(_MatchingPair) _then;

/// Create a copy of MatchingPair
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? left = null,Object? right = null,}) {
  return _then(_MatchingPair(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as String,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

Exercise _$ExerciseFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'multiple_choice':
          return MultipleChoiceExercise.fromJson(
            json
          );
                case 'fill_blank':
          return FillBlankExercise.fromJson(
            json
          );
                case 'matching':
          return MatchingExercise.fromJson(
            json
          );
                case 'true_false':
          return TrueFalseExercise.fromJson(
            json
          );
                case 'speaking_prompt':
          return SpeakingPromptExercise.fromJson(
            json
          );
                case 'ordering':
          return OrderingExercise.fromJson(
            json
          );
                case 'writing_prompt':
          return WritingPromptExercise.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'Exercise',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$Exercise {

 String get id; String get question; String? get explanation; String? get pronunciationBn;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise(id: $id, question: $question, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String question, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MultipleChoiceExercise value)?  multipleChoice,TResult Function( FillBlankExercise value)?  fillBlank,TResult Function( MatchingExercise value)?  matching,TResult Function( TrueFalseExercise value)?  trueFalse,TResult Function( SpeakingPromptExercise value)?  speakingPrompt,TResult Function( OrderingExercise value)?  ordering,TResult Function( WritingPromptExercise value)?  writingPrompt,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MultipleChoiceExercise() when multipleChoice != null:
return multipleChoice(_that);case FillBlankExercise() when fillBlank != null:
return fillBlank(_that);case MatchingExercise() when matching != null:
return matching(_that);case TrueFalseExercise() when trueFalse != null:
return trueFalse(_that);case SpeakingPromptExercise() when speakingPrompt != null:
return speakingPrompt(_that);case OrderingExercise() when ordering != null:
return ordering(_that);case WritingPromptExercise() when writingPrompt != null:
return writingPrompt(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MultipleChoiceExercise value)  multipleChoice,required TResult Function( FillBlankExercise value)  fillBlank,required TResult Function( MatchingExercise value)  matching,required TResult Function( TrueFalseExercise value)  trueFalse,required TResult Function( SpeakingPromptExercise value)  speakingPrompt,required TResult Function( OrderingExercise value)  ordering,required TResult Function( WritingPromptExercise value)  writingPrompt,}){
final _that = this;
switch (_that) {
case MultipleChoiceExercise():
return multipleChoice(_that);case FillBlankExercise():
return fillBlank(_that);case MatchingExercise():
return matching(_that);case TrueFalseExercise():
return trueFalse(_that);case SpeakingPromptExercise():
return speakingPrompt(_that);case OrderingExercise():
return ordering(_that);case WritingPromptExercise():
return writingPrompt(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MultipleChoiceExercise value)?  multipleChoice,TResult? Function( FillBlankExercise value)?  fillBlank,TResult? Function( MatchingExercise value)?  matching,TResult? Function( TrueFalseExercise value)?  trueFalse,TResult? Function( SpeakingPromptExercise value)?  speakingPrompt,TResult? Function( OrderingExercise value)?  ordering,TResult? Function( WritingPromptExercise value)?  writingPrompt,}){
final _that = this;
switch (_that) {
case MultipleChoiceExercise() when multipleChoice != null:
return multipleChoice(_that);case FillBlankExercise() when fillBlank != null:
return fillBlank(_that);case MatchingExercise() when matching != null:
return matching(_that);case TrueFalseExercise() when trueFalse != null:
return trueFalse(_that);case SpeakingPromptExercise() when speakingPrompt != null:
return speakingPrompt(_that);case OrderingExercise() when ordering != null:
return ordering(_that);case WritingPromptExercise() when writingPrompt != null:
return writingPrompt(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String question,  List<String> options,  int correctIndex,  String? explanation,  String? pronunciationBn)?  multipleChoice,TResult Function( String id,  String question,  String answer,  List<String> acceptableAnswers,  String? explanation,  String? pronunciationBn)?  fillBlank,TResult Function( String id,  String question,  List<MatchingPair> pairs,  String? explanation,  String? pronunciationBn)?  matching,TResult Function( String id,  String question,  bool correct,  String? explanation,  String? pronunciationBn)?  trueFalse,TResult Function( String id,  String question,  String exampleAnswer,  String? explanation,  String? pronunciationBn)?  speakingPrompt,TResult Function( String id,  String question,  List<String> items,  List<int> correctOrder,  String? explanation,  String? pronunciationBn)?  ordering,TResult Function( String id,  String question,  String exampleAnswer,  String? explanation,  String? pronunciationBn)?  writingPrompt,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MultipleChoiceExercise() when multipleChoice != null:
return multipleChoice(_that.id,_that.question,_that.options,_that.correctIndex,_that.explanation,_that.pronunciationBn);case FillBlankExercise() when fillBlank != null:
return fillBlank(_that.id,_that.question,_that.answer,_that.acceptableAnswers,_that.explanation,_that.pronunciationBn);case MatchingExercise() when matching != null:
return matching(_that.id,_that.question,_that.pairs,_that.explanation,_that.pronunciationBn);case TrueFalseExercise() when trueFalse != null:
return trueFalse(_that.id,_that.question,_that.correct,_that.explanation,_that.pronunciationBn);case SpeakingPromptExercise() when speakingPrompt != null:
return speakingPrompt(_that.id,_that.question,_that.exampleAnswer,_that.explanation,_that.pronunciationBn);case OrderingExercise() when ordering != null:
return ordering(_that.id,_that.question,_that.items,_that.correctOrder,_that.explanation,_that.pronunciationBn);case WritingPromptExercise() when writingPrompt != null:
return writingPrompt(_that.id,_that.question,_that.exampleAnswer,_that.explanation,_that.pronunciationBn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String question,  List<String> options,  int correctIndex,  String? explanation,  String? pronunciationBn)  multipleChoice,required TResult Function( String id,  String question,  String answer,  List<String> acceptableAnswers,  String? explanation,  String? pronunciationBn)  fillBlank,required TResult Function( String id,  String question,  List<MatchingPair> pairs,  String? explanation,  String? pronunciationBn)  matching,required TResult Function( String id,  String question,  bool correct,  String? explanation,  String? pronunciationBn)  trueFalse,required TResult Function( String id,  String question,  String exampleAnswer,  String? explanation,  String? pronunciationBn)  speakingPrompt,required TResult Function( String id,  String question,  List<String> items,  List<int> correctOrder,  String? explanation,  String? pronunciationBn)  ordering,required TResult Function( String id,  String question,  String exampleAnswer,  String? explanation,  String? pronunciationBn)  writingPrompt,}) {final _that = this;
switch (_that) {
case MultipleChoiceExercise():
return multipleChoice(_that.id,_that.question,_that.options,_that.correctIndex,_that.explanation,_that.pronunciationBn);case FillBlankExercise():
return fillBlank(_that.id,_that.question,_that.answer,_that.acceptableAnswers,_that.explanation,_that.pronunciationBn);case MatchingExercise():
return matching(_that.id,_that.question,_that.pairs,_that.explanation,_that.pronunciationBn);case TrueFalseExercise():
return trueFalse(_that.id,_that.question,_that.correct,_that.explanation,_that.pronunciationBn);case SpeakingPromptExercise():
return speakingPrompt(_that.id,_that.question,_that.exampleAnswer,_that.explanation,_that.pronunciationBn);case OrderingExercise():
return ordering(_that.id,_that.question,_that.items,_that.correctOrder,_that.explanation,_that.pronunciationBn);case WritingPromptExercise():
return writingPrompt(_that.id,_that.question,_that.exampleAnswer,_that.explanation,_that.pronunciationBn);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String question,  List<String> options,  int correctIndex,  String? explanation,  String? pronunciationBn)?  multipleChoice,TResult? Function( String id,  String question,  String answer,  List<String> acceptableAnswers,  String? explanation,  String? pronunciationBn)?  fillBlank,TResult? Function( String id,  String question,  List<MatchingPair> pairs,  String? explanation,  String? pronunciationBn)?  matching,TResult? Function( String id,  String question,  bool correct,  String? explanation,  String? pronunciationBn)?  trueFalse,TResult? Function( String id,  String question,  String exampleAnswer,  String? explanation,  String? pronunciationBn)?  speakingPrompt,TResult? Function( String id,  String question,  List<String> items,  List<int> correctOrder,  String? explanation,  String? pronunciationBn)?  ordering,TResult? Function( String id,  String question,  String exampleAnswer,  String? explanation,  String? pronunciationBn)?  writingPrompt,}) {final _that = this;
switch (_that) {
case MultipleChoiceExercise() when multipleChoice != null:
return multipleChoice(_that.id,_that.question,_that.options,_that.correctIndex,_that.explanation,_that.pronunciationBn);case FillBlankExercise() when fillBlank != null:
return fillBlank(_that.id,_that.question,_that.answer,_that.acceptableAnswers,_that.explanation,_that.pronunciationBn);case MatchingExercise() when matching != null:
return matching(_that.id,_that.question,_that.pairs,_that.explanation,_that.pronunciationBn);case TrueFalseExercise() when trueFalse != null:
return trueFalse(_that.id,_that.question,_that.correct,_that.explanation,_that.pronunciationBn);case SpeakingPromptExercise() when speakingPrompt != null:
return speakingPrompt(_that.id,_that.question,_that.exampleAnswer,_that.explanation,_that.pronunciationBn);case OrderingExercise() when ordering != null:
return ordering(_that.id,_that.question,_that.items,_that.correctOrder,_that.explanation,_that.pronunciationBn);case WritingPromptExercise() when writingPrompt != null:
return writingPrompt(_that.id,_that.question,_that.exampleAnswer,_that.explanation,_that.pronunciationBn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class MultipleChoiceExercise extends Exercise {
  const MultipleChoiceExercise({required this.id, required this.question, required final  List<String> options, required this.correctIndex, this.explanation, this.pronunciationBn, final  String? $type}): _options = options,$type = $type ?? 'multiple_choice',super._();
  factory MultipleChoiceExercise.fromJson(Map<String, dynamic> json) => _$MultipleChoiceExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  List<String> _options;
 List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  int correctIndex;
@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultipleChoiceExerciseCopyWith<MultipleChoiceExercise> get copyWith => _$MultipleChoiceExerciseCopyWithImpl<MultipleChoiceExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultipleChoiceExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultipleChoiceExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(_options),correctIndex,explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.multipleChoice(id: $id, question: $question, options: $options, correctIndex: $correctIndex, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $MultipleChoiceExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $MultipleChoiceExerciseCopyWith(MultipleChoiceExercise value, $Res Function(MultipleChoiceExercise) _then) = _$MultipleChoiceExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, List<String> options, int correctIndex, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$MultipleChoiceExerciseCopyWithImpl<$Res>
    implements $MultipleChoiceExerciseCopyWith<$Res> {
  _$MultipleChoiceExerciseCopyWithImpl(this._self, this._then);

  final MultipleChoiceExercise _self;
  final $Res Function(MultipleChoiceExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? options = null,Object? correctIndex = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(MultipleChoiceExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class FillBlankExercise extends Exercise {
  const FillBlankExercise({required this.id, required this.question, required this.answer, final  List<String> acceptableAnswers = const <String>[], this.explanation, this.pronunciationBn, final  String? $type}): _acceptableAnswers = acceptableAnswers,$type = $type ?? 'fill_blank',super._();
  factory FillBlankExercise.fromJson(Map<String, dynamic> json) => _$FillBlankExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  String answer;
 final  List<String> _acceptableAnswers;
@JsonKey() List<String> get acceptableAnswers {
  if (_acceptableAnswers is EqualUnmodifiableListView) return _acceptableAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_acceptableAnswers);
}

@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FillBlankExerciseCopyWith<FillBlankExercise> get copyWith => _$FillBlankExerciseCopyWithImpl<FillBlankExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FillBlankExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FillBlankExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other._acceptableAnswers, _acceptableAnswers)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,answer,const DeepCollectionEquality().hash(_acceptableAnswers),explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.fillBlank(id: $id, question: $question, answer: $answer, acceptableAnswers: $acceptableAnswers, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $FillBlankExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $FillBlankExerciseCopyWith(FillBlankExercise value, $Res Function(FillBlankExercise) _then) = _$FillBlankExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, String answer, List<String> acceptableAnswers, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$FillBlankExerciseCopyWithImpl<$Res>
    implements $FillBlankExerciseCopyWith<$Res> {
  _$FillBlankExerciseCopyWithImpl(this._self, this._then);

  final FillBlankExercise _self;
  final $Res Function(FillBlankExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? answer = null,Object? acceptableAnswers = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(FillBlankExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,acceptableAnswers: null == acceptableAnswers ? _self._acceptableAnswers : acceptableAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MatchingExercise extends Exercise {
  const MatchingExercise({required this.id, required this.question, required final  List<MatchingPair> pairs, this.explanation, this.pronunciationBn, final  String? $type}): _pairs = pairs,$type = $type ?? 'matching',super._();
  factory MatchingExercise.fromJson(Map<String, dynamic> json) => _$MatchingExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  List<MatchingPair> _pairs;
 List<MatchingPair> get pairs {
  if (_pairs is EqualUnmodifiableListView) return _pairs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pairs);
}

@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchingExerciseCopyWith<MatchingExercise> get copyWith => _$MatchingExerciseCopyWithImpl<MatchingExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchingExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchingExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._pairs, _pairs)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(_pairs),explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.matching(id: $id, question: $question, pairs: $pairs, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $MatchingExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $MatchingExerciseCopyWith(MatchingExercise value, $Res Function(MatchingExercise) _then) = _$MatchingExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, List<MatchingPair> pairs, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$MatchingExerciseCopyWithImpl<$Res>
    implements $MatchingExerciseCopyWith<$Res> {
  _$MatchingExerciseCopyWithImpl(this._self, this._then);

  final MatchingExercise _self;
  final $Res Function(MatchingExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? pairs = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(MatchingExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,pairs: null == pairs ? _self._pairs : pairs // ignore: cast_nullable_to_non_nullable
as List<MatchingPair>,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TrueFalseExercise extends Exercise {
  const TrueFalseExercise({required this.id, required this.question, required this.correct, this.explanation, this.pronunciationBn, final  String? $type}): $type = $type ?? 'true_false',super._();
  factory TrueFalseExercise.fromJson(Map<String, dynamic> json) => _$TrueFalseExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  bool correct;
@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrueFalseExerciseCopyWith<TrueFalseExercise> get copyWith => _$TrueFalseExerciseCopyWithImpl<TrueFalseExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrueFalseExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrueFalseExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,correct,explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.trueFalse(id: $id, question: $question, correct: $correct, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $TrueFalseExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $TrueFalseExerciseCopyWith(TrueFalseExercise value, $Res Function(TrueFalseExercise) _then) = _$TrueFalseExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, bool correct, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$TrueFalseExerciseCopyWithImpl<$Res>
    implements $TrueFalseExerciseCopyWith<$Res> {
  _$TrueFalseExerciseCopyWithImpl(this._self, this._then);

  final TrueFalseExercise _self;
  final $Res Function(TrueFalseExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? correct = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(TrueFalseExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SpeakingPromptExercise extends Exercise {
  const SpeakingPromptExercise({required this.id, required this.question, required this.exampleAnswer, this.explanation, this.pronunciationBn, final  String? $type}): $type = $type ?? 'speaking_prompt',super._();
  factory SpeakingPromptExercise.fromJson(Map<String, dynamic> json) => _$SpeakingPromptExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  String exampleAnswer;
@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakingPromptExerciseCopyWith<SpeakingPromptExercise> get copyWith => _$SpeakingPromptExerciseCopyWithImpl<SpeakingPromptExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeakingPromptExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakingPromptExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.exampleAnswer, exampleAnswer) || other.exampleAnswer == exampleAnswer)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,exampleAnswer,explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.speakingPrompt(id: $id, question: $question, exampleAnswer: $exampleAnswer, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $SpeakingPromptExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $SpeakingPromptExerciseCopyWith(SpeakingPromptExercise value, $Res Function(SpeakingPromptExercise) _then) = _$SpeakingPromptExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, String exampleAnswer, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$SpeakingPromptExerciseCopyWithImpl<$Res>
    implements $SpeakingPromptExerciseCopyWith<$Res> {
  _$SpeakingPromptExerciseCopyWithImpl(this._self, this._then);

  final SpeakingPromptExercise _self;
  final $Res Function(SpeakingPromptExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? exampleAnswer = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(SpeakingPromptExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,exampleAnswer: null == exampleAnswer ? _self.exampleAnswer : exampleAnswer // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class OrderingExercise extends Exercise {
  const OrderingExercise({required this.id, required this.question, required final  List<String> items, required final  List<int> correctOrder, this.explanation, this.pronunciationBn, final  String? $type}): _items = items,_correctOrder = correctOrder,$type = $type ?? 'ordering',super._();
  factory OrderingExercise.fromJson(Map<String, dynamic> json) => _$OrderingExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  List<String> _items;
 List<String> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<int> _correctOrder;
 List<int> get correctOrder {
  if (_correctOrder is EqualUnmodifiableListView) return _correctOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_correctOrder);
}

@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderingExerciseCopyWith<OrderingExercise> get copyWith => _$OrderingExerciseCopyWithImpl<OrderingExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderingExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderingExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._correctOrder, _correctOrder)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_correctOrder),explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.ordering(id: $id, question: $question, items: $items, correctOrder: $correctOrder, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $OrderingExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $OrderingExerciseCopyWith(OrderingExercise value, $Res Function(OrderingExercise) _then) = _$OrderingExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, List<String> items, List<int> correctOrder, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$OrderingExerciseCopyWithImpl<$Res>
    implements $OrderingExerciseCopyWith<$Res> {
  _$OrderingExerciseCopyWithImpl(this._self, this._then);

  final OrderingExercise _self;
  final $Res Function(OrderingExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? items = null,Object? correctOrder = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(OrderingExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<String>,correctOrder: null == correctOrder ? _self._correctOrder : correctOrder // ignore: cast_nullable_to_non_nullable
as List<int>,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class WritingPromptExercise extends Exercise {
  const WritingPromptExercise({required this.id, required this.question, required this.exampleAnswer, this.explanation, this.pronunciationBn, final  String? $type}): $type = $type ?? 'writing_prompt',super._();
  factory WritingPromptExercise.fromJson(Map<String, dynamic> json) => _$WritingPromptExerciseFromJson(json);

@override final  String id;
@override final  String question;
 final  String exampleAnswer;
@override final  String? explanation;
@override final  String? pronunciationBn;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingPromptExerciseCopyWith<WritingPromptExercise> get copyWith => _$WritingPromptExerciseCopyWithImpl<WritingPromptExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingPromptExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingPromptExercise&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.exampleAnswer, exampleAnswer) || other.exampleAnswer == exampleAnswer)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,exampleAnswer,explanation,pronunciationBn);

@override
String toString() {
  return 'Exercise.writingPrompt(id: $id, question: $question, exampleAnswer: $exampleAnswer, explanation: $explanation, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $WritingPromptExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory $WritingPromptExerciseCopyWith(WritingPromptExercise value, $Res Function(WritingPromptExercise) _then) = _$WritingPromptExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String question, String exampleAnswer, String? explanation, String? pronunciationBn
});




}
/// @nodoc
class _$WritingPromptExerciseCopyWithImpl<$Res>
    implements $WritingPromptExerciseCopyWith<$Res> {
  _$WritingPromptExerciseCopyWithImpl(this._self, this._then);

  final WritingPromptExercise _self;
  final $Res Function(WritingPromptExercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? exampleAnswer = null,Object? explanation = freezed,Object? pronunciationBn = freezed,}) {
  return _then(WritingPromptExercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,exampleAnswer: null == exampleAnswer ? _self.exampleAnswer : exampleAnswer // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
