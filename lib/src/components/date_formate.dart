import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toShortDateString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}
