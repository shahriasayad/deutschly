// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialogue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialogueLine {

 String get speaker; String get text;
/// Create a copy of DialogueLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogueLineCopyWith<DialogueLine> get copyWith => _$DialogueLineCopyWithImpl<DialogueLine>(this as DialogueLine, _$identity);

  /// Serializes this DialogueLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogueLine&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speaker,text);

@override
String toString() {
  return 'DialogueLine(speaker: $speaker, text: $text)';
}


}

/// @nodoc
abstract mixin class $DialogueLineCopyWith<$Res>  {
  factory $DialogueLineCopyWith(DialogueLine value, $Res Function(DialogueLine) _then) = _$DialogueLineCopyWithImpl;
@useResult
$Res call({
 String speaker, String text
});




}
/// @nodoc
class _$DialogueLineCopyWithImpl<$Res>
    implements $DialogueLineCopyWith<$Res> {
  _$DialogueLineCopyWithImpl(this._self, this._then);

  final DialogueLine _self;
  final $Res Function(DialogueLine) _then;

/// Create a copy of DialogueLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speaker = null,Object? text = null,}) {
  return _then(_self.copyWith(
speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DialogueLine].
extension DialogueLinePatterns on DialogueLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialogueLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialogueLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialogueLine value)  $default,){
final _that = this;
switch (_that) {
case _DialogueLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialogueLine value)?  $default,){
final _that = this;
switch (_that) {
case _DialogueLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String speaker,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialogueLine() when $default != null:
return $default(_that.speaker,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String speaker,  String text)  $default,) {final _that = this;
switch (_that) {
case _DialogueLine():
return $default(_that.speaker,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String speaker,  String text)?  $default,) {final _that = this;
switch (_that) {
case _DialogueLine() when $default != null:
return $default(_that.speaker,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DialogueLine implements DialogueLine {
  const _DialogueLine({required this.speaker, required this.text});
  factory _DialogueLine.fromJson(Map<String, dynamic> json) => _$DialogueLineFromJson(json);

@override final  String speaker;
@override final  String text;

/// Create a copy of DialogueLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogueLineCopyWith<_DialogueLine> get copyWith => __$DialogueLineCopyWithImpl<_DialogueLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogueLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialogueLine&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speaker,text);

@override
String toString() {
  return 'DialogueLine(speaker: $speaker, text: $text)';
}


}

/// @nodoc
abstract mixin class _$DialogueLineCopyWith<$Res> implements $DialogueLineCopyWith<$Res> {
  factory _$DialogueLineCopyWith(_DialogueLine value, $Res Function(_DialogueLine) _then) = __$DialogueLineCopyWithImpl;
@override @useResult
$Res call({
 String speaker, String text
});




}
/// @nodoc
class __$DialogueLineCopyWithImpl<$Res>
    implements _$DialogueLineCopyWith<$Res> {
  __$DialogueLineCopyWithImpl(this._self, this._then);

  final _DialogueLine _self;
  final $Res Function(_DialogueLine) _then;

/// Create a copy of DialogueLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speaker = null,Object? text = null,}) {
  return _then(_DialogueLine(
speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Dialogue {

 String get id; String get title; List<DialogueLine> get lines;
/// Create a copy of Dialogue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialogueCopyWith<Dialogue> get copyWith => _$DialogueCopyWithImpl<Dialogue>(this as Dialogue, _$identity);

  /// Serializes this Dialogue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dialogue&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'Dialogue(id: $id, title: $title, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $DialogueCopyWith<$Res>  {
  factory $DialogueCopyWith(Dialogue value, $Res Function(Dialogue) _then) = _$DialogueCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<DialogueLine> lines
});




}
/// @nodoc
class _$DialogueCopyWithImpl<$Res>
    implements $DialogueCopyWith<$Res> {
  _$DialogueCopyWithImpl(this._self, this._then);

  final Dialogue _self;
  final $Res Function(Dialogue) _then;

/// Create a copy of Dialogue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? lines = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<DialogueLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [Dialogue].
extension DialoguePatterns on Dialogue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dialogue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dialogue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dialogue value)  $default,){
final _that = this;
switch (_that) {
case _Dialogue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dialogue value)?  $default,){
final _that = this;
switch (_that) {
case _Dialogue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<DialogueLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dialogue() when $default != null:
return $default(_that.id,_that.title,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<DialogueLine> lines)  $default,) {final _that = this;
switch (_that) {
case _Dialogue():
return $default(_that.id,_that.title,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<DialogueLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _Dialogue() when $default != null:
return $default(_that.id,_that.title,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dialogue implements Dialogue {
  const _Dialogue({required this.id, required this.title, final  List<DialogueLine> lines = const <DialogueLine>[]}): _lines = lines;
  factory _Dialogue.fromJson(Map<String, dynamic> json) => _$DialogueFromJson(json);

@override final  String id;
@override final  String title;
 final  List<DialogueLine> _lines;
@override@JsonKey() List<DialogueLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of Dialogue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialogueCopyWith<_Dialogue> get copyWith => __$DialogueCopyWithImpl<_Dialogue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialogueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dialogue&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'Dialogue(id: $id, title: $title, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$DialogueCopyWith<$Res> implements $DialogueCopyWith<$Res> {
  factory _$DialogueCopyWith(_Dialogue value, $Res Function(_Dialogue) _then) = __$DialogueCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<DialogueLine> lines
});




}
/// @nodoc
class __$DialogueCopyWithImpl<$Res>
    implements _$DialogueCopyWith<$Res> {
  __$DialogueCopyWithImpl(this._self, this._then);

  final _Dialogue _self;
  final $Res Function(_Dialogue) _then;

/// Create a copy of Dialogue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? lines = null,}) {
  return _then(_Dialogue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<DialogueLine>,
  ));
}


}

// dart format on
