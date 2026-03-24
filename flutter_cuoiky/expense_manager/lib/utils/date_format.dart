import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateFormatter {
  /// Format ngày chung trong danh sách giao dịch
  /// Ví dụ: 27/11/2025 • 15:14
  static String format(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy • HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format đầy đủ trong màn hình chi tiết giao dịch
  /// Ví dụ: Thứ 5, 27/11/2025 • 15:14
  static String formatFull(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, dd/MM/yyyy • HH:mm', 'vi_VN').format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Chuyển ngày dạng yyyy-MM-dd sang:
  /// - Hôm nay
  /// - Hôm qua
  /// - dd/MM/yyyy
  static String formatDayHeader(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();

      if (DateUtils.isSameDay(date, now)) return "Hôm nay";
      if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1))))
        return "Hôm qua";

      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
