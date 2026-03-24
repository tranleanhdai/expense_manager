import 'package:flutter/material.dart';

class BudgetModel {
  int? id;
  String name;
  int icon;          // Icon lưu dạng codePoint
  int color;         // Lưu Color.value (int)
  double limitAmount;
  double usedAmount;
  String startDate;
  String endDate;
  String type;       // income hoặc expense

  BudgetModel({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.limitAmount,
    required this.usedAmount,
    required this.startDate,
    required this.endDate,
    required this.type,
  });

  // 🔵 Icon chuyển từ int → IconData
  IconData get iconData => IconData(icon, fontFamily: 'MaterialIcons');

  // 🔵 Màu
  Color get colorValue => Color(color);

  // =====================================================
  // 🔄 Convert to MAP để lưu DB
  // =====================================================
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "icon": icon,
      "color": color,
      "limitAmount": limitAmount,
      "usedAmount": usedAmount,
      "startDate": startDate,
      "endDate": endDate,
      "type": type,
    };
  }

  // =====================================================
  // 🔄 Convert DB → MODEL
  // =====================================================
  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map["id"],
      name: map["name"],
      icon: map["icon"],
      color: map["color"],
      limitAmount: map["limitAmount"],
      usedAmount: map["usedAmount"],
      startDate: map["startDate"],
      endDate: map["endDate"],
      type: map["type"],
    );
  }
}
