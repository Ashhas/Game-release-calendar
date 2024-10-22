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
  Set<PlatformFilterChoice> get platformChoices =>
      throw _privateConstructorUsedError;
  DateFilterChoice? get releaseDateChoice => throw _privateConstructorUsedError;
  DateTimeRange? get releaseDateRange => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      {Set<PlatformFilterChoice> platformChoices,
      DateFilterChoice? releaseDateChoice,
      DateTimeRange? releaseDateRange});
}

/// @nodoc
class _$GameFilterCopyWithImpl<$Res, $Val extends GameFilter>
    implements $GameFilterCopyWith<$Res> {
  _$GameFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformChoices = null,
    Object? releaseDateChoice = freezed,
    Object? releaseDateRange = freezed,
  }) {
    return _then(_value.copyWith(
      platformChoices: null == platformChoices
          ? _value.platformChoices
          : platformChoices // ignore: cast_nullable_to_non_nullable
              as Set<PlatformFilterChoice>,
      releaseDateChoice: freezed == releaseDateChoice
          ? _value.releaseDateChoice
          : releaseDateChoice // ignore: cast_nullable_to_non_nullable
              as DateFilterChoice?,
      releaseDateRange: freezed == releaseDateRange
          ? _value.releaseDateRange
          : releaseDateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
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
      {Set<PlatformFilterChoice> platformChoices,
      DateFilterChoice? releaseDateChoice,
      DateTimeRange? releaseDateRange});
}

/// @nodoc
class __$$GameFilterImplCopyWithImpl<$Res>
    extends _$GameFilterCopyWithImpl<$Res, _$GameFilterImpl>
    implements _$$GameFilterImplCopyWith<$Res> {
  __$$GameFilterImplCopyWithImpl(
      _$GameFilterImpl _value, $Res Function(_$GameFilterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platformChoices = null,
    Object? releaseDateChoice = freezed,
    Object? releaseDateRange = freezed,
  }) {
    return _then(_$GameFilterImpl(
      platformChoices: null == platformChoices
          ? _value._platformChoices
          : platformChoices // ignore: cast_nullable_to_non_nullable
              as Set<PlatformFilterChoice>,
      releaseDateChoice: freezed == releaseDateChoice
          ? _value.releaseDateChoice
          : releaseDateChoice // ignore: cast_nullable_to_non_nullable
              as DateFilterChoice?,
      releaseDateRange: freezed == releaseDateRange
          ? _value.releaseDateRange
          : releaseDateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange?,
    ));
  }
}

/// @nodoc

class _$GameFilterImpl implements _GameFilter {
  const _$GameFilterImpl(
      {required final Set<PlatformFilterChoice> platformChoices,
      this.releaseDateChoice,
      this.releaseDateRange})
      : _platformChoices = platformChoices;

  final Set<PlatformFilterChoice> _platformChoices;
  @override
  Set<PlatformFilterChoice> get platformChoices {
    if (_platformChoices is EqualUnmodifiableSetView) return _platformChoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_platformChoices);
  }

  @override
  final DateFilterChoice? releaseDateChoice;
  @override
  final DateTimeRange? releaseDateRange;

  @override
  String toString() {
    return 'GameFilter(platformChoices: $platformChoices, releaseDateChoice: $releaseDateChoice, releaseDateRange: $releaseDateRange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._platformChoices, _platformChoices) &&
            (identical(other.releaseDateChoice, releaseDateChoice) ||
                other.releaseDateChoice == releaseDateChoice) &&
            (identical(other.releaseDateRange, releaseDateRange) ||
                other.releaseDateRange == releaseDateRange));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_platformChoices),
      releaseDateChoice,
      releaseDateRange);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameFilterImplCopyWith<_$GameFilterImpl> get copyWith =>
      __$$GameFilterImplCopyWithImpl<_$GameFilterImpl>(this, _$identity);
}

abstract class _GameFilter implements GameFilter {
  const factory _GameFilter(
      {required final Set<PlatformFilterChoice> platformChoices,
      final DateFilterChoice? releaseDateChoice,
      final DateTimeRange? releaseDateRange}) = _$GameFilterImpl;

  @override
  Set<PlatformFilterChoice> get platformChoices;
  @override
  DateFilterChoice? get releaseDateChoice;
  @override
  DateTimeRange? get releaseDateRange;
  @override
  @JsonKey(ignore: true)
  _$$GameFilterImplCopyWith<_$GameFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
