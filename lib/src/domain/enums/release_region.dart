import 'package:hive/hive.dart';

part 'release_region.g.dart';

@HiveType(typeId: 9)
enum ReleaseRegion {
  @HiveField(0)
  europe(1, 'Europe'),
  @HiveField(1)
  northAmerica(2, 'North America'),
  @HiveField(2)
  australia(3, 'Australia'),
  @HiveField(3)
  newZealand(4, 'New Zealand'),
  @HiveField(4)
  japan(5, 'Japan'),
  @HiveField(5)
  china(6, 'China'),
  @HiveField(6)
  asia(7, 'Asia'),
  @HiveField(7)
  worldwide(8, 'Worldwide'),
  @HiveField(8)
  korea(9, 'Korea'),
  @HiveField(9)
  brazil(10, 'Brazil'),
  @HiveField(10)
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