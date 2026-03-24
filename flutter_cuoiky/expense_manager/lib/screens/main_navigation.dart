import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'transaction_list_screen.dart';
import 'budget_screen.dart';
import 'profile_screen.dart';
import 'add_transaction_screen.dart';
import 'new_budget_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    TransactionListScreen(),
    BudgetScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // ⭐ Lấy chiều cao gesture bar (Android/iOS)
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      extendBody: true, // ⭐ Cho phép body tràn xuống dưới BottomAppBar

      body: IndexedStack(
        index: index,
        children: screens,
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: Colors.purple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewBudgetScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
            );
          }
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        // ⭐ FIX OVERFLOW: chiều cao động theo máy
        height: 70 + bottomInset,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, "Trang chủ", 0),
            _navItem(Icons.receipt_long_rounded, "Giao dịch", 1),

            const SizedBox(width: 40), // chỗ trống cho FAB

            _navItem(Icons.account_balance_wallet_rounded, "Ngân sách", 2),
            _navItem(Icons.person_rounded, "Hồ sơ", 3),
          ],
        ),
      ),
    );
  }

  // ================== NAV ITEM ==================
  Widget _navItem(IconData icon, String label, int page) {
    final bool isActive = index == page;

    return InkWell(
      onTap: () => setState(() => index = page),
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 70,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? Colors.teal : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.teal : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
