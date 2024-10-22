import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:game_release_calendar/src/domain/enums/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/platform_filter_choice.dart';

part 'game_filter.freezed.dart';

@freezed
class GameFilter with _$GameFilter {
  const factory GameFilter({
    PlatformFilterChoice? platformChoice,
    DateFilterChoice? releaseDateChoice,
    DateTimeRange? releaseDateRange,
  }) = _GameFilter;
}
