import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/budget_model.dart';

class BudgetProvider extends ChangeNotifier {
  final DBHelper db = DBHelper();

  List<BudgetModel> _budgets = [];
  List<BudgetModel> get budgets => _budgets;

  List<BudgetModel> get incomeBudgets =>
      _budgets.where((b) => b.type == "income").toList();

  List<BudgetModel> get expenseBudgets =>
      _budgets.where((b) => b.type == "expense").toList();

  // ⭐ Load tất cả ngân sách từ SQLite
  Future<void> loadBudgets() async {
    _budgets = await db.getAllBudgets();
    notifyListeners();
  }

  // ⭐ Thêm ngân sách
  Future<void> addBudget(BudgetModel model) async {
    await db.insertBudget(model);
    await loadBudgets();
  }

  // ⭐ Xóa ngân sách
  Future<void> deleteBudget(int id) async {
    await db.deleteBudget(id);
    await loadBudgets();
  }

  // ⭐ Cập nhật ngân sách
  Future<void> updateBudget(BudgetModel model) async {
    await db.updateBudget(model);
    await loadBudgets();
  }

  // =====================================================
  // ⭐ ⭐ ⭐ HÀM QUAN TRỌNG NHẤT — LẤY NGÂN SÁCH THEO ID ⭐ ⭐ ⭐
  // =====================================================

  BudgetModel? getById(int id) {
    try {
      return _budgets.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // ⭐ Trả về list đầy đủ (income + expense)
  List<BudgetModel> get allBudgets => [...incomeBudgets, ...expenseBudgets];
}
