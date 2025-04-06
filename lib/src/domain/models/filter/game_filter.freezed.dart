// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameFilter {
  Set<PlatformFilter> get platformChoices => throw _privateConstructorUsedError;
  DateFilterChoice? get releaseDateChoice => throw _privateConstructorUsedError;

  /// Create a copy of GameFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameFilterCopyWith<GameFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameFilterCopyWith<$Res> {
  factory $GameFilterCopyWith(
          GameFilter value, $Res Function(GameFilter) then) =
      _$GameFilterCopyWithImpl<$Res, GameFilter>;
  @useResult
  $Res call(
      {Set<PlatformFilter> platformChoices,
      DateFilterChoice? releaseDateChoice});
}

/// @nodoc
class _$GameFilterCopyWithImpl<$Res, $Val extends GameFilter>
    implements $GameFilterCopyWith<$Res> {
  _$GameFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformChoices = null,
    Object? releaseDateChoice = freezed,
  }) {
    return _then(_value.copyWith(
      platformChoices: null == platformChoices
          ? _value.platformChoices
          : platformChoices // ignore: cast_nullable_to_non_nullable
              as Set<PlatformFilter>,
      releaseDateChoice: freezed == releaseDateChoice
          ? _value.releaseDateChoice
          : releaseDateChoice // ignore: cast_nullable_to_non_nullable
              as DateFilterChoice?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameFilterImplCopyWith<$Res>
    implements $GameFilterCopyWith<$Res> {
  factory _$$GameFilterImplCopyWith(
          _$GameFilterImpl value, $Res Function(_$GameFilterImpl) then) =
      __$$GameFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<PlatformFilter> platformChoices,
      DateFilterChoice? releaseDateChoice});
}

/// @nodoc
class __$$GameFilterImplCopyWithImpl<$Res>
    extends _$GameFilterCopyWithImpl<$Res, _$GameFilterImpl>
    implements _$$GameFilterImplCopyWith<$Res> {
  __$$GameFilterImplCopyWithImpl(
      _$GameFilterImpl _value, $Res Function(_$GameFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformChoices = null,
    Object? releaseDateChoice = freezed,
  }) {
    return _then(_$GameFilterImpl(
      platformChoices: null == platformChoices
          ? _value._platformChoices
          : platformChoices // ignore: cast_nullable_to_non_nullable
              as Set<PlatformFilter>,
      releaseDateChoice: freezed == releaseDateChoice
          ? _value.releaseDateChoice
          : releaseDateChoice // ignore: cast_nullable_to_non_nullable
              as DateFilterChoice?,
    ));
  }
}

/// @nodoc

class _$GameFilterImpl implements _GameFilter {
  const _$GameFilterImpl(
      {required final Set<PlatformFilter> platformChoices,
      this.releaseDateChoice})
      : _platformChoices = platformChoices;

  final Set<PlatformFilter> _platformChoices;
  @override
  Set<PlatformFilter> get platformChoices {
    if (_platformChoices is EqualUnmodifiableSetView) return _platformChoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_platformChoices);
  }

  @override
  final DateFilterChoice? releaseDateChoice;

  @override
  String toString() {
    return 'GameFilter(platformChoices: $platformChoices, releaseDateChoice: $releaseDateChoice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._platformChoices, _platformChoices) &&
            (identical(other.releaseDateChoice, releaseDateChoice) ||
                other.releaseDateChoice == releaseDateChoice));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_platformChoices), releaseDateChoice);

  /// Create a copy of GameFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameFilterImplCopyWith<_$GameFilterImpl> get copyWith =>
      __$$GameFilterImplCopyWithImpl<_$GameFilterImpl>(this, _$identity);
}

abstract class _GameFilter implements GameFilter {
  const factory _GameFilter(
      {required final Set<PlatformFilter> platformChoices,
      final DateFilterChoice? releaseDateChoice}) = _$GameFilterImpl;

  @override
  Set<PlatformFilter> get platformChoices;
  @override
  DateFilterChoice? get releaseDateChoice;

  /// Create a copy of GameFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameFilterImplCopyWith<_$GameFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
