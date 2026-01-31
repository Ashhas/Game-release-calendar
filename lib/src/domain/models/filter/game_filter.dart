import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';
import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';

part 'game_filter.freezed.dart';

@freezed
abstract class GameFilter with _$GameFilter {
  const factory GameFilter({
    required Set<PlatformFilter> platformChoices,
    required Set<int> categoryIds,
    DateFilterChoice? releaseDateChoice,
    ReleasePrecisionFilter? releasePrecisionChoice,
    @Default(false) bool showEroticContent,
  }) = _GameFilter;
}
