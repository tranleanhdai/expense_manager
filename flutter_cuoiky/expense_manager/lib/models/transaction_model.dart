import 'package:flutter/foundation.dart';

class TransactionModel {
  int? id;
  String type;
  int categoryId;
  String categoryName;
  double amount;
  String note;
  String date;

  TransactionModel({
    this.id,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.note,
    required this.date,
  });

  /// Chuyển object sang Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'note': note,
      'date': date,
    };
  }

  /// Tạo TransactionModel từ dữ liệu SQLite
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
      amount: (map['amount'] as num).toDouble(),
      note: (map['note'] ?? "").toString(),
      date: map['date'],
    );
  }
}
