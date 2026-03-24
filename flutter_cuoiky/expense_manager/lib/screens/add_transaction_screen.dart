import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/budget_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  int selectedBudgetIndex = -1;

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    final allBudgets = [
      ...budgetProvider.incomeBudgets,
      ...budgetProvider.expenseBudgets,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      appBar: AppBar(
        title: const Text("Giao dịch mới"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Số tiền", style: TextStyle(fontSize: 15)),
            const SizedBox(height: 6),

            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Nhập số tiền",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Chọn ngân sách"),
            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                itemCount: allBudgets.length,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (_, i) {
                  final b = allBudgets[i];
                  final isSelected = selectedBudgetIndex == i;

                  return GestureDetector(
                    onTap: () => setState(() => selectedBudgetIndex = i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.purple.withOpacity(0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.purple : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, color: Color(b.color), size: 26),
                          const SizedBox(height: 6),
                          Text(
                            b.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            const Text("Ghi chú"),
            const SizedBox(height: 6),

            TextField(
              controller: noteCtrl,
              decoration: InputDecoration(
                hintText: "Nhập ghi chú",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Thêm",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),

                onPressed: () async {
                  if (selectedBudgetIndex == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng chọn ngân sách")),
                    );
                    return;
                  }

                  final selectedBudget = allBudgets[selectedBudgetIndex];
                  final amount = double.tryParse(amountCtrl.text) ?? 0;

                  // ⭐ Lưu giao dịch vào DB
                  final txProvider = Provider.of<TransactionProvider>(context, listen: false);

                  await txProvider.addTransaction(
                    TransactionModel(
                      type: selectedBudget.type,
                      categoryId: selectedBudget.id!,
                      categoryName: selectedBudget.name,
                      amount: amount,
                      note: noteCtrl.text,
                      date: DateTime.now().toIso8601String(),
                    ),
                  );

                  // ============================================================
                  // ⭐⭐ CẬP NHẬT NGÂN SÁCH (tự trừ hoặc cộng tiền)
                  // ============================================================

                  if (selectedBudget.type == 'expense') {
                    // Chi tiêu → tăng usedAmount
                    selectedBudget.usedAmount += amount;
                  } else {
                    // Thu nhập → dùng để theo dõi số tiền nhận
                    selectedBudget.usedAmount += amount;
                  }

                  await Provider.of<BudgetProvider>(context, listen: false)
                      .updateBudget(selectedBudget);

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
