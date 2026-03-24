import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction_model.dart';
import '../models/budget_model.dart';

class DBHelper {
  static Database? _database;

  // =====================================================
  //  GET DATABASE INSTANCE
  // =====================================================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // =====================================================
  //  INIT DATABASE
  // =====================================================
  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "expense.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // --------------------------------------------------
        //  🟦 BẢNG GIAO DỊCH (transactions)
        // --------------------------------------------------
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT,
            categoryId INTEGER,
            categoryName TEXT,
            amount REAL,
            note TEXT,
            date TEXT
          )
        ''');

        // --------------------------------------------------
        //  🟩 BẢNG NGÂN SÁCH (budgets)
        // --------------------------------------------------
        await db.execute('''
          CREATE TABLE budgets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            icon INTEGER,
            color INTEGER,
            limitAmount REAL,
            usedAmount REAL,
            startDate TEXT,
            endDate TEXT,
            type TEXT
          )
        ''');

        // --------------------------------------------------
        //  🟧 BẢNG VÍ TIỀN (wallet)
        // --------------------------------------------------
        await db.execute('''
          CREATE TABLE wallet(
            id INTEGER PRIMARY KEY,
            balance REAL
          )
        ''');

        // Tạo ví mặc định 2.000.000đ
        await db.insert("wallet", {"id": 1, "balance": 2000000});
      },
    );
  }

  // =====================================================
  //  TRANSACTION CRUD
  // =====================================================

  Future<int> insertTransaction(TransactionModel tx) async {
    final db = await database;
    return await db.insert("transactions", tx.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final data = await db.query("transactions", orderBy: "date DESC");
    return data.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete("transactions", where: "id = ?", whereArgs: [id]);
  }

  // =====================================================
  //  BUDGET CRUD
  // =====================================================

  Future<int> insertBudget(BudgetModel model) async {
    final db = await database;
    return await db.insert("budgets", model.toMap());
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    final db = await database;
    final data = await db.query("budgets", orderBy: "id DESC");
    return data.map((e) => BudgetModel.fromMap(e)).toList();
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete("budgets", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateBudget(BudgetModel model) async {
    final db = await database;
    return await db.update(
      "budgets",
      model.toMap(),
      where: "id = ?",
      whereArgs: [model.id],
    );
  }

  // =====================================================
  //  WALLET CRUD
  // =====================================================

  /// Lấy số dư trong ví
  Future<double> getBalance() async {
    final db = await database;
    final res = await db.query("wallet", where: "id = 1", limit: 1);

    if (res.isEmpty) return 0;
    return res.first["balance"] as double;
  }

  /// Cập nhật số dư ví
  Future<void> updateBalance(double newBalance) async {
    final db = await database;
    await db.update(
      "wallet",
      {"balance": newBalance},
      where: "id = 1",
    );
  }
}
