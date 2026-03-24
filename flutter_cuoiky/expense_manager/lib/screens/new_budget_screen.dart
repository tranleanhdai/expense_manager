import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../models/budget_model.dart';

class NewBudgetScreen extends StatefulWidget {
  const NewBudgetScreen({super.key});

  @override
  State<NewBudgetScreen> createState() => _NewBudgetScreenState();
}

class _NewBudgetScreenState extends State<NewBudgetScreen> {
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  int type = 0; // 0 = income, 1 = expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ngân sách mới"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Tên ngân sách"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: "Số tiền giới hạn"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            // TYPE BUTTONS
            Row(
              children: [
                Expanded(
                  child: _typeButton("Thu nhập", type == 0, () {
                    setState(() => type = 0);
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _typeButton("Chi tiêu", type == 1, () {
                    setState(() => type = 1);
                  }),
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                final provider =
                Provider.of<BudgetProvider>(context, listen: false);

                provider.addBudget(
                  BudgetModel(
                    name: nameCtrl.text,
                    icon: Icons.water_drop.codePoint,
                    color: Colors.blue.value,
                    type: type == 0 ? "income" : "expense",
                    limitAmount: double.tryParse(amountCtrl.text) ?? 0,
                    usedAmount: 0,
                    startDate: "01-01-2024",
                    endDate: "01-02-2024",
                  ),
                );


                Navigator.pop(context);
              },
              child: const Text(
                "Thêm",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _typeButton(String text, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? Colors.purple : Colors.grey,
          ),
          color: active ? Colors.purple.shade100 : Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.purple : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
