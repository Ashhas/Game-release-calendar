import 'package:intl/intl.dart';

class ConvertFunctions {
  static String secondSinceEpochToDateTime(int value) {
    return DateFormat('dd-MM-yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(
        value * 1000,
      ),
    );
  }
}
