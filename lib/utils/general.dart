import 'package:intl/intl.dart';

class General {
  static String dateFormat(DateTime date, {String format = 'yyyy-MM-dd'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }
}