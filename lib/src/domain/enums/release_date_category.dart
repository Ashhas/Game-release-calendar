import 'package:hive/hive.dart';

part 'release_date_category.g.dart';

@HiveType(typeId: 4)
enum ReleaseDateCategory {
  @HiveField(0)
  exactDate(0, 'Exact Date (YYYY-MM-DD)'),
  @HiveField(1)
  yearMonth(1, 'Year and Month (YYYY-MM)'),
  @HiveField(2)
  quarter(2, 'Quarter (Q1, Q2, etc.)'),
  @HiveField(3)
  year(3, 'Year (YYYY)'),
  @HiveField(4)
  tbd(4, 'To Be Determined (TBD)');

  final int value;
  final String description;

  const ReleaseDateCategory(this.value, this.description);

  static ReleaseDateCategory fromValue(int value) {
    return ReleaseDateCategory.values.firstWhere((e) => e.value == value,
        orElse: () => ReleaseDateCategory.tbd);
  }

  int toValue() {
    return value;
  }

  @override
  String toString() {
    return '''ReleaseDateCategory(
    id: $value,
    type: $name
    description: $description
  )''';
  }

}
