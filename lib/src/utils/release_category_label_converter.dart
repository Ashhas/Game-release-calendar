import 'package:intl/intl.dart';

import '../domain/enums/release_date_category.dart';
import '../domain/models/release_date.dart';
import 'date_time_converter.dart';

class ReleaseCategoryLabelConverter {
  static String convertDate(ReleaseDate releaseDate) {
    final convertedDate = DateTimeConverter.secondSinceEpochToDateTime(
      releaseDate.date!,
    );

    switch (releaseDate.category) {
      case ReleaseDateCategory.exactDate:
        return DateFormat('dd-MM-yyyy').format(convertedDate);
      case ReleaseDateCategory.yearMonth:
        return DateFormat('MMM yyyy').format(convertedDate);
      case ReleaseDateCategory.quarter:
        final quarter = _formatToQuarter(convertedDate);
        final year = DateFormat('yyyy').format(convertedDate);
        return 'Q$quarter $year';
      case ReleaseDateCategory.year:
        return DateFormat('yyyy').format(convertedDate);
      case ReleaseDateCategory.tbd:
        return 'TBD';
      case null:
        throw UnimplementedError();
    }
  }

  static int _formatToQuarter(DateTime date) {
    final quarter = ((date.month - 1) ~/ 3) + 1;
    return quarter;
  }
}
