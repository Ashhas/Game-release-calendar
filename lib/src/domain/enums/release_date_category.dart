enum ReleaseDateCategory {
  exactDate(0, 'Exact Date (YYYY-MM-DD)'),
  yearMonth(1, 'Year and Month (YYYY-MM)'),
  quarter(2, 'Quarter (Q1, Q2, etc.)'),
  year(3, 'Year (YYYY)'),
  tbd(4, 'To Be Determined (TBD)');

  final int value;
  final String description;

  const ReleaseDateCategory(this.value, this.description);

  static ReleaseDateCategory fromValue(int value) {
    return ReleaseDateCategory.values
        .firstWhere((e) => e.value == value, orElse: () => ReleaseDateCategory.tbd);
  }

  int toValue() {
    return value;
  }
}
