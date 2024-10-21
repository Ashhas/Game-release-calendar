import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/enums/date_filter_choice.dart';

class GameFilter {
  String? platform;
  DateFilterChoice? releaseDateChoice;
  DateTimeRange? releaseDateRange;

  GameFilter({
    this.platform,
    this.releaseDateChoice,
    this.releaseDateRange,
  });

  GameFilter copyWith({
    String? platform,
    DateFilterChoice? releaseDateChoice,
    DateTimeRange? releaseDateRange,
  }) {
    return GameFilter(
      platform: platform,
      releaseDateChoice: releaseDateChoice,
      releaseDateRange: releaseDateRange,
    );
  }
}
