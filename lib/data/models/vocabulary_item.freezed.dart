// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VocabularyItem {

 String get de; String get en; String get bn; String? get pronunciationBn;
/// Create a copy of VocabularyItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyItemCopyWith<VocabularyItem> get copyWith => _$VocabularyItemCopyWithImpl<VocabularyItem>(this as VocabularyItem, _$identity);

  /// Serializes this VocabularyItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyItem&&(identical(other.de, de) || other.de == de)&&(identical(other.en, en) || other.en == en)&&(identical(other.bn, bn) || other.bn == bn)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,de,en,bn,pronunciationBn);

@override
String toString() {
  return 'VocabularyItem(de: $de, en: $en, bn: $bn, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class $VocabularyItemCopyWith<$Res>  {
  factory $VocabularyItemCopyWith(VocabularyItem value, $Res Function(VocabularyItem) _then) = _$VocabularyItemCopyWithImpl;
@useResult
$Res call({
 String de, String en, String bn, String? pronunciationBn
});




}
/// @nodoc
class _$VocabularyItemCopyWithImpl<$Res>
    implements $VocabularyItemCopyWith<$Res> {
  _$VocabularyItemCopyWithImpl(this._self, this._then);

  final VocabularyItem _self;
  final $Res Function(VocabularyItem) _then;

/// Create a copy of VocabularyItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? de = null,Object? en = null,Object? bn = null,Object? pronunciationBn = freezed,}) {
  return _then(_self.copyWith(
de: null == de ? _self.de : de // ignore: cast_nullable_to_non_nullable
as String,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,bn: null == bn ? _self.bn : bn // ignore: cast_nullable_to_non_nullable
as String,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularyItem].
extension VocabularyItemPatterns on VocabularyItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularyItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularyItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularyItem value)  $default,){
final _that = this;
switch (_that) {
case _VocabularyItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularyItem value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularyItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String de,  String en,  String bn,  String? pronunciationBn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyItem() when $default != null:
return $default(_that.de,_that.en,_that.bn,_that.pronunciationBn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String de,  String en,  String bn,  String? pronunciationBn)  $default,) {final _that = this;
switch (_that) {
case _VocabularyItem():
return $default(_that.de,_that.en,_that.bn,_that.pronunciationBn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String de,  String en,  String bn,  String? pronunciationBn)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyItem() when $default != null:
return $default(_that.de,_that.en,_that.bn,_that.pronunciationBn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabularyItem implements VocabularyItem {
  const _VocabularyItem({required this.de, required this.en, required this.bn, this.pronunciationBn});
  factory _VocabularyItem.fromJson(Map<String, dynamic> json) => _$VocabularyItemFromJson(json);

@override final  String de;
@override final  String en;
@override final  String bn;
@override final  String? pronunciationBn;

/// Create a copy of VocabularyItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyItemCopyWith<_VocabularyItem> get copyWith => __$VocabularyItemCopyWithImpl<_VocabularyItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabularyItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyItem&&(identical(other.de, de) || other.de == de)&&(identical(other.en, en) || other.en == en)&&(identical(other.bn, bn) || other.bn == bn)&&(identical(other.pronunciationBn, pronunciationBn) || other.pronunciationBn == pronunciationBn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,de,en,bn,pronunciationBn);

@override
String toString() {
  return 'VocabularyItem(de: $de, en: $en, bn: $bn, pronunciationBn: $pronunciationBn)';
}


}

/// @nodoc
abstract mixin class _$VocabularyItemCopyWith<$Res> implements $VocabularyItemCopyWith<$Res> {
  factory _$VocabularyItemCopyWith(_VocabularyItem value, $Res Function(_VocabularyItem) _then) = __$VocabularyItemCopyWithImpl;
@override @useResult
$Res call({
 String de, String en, String bn, String? pronunciationBn
});




}
/// @nodoc
class __$VocabularyItemCopyWithImpl<$Res>
    implements _$VocabularyItemCopyWith<$Res> {
  __$VocabularyItemCopyWithImpl(this._self, this._then);

  final _VocabularyItem _self;
  final $Res Function(_VocabularyItem) _then;

/// Create a copy of VocabularyItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? de = null,Object? en = null,Object? bn = null,Object? pronunciationBn = freezed,}) {
  return _then(_VocabularyItem(
de: null == de ? _self.de : de // ignore: cast_nullable_to_non_nullable
as String,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,bn: null == bn ? _self.bn : bn // ignore: cast_nullable_to_non_nullable
as String,pronunciationBn: freezed == pronunciationBn ? _self.pronunciationBn : pronunciationBn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
