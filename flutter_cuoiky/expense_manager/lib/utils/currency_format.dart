import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    final NumberFormat formatter =
    NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatter.format(amount);
  }
}
