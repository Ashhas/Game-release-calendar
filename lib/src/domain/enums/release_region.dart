enum ReleaseRegion {
  europe(1, 'Europe'),
  northAmerica(2, 'North America'),
  australia(3, 'Australia'),
  newZealand(4, 'New Zealand'),
  japan(5, 'Japan'),
  china(6, 'China'),
  asia(7, 'Asia'),
  worldwide(8, 'Worldwide'),
  korea(9, 'Korea'),
  brazil(10, 'Brazil'),
  unknown(99, 'Unknown');

  const ReleaseRegion(this.id, this.name);

  final int id;
  final String name;

  static ReleaseRegion? fromValue(int? value) {
    if (value == null) return null;
    
    for (ReleaseRegion region in ReleaseRegion.values) {
      if (region.id == value) {
        return region;
      }
    }
    return ReleaseRegion.unknown;
  }

  int toValue() => id;
}