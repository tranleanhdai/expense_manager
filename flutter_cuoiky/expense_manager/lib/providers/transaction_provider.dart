import 'package:flutter/material.dart';
import 'package:collection/collection.dart';   // ⭐ để dùng firstWhereOrNull
import '../database/db_helper.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

class TransactionProvider extends ChangeNotifier {
  final DBHelper db = DBHelper();


  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  List<BudgetModel> _budgets = [];

  double _balance = 0;
  double get balance => _balance;


  Future<void> initialize() async {
    _balance = await db.getBalance();
    _transactions = await db.getAllTransactions();
    _budgets = await db.getAllBudgets();
    notifyListeners();
  }

  Future<void> updateBalance(double newBal) async {
    _balance = newBal;
    await db.updateBalance(newBal);
    notifyListeners();
  }

  Future<void> increaseBalance(double amount) async {
    _balance += amount;
    await db.updateBalance(_balance);
    notifyListeners();
  }

  Future<void> decreaseBalance(double amount) async {
    _balance -= amount;
    if (_balance < 0) _balance = 0;
    await db.updateBalance(_balance);
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    // 1️⃣ Lưu giao dịch vào DB
    await db.insertTransaction(tx);

    // 2️⃣ Cập nhật ví
    if (tx.type == "income") {
      await increaseBalance(tx.amount);
    } else {
      await decreaseBalance(tx.amount);
    }

    // 3️⃣ Chỉ cập nhật ngân sách nếu là CHI TIÊU
    BudgetModel? budget =
    _budgets.firstWhereOrNull((b) => b.id == tx.categoryId);

    if (budget != null && tx.type == "expense") {
      budget.usedAmount += tx.amount;

      await db.updateBudget(budget);
      _budgets = await db.getAllBudgets();
    }

    // 4️⃣ Load lại danh sách giao dịch
    _transactions = await db.getAllTransactions();
    notifyListeners();
  }


  Future<void> deleteTransaction(int id) async {
    final tx = _transactions.firstWhere((e) => e.id == id);

    // 1️⃣ Cập nhật ví theo chiều ngược lại
    if (tx.type == "income") {
      await decreaseBalance(tx.amount);
    } else {
      await increaseBalance(tx.amount);
    }

    // 2️⃣ Cập nhật ngân sách nếu là CHI TIÊU
    BudgetModel? budget =
    _budgets.firstWhereOrNull((b) => b.id == tx.categoryId);

    if (budget != null && tx.type == "expense") {
      budget.usedAmount -= tx.amount;

      if (budget.usedAmount < 0) budget.usedAmount = 0;

      await db.updateBudget(budget);
      _budgets = await db.getAllBudgets();
    }

    // 3️⃣ Xoá giao dịch khỏi DB
    await db.deleteTransaction(id);

    // 4️⃣ Load lại list
    _transactions = await db.getAllTransactions();
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((e) => e.type == "income")
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => _transactions
      .where((e) => e.type == "expense")
      .fold(0, (sum, e) => sum + e.amount);

  bool get isOverSpending => totalExpense > totalIncome;

  double get overspendAmount =>
      isOverSpending ? totalExpense - totalIncome : 0;


  Map<String, double> get expenseByCategory {
    Map<String, double> map = {};

    for (var tx in _transactions.where((e) => e.type == "expense")) {
      map[tx.categoryName] = (map[tx.categoryName] ?? 0) + tx.amount;
    }

    return map;
  }

  Map<String, List<TransactionModel>> get groupedByDate {
    Map<String, List<TransactionModel>> map = {};

    for (var tx in _transactions) {
      final dateKey = tx.date.substring(0, 10);
      map.putIfAbsent(dateKey, () => []);
      map[dateKey]!.add(tx);
    }

    final sortedKeys = map.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return {for (var k in sortedKeys) k: map[k]!};
  }

  Future<void> clearAll() async {
    for (var tx in _transactions) {
      await db.deleteTransaction(tx.id!);
    }
    _transactions.clear();
    notifyListeners();
  }
}
