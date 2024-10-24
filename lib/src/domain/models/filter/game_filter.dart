import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';

part 'game_filter.freezed.dart';

@freezed
class GameFilter with _$GameFilter {
  const factory GameFilter({
    required Set<PlatformFilter> platformChoices,
    DateFilterChoice? releaseDateChoice,
    DateTimeRange? releaseDateRange,
  }) = _GameFilter;
}
