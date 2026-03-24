import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../widgets/budget_item.dart';
import 'new_budget_screen.dart';
import 'budget_detail_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BudgetProvider>(context);

    final incomeList = provider.incomeBudgets;
    final expenseList = provider.expenseBudgets;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F5F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ngân sách đang áp dụng",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8E24AA),
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewBudgetScreen()),
          );
        },
      ),

      body: Column(
        children: [
          // ========================= TAB BUTTON =========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _tabButton("Thu nhập", tabIndex == 0, () {
                  setState(() => tabIndex = 0);
                }),
                const SizedBox(width: 12),
                _tabButton("Chi tiêu", tabIndex == 1, () {
                  setState(() => tabIndex = 1);
                }),
              ],
            ),
          ),

          // ======================= LIST NGÂN SÁCH =======================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
              children: [
                ...(tabIndex == 0 ? incomeList : expenseList).map(
                      (b) => Dismissible(
                    key: ValueKey(b.id),
                    direction: DismissDirection.endToStart,

                    // ==== Background khi vuốt ====
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white, size: 30),
                    ),

                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Xoá ngân sách?"),
                          content: const Text("Thao tác này không thể hoàn tác."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Hủy"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Xoá",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },

                    onDismissed: (_) async {
                      await provider.deleteBudget(b.id!);
                    },

                    // ==== Hiển thị item ngân sách ====
                    child: BudgetItem(
                      budget: b,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BudgetDetailScreen(budget: b),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================== UI CỦA TAB ==========================
  Widget _tabButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFCE93D8) : const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: active ? Colors.purple : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
