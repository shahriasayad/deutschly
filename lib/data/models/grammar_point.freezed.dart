// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrammarPoint {

 String get title; String get explanation; List<String> get examples; Map<String, List<String>>? get table;
/// Create a copy of GrammarPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarPointCopyWith<GrammarPoint> get copyWith => _$GrammarPointCopyWithImpl<GrammarPoint>(this as GrammarPoint, _$identity);

  /// Serializes this GrammarPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarPoint&&(identical(other.title, title) || other.title == title)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&const DeepCollectionEquality().equals(other.examples, examples)&&const DeepCollectionEquality().equals(other.table, table));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,explanation,const DeepCollectionEquality().hash(examples),const DeepCollectionEquality().hash(table));

@override
String toString() {
  return 'GrammarPoint(title: $title, explanation: $explanation, examples: $examples, table: $table)';
}


}

/// @nodoc
abstract mixin class $GrammarPointCopyWith<$Res>  {
  factory $GrammarPointCopyWith(GrammarPoint value, $Res Function(GrammarPoint) _then) = _$GrammarPointCopyWithImpl;
@useResult
$Res call({
 String title, String explanation, List<String> examples, Map<String, List<String>>? table
});




}
/// @nodoc
class _$GrammarPointCopyWithImpl<$Res>
    implements $GrammarPointCopyWith<$Res> {
  _$GrammarPointCopyWithImpl(this._self, this._then);

  final GrammarPoint _self;
  final $Res Function(GrammarPoint) _then;

/// Create a copy of GrammarPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? explanation = null,Object? examples = null,Object? table = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<String>,table: freezed == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarPoint].
extension GrammarPointPatterns on GrammarPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarPoint value)  $default,){
final _that = this;
switch (_that) {
case _GrammarPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarPoint value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String explanation,  List<String> examples,  Map<String, List<String>>? table)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarPoint() when $default != null:
return $default(_that.title,_that.explanation,_that.examples,_that.table);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String explanation,  List<String> examples,  Map<String, List<String>>? table)  $default,) {final _that = this;
switch (_that) {
case _GrammarPoint():
return $default(_that.title,_that.explanation,_that.examples,_that.table);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String explanation,  List<String> examples,  Map<String, List<String>>? table)?  $default,) {final _that = this;
switch (_that) {
case _GrammarPoint() when $default != null:
return $default(_that.title,_that.explanation,_that.examples,_that.table);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarPoint implements GrammarPoint {
  const _GrammarPoint({required this.title, required this.explanation, final  List<String> examples = const <String>[], final  Map<String, List<String>>? table}): _examples = examples,_table = table;
  factory _GrammarPoint.fromJson(Map<String, dynamic> json) => _$GrammarPointFromJson(json);

@override final  String title;
@override final  String explanation;
 final  List<String> _examples;
@override@JsonKey() List<String> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}

 final  Map<String, List<String>>? _table;
@override Map<String, List<String>>? get table {
  final value = _table;
  if (value == null) return null;
  if (_table is EqualUnmodifiableMapView) return _table;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of GrammarPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarPointCopyWith<_GrammarPoint> get copyWith => __$GrammarPointCopyWithImpl<_GrammarPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarPoint&&(identical(other.title, title) || other.title == title)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&const DeepCollectionEquality().equals(other._examples, _examples)&&const DeepCollectionEquality().equals(other._table, _table));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,explanation,const DeepCollectionEquality().hash(_examples),const DeepCollectionEquality().hash(_table));

@override
String toString() {
  return 'GrammarPoint(title: $title, explanation: $explanation, examples: $examples, table: $table)';
}


}

/// @nodoc
abstract mixin class _$GrammarPointCopyWith<$Res> implements $GrammarPointCopyWith<$Res> {
  factory _$GrammarPointCopyWith(_GrammarPoint value, $Res Function(_GrammarPoint) _then) = __$GrammarPointCopyWithImpl;
@override @useResult
$Res call({
 String title, String explanation, List<String> examples, Map<String, List<String>>? table
});




}
/// @nodoc
class __$GrammarPointCopyWithImpl<$Res>
    implements _$GrammarPointCopyWith<$Res> {
  __$GrammarPointCopyWithImpl(this._self, this._then);

  final _GrammarPoint _self;
  final $Res Function(_GrammarPoint) _then;

/// Create a copy of GrammarPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? explanation = null,Object? examples = null,Object? table = freezed,}) {
  return _then(_GrammarPoint(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<String>,table: freezed == table ? _self._table : table // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>?,
  ));
}


}

// dart format on
