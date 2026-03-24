import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Providers
import 'providers/transaction_provider.dart';
import 'providers/budget_provider.dart' as providers;

// Screens
import 'screens/main_navigation.dart';
import 'screens/transaction_history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
// import 'screens/currency_converter_screen.dart'; // ⭐ TẠM THỜI COMMENT

// Utils
import 'utils/notification_helper.dart';

// ============================================================
// 🔥 FIX LỖI SSL "CERTIFICATE_VERIFY_FAILED" KHI GỌI API
// ⚠️ CHỈ DÙNG TRONG DEV/DEBUG - XÓA KHI BUILD PRODUCTION
// ============================================================
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print("🔓 Bypass SSL for: $host");
        return true; // Bỏ qua kiểm tra SSL
      };
  }
}
// ============================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ⭐ FIX LỖI SSL (chỉ cho DEV)
  HttpOverrides.global = MyHttpOverrides();

  // ⭐ Khởi tạo Firebase
  await Firebase.initializeApp();

  // ⭐ Khởi tạo notification
  await NotificationHelper.init();

  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ⭐ Provider giao dịch (SQLite + Firestore sync)
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..initialize(),
        ),

        // ⭐ Provider ngân sách
        ChangeNotifierProvider(
          create: (_) => providers.BudgetProvider()..loadBudgets(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Expense Manager",

        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.light,
        ),

        // ⭐ Màn hình đầu tiên
        home: const MainNavigation(),

        // ⭐ Định nghĩa route
        routes: {
          "/transactions": (_) => const TransactionHistoryScreen(),
          "/login": (_) => const LoginScreen(),
          "/register": (_) => const RegisterScreen(),
          // "/currency": (_) => const CurrencyConverterScreen(), // ⭐ TẠM THỜI COMMENT
        },
      ),
    );
  }
}