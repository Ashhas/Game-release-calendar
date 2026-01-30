import 'package:game_release_calendar/src/domain/enums/date_precision.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

/// Represents a section of games in the upcoming games list.
/// Groups games by date and precision level (exact day vs TBD periods).
class GameSection {
  /// The reference date for this section.
  /// For exact dates: the actual release date.
  /// For TBD sections: the start of the period (1st of month, 1st of quarter, Jan 1 for year).
  final DateTime date;

  /// The precision level of this section.
  final DatePrecision precision;

  /// The games in this section.
  final List<Game> games;

  const GameSection({
    required this.date,
    required this.precision,
    required this.games,
  });

  /// Unique key for this section combining date and precision.
  String get key => '${date.millisecondsSinceEpoch}_${precision.name}';

  /// Whether this is a TBD section (month/quarter/year).
  bool get isTbd => precision.isTbd;

  /// Format the section header text.
  String get headerText {
    switch (precision) {
      case DatePrecision.exactDay:
        // Will be formatted by the UI using DateFormat
        return '';
      case DatePrecision.month:
        return '${_monthName(date.month)} ${date.year} (TBD)';
      case DatePrecision.quarter:
        final quarter = ((date.month - 1) ~/ 3) + 1;
        return 'Q$quarter ${date.year} (TBD)';
      case DatePrecision.year:
        return '${date.year} (TBD)';
      case DatePrecision.tbd:
        return 'TBD';
    }
  }

  static String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  /// Create a sort key for ordering sections.
  /// TBD sections appear before their respective day sections.
  int get sortKey {
    // Base: year * 10000 + month * 100 + day
    // Add precision offset to put TBD before exact dates
    final baseKey = date.year * 1000000 + date.month * 10000 + date.day * 100;
    return baseKey + precision.sortOrder;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameSection &&
        other.date == date &&
        other.precision == precision;
  }

  @override
  int get hashCode => date.hashCode ^ precision.hashCode;
}
