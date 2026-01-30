// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameFilter {

 Set<PlatformFilter> get platformChoices; Set<int> get categoryIds; DateFilterChoice? get releaseDateChoice; ReleasePrecisionFilter? get releasePrecisionChoice;
/// Create a copy of GameFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameFilterCopyWith<GameFilter> get copyWith => _$GameFilterCopyWithImpl<GameFilter>(this as GameFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameFilter&&const DeepCollectionEquality().equals(other.platformChoices, platformChoices)&&const DeepCollectionEquality().equals(other.categoryIds, categoryIds)&&(identical(other.releaseDateChoice, releaseDateChoice) || other.releaseDateChoice == releaseDateChoice)&&(identical(other.releasePrecisionChoice, releasePrecisionChoice) || other.releasePrecisionChoice == releasePrecisionChoice));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(platformChoices),const DeepCollectionEquality().hash(categoryIds),releaseDateChoice,releasePrecisionChoice);

@override
String toString() {
  return 'GameFilter(platformChoices: $platformChoices, categoryIds: $categoryIds, releaseDateChoice: $releaseDateChoice, releasePrecisionChoice: $releasePrecisionChoice)';
}


}

/// @nodoc
abstract mixin class $GameFilterCopyWith<$Res>  {
  factory $GameFilterCopyWith(GameFilter value, $Res Function(GameFilter) _then) = _$GameFilterCopyWithImpl;
@useResult
$Res call({
 Set<PlatformFilter> platformChoices, Set<int> categoryIds, DateFilterChoice? releaseDateChoice, ReleasePrecisionFilter? releasePrecisionChoice
});




}
/// @nodoc
class _$GameFilterCopyWithImpl<$Res>
    implements $GameFilterCopyWith<$Res> {
  _$GameFilterCopyWithImpl(this._self, this._then);

  final GameFilter _self;
  final $Res Function(GameFilter) _then;

/// Create a copy of GameFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platformChoices = null,Object? categoryIds = null,Object? releaseDateChoice = freezed,Object? releasePrecisionChoice = freezed,}) {
  return _then(_self.copyWith(
platformChoices: null == platformChoices ? _self.platformChoices : platformChoices // ignore: cast_nullable_to_non_nullable
as Set<PlatformFilter>,categoryIds: null == categoryIds ? _self.categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as Set<int>,releaseDateChoice: freezed == releaseDateChoice ? _self.releaseDateChoice : releaseDateChoice // ignore: cast_nullable_to_non_nullable
as DateFilterChoice?,releasePrecisionChoice: freezed == releasePrecisionChoice ? _self.releasePrecisionChoice : releasePrecisionChoice // ignore: cast_nullable_to_non_nullable
as ReleasePrecisionFilter?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameFilter].
extension GameFilterPatterns on GameFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameFilter value)  $default,){
final _that = this;
switch (_that) {
case _GameFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameFilter value)?  $default,){
final _that = this;
switch (_that) {
case _GameFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<PlatformFilter> platformChoices,  Set<int> categoryIds,  DateFilterChoice? releaseDateChoice,  ReleasePrecisionFilter? releasePrecisionChoice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameFilter() when $default != null:
return $default(_that.platformChoices,_that.categoryIds,_that.releaseDateChoice,_that.releasePrecisionChoice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<PlatformFilter> platformChoices,  Set<int> categoryIds,  DateFilterChoice? releaseDateChoice,  ReleasePrecisionFilter? releasePrecisionChoice)  $default,) {final _that = this;
switch (_that) {
case _GameFilter():
return $default(_that.platformChoices,_that.categoryIds,_that.releaseDateChoice,_that.releasePrecisionChoice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<PlatformFilter> platformChoices,  Set<int> categoryIds,  DateFilterChoice? releaseDateChoice,  ReleasePrecisionFilter? releasePrecisionChoice)?  $default,) {final _that = this;
switch (_that) {
case _GameFilter() when $default != null:
return $default(_that.platformChoices,_that.categoryIds,_that.releaseDateChoice,_that.releasePrecisionChoice);case _:
  return null;

}
}

}

/// @nodoc


class _GameFilter implements GameFilter {
  const _GameFilter({required final  Set<PlatformFilter> platformChoices, required final  Set<int> categoryIds, this.releaseDateChoice, this.releasePrecisionChoice}): _platformChoices = platformChoices,_categoryIds = categoryIds;
  

 final  Set<PlatformFilter> _platformChoices;
@override Set<PlatformFilter> get platformChoices {
  if (_platformChoices is EqualUnmodifiableSetView) return _platformChoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_platformChoices);
}

 final  Set<int> _categoryIds;
@override Set<int> get categoryIds {
  if (_categoryIds is EqualUnmodifiableSetView) return _categoryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_categoryIds);
}

@override final  DateFilterChoice? releaseDateChoice;
@override final  ReleasePrecisionFilter? releasePrecisionChoice;

/// Create a copy of GameFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameFilterCopyWith<_GameFilter> get copyWith => __$GameFilterCopyWithImpl<_GameFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameFilter&&const DeepCollectionEquality().equals(other._platformChoices, _platformChoices)&&const DeepCollectionEquality().equals(other._categoryIds, _categoryIds)&&(identical(other.releaseDateChoice, releaseDateChoice) || other.releaseDateChoice == releaseDateChoice)&&(identical(other.releasePrecisionChoice, releasePrecisionChoice) || other.releasePrecisionChoice == releasePrecisionChoice));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_platformChoices),const DeepCollectionEquality().hash(_categoryIds),releaseDateChoice,releasePrecisionChoice);

@override
String toString() {
  return 'GameFilter(platformChoices: $platformChoices, categoryIds: $categoryIds, releaseDateChoice: $releaseDateChoice, releasePrecisionChoice: $releasePrecisionChoice)';
}


}

/// @nodoc
abstract mixin class _$GameFilterCopyWith<$Res> implements $GameFilterCopyWith<$Res> {
  factory _$GameFilterCopyWith(_GameFilter value, $Res Function(_GameFilter) _then) = __$GameFilterCopyWithImpl;
@override @useResult
$Res call({
 Set<PlatformFilter> platformChoices, Set<int> categoryIds, DateFilterChoice? releaseDateChoice, ReleasePrecisionFilter? releasePrecisionChoice
});




}
/// @nodoc
class __$GameFilterCopyWithImpl<$Res>
    implements _$GameFilterCopyWith<$Res> {
  __$GameFilterCopyWithImpl(this._self, this._then);

  final _GameFilter _self;
  final $Res Function(_GameFilter) _then;

/// Create a copy of GameFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platformChoices = null,Object? categoryIds = null,Object? releaseDateChoice = freezed,Object? releasePrecisionChoice = freezed,}) {
  return _then(_GameFilter(
platformChoices: null == platformChoices ? _self._platformChoices : platformChoices // ignore: cast_nullable_to_non_nullable
as Set<PlatformFilter>,categoryIds: null == categoryIds ? _self._categoryIds : categoryIds // ignore: cast_nullable_to_non_nullable
as Set<int>,releaseDateChoice: freezed == releaseDateChoice ? _self.releaseDateChoice : releaseDateChoice // ignore: cast_nullable_to_non_nullable
as DateFilterChoice?,releasePrecisionChoice: freezed == releasePrecisionChoice ? _self.releasePrecisionChoice : releasePrecisionChoice // ignore: cast_nullable_to_non_nullable
as ReleasePrecisionFilter?,
  ));
}


}

// dart format on
