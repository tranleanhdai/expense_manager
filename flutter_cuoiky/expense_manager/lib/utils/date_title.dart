import 'package:intl/intl.dart';

class DateTitle {
  static String getTitle(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();

      Duration diff = now.difference(date);

      // Hôm nay
      if (diff.inDays == 0 &&
          date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        return "Hôm nay";
      }

      // Hôm qua
      if (diff.inDays == 1) {
        return "Hôm qua";
      }

      // Tháng này
      if (date.month == now.month && date.year == now.year) {
        return "Tháng này";
      }

      // Tháng trước
      if (date.month == now.month - 1 && date.year == now.year) {
        return "Tháng trước";
      }

      // Ngày bình thường
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (e) {
      return dateString;
    }
  }
}
