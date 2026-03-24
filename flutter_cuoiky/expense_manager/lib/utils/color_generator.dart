import 'package:flutter/material.dart';

class ColorGenerator {
  /// Danh sách màu cố định – mỗi category sẽ map theo hashCode vào 1 màu.
  static final List<Color> colors = [
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFF2196F3), // Blue
    Color(0xFFE91E63), // Pink
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF795548), // Brown
    Color(0xFF3F51B5), // Indigo
    Color(0xFF8BC34A), // Light Green
    Color(0xFFCDDC39), // Lime
    Color(0xFF009688), // Teal
  ];

  /// Trả về màu theo tên category
  static Color getColorForCategory(String category) {
    // chuẩn hóa category, tránh lỗi chữ hoa / khoảng trắng
    final normalized = category.trim().toLowerCase();

    // tạo index dựa trên hashCode → màu luôn ổn định
    final index = normalized.hashCode.abs() % colors.length;

    return colors[index];
  }
}
