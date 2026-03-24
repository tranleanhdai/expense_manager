import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget_model.dart';
import '../providers/transaction_provider.dart';
import '../utils/currency_format.dart';

class BudgetItem extends StatelessWidget {
  final BudgetModel budget;
  final VoidCallback? onTap;

  const BudgetItem({
    super.key,
    required this.budget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TransactionProvider>(context);

    // ⭐ TÍNH ĐÚNG CHO CẢ THU NHẬP VÀ CHI TIÊU
    double used;
    if (budget.type == "income") {
      // Thu nhập: tính từ transactions
      used = txProvider.transactions
          .where((tx) => tx.type == "income" && tx.categoryId == budget.id)
          .fold(0, (sum, tx) => sum + tx.amount);
    } else {
      // Chi tiêu: dùng usedAmount có sẵn
      used = budget.usedAmount;
    }

    // ⭐ CÒN LẠI (có thể âm nếu thu nhập vượt mục tiêu)
    final remaining = budget.limitAmount - used;

    // ⭐ TIẾN ĐỘ
    final progress = (used / budget.limitAmount).clamp(0, 1);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row icon + name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: budget.colorValue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    budget.iconData,
                    color: budget.colorValue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    budget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 12),

            // Amounts
            Text(
              "${CurrencyFormatter.format(used)} / "
                  "${CurrencyFormatter.format(budget.limitAmount)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.toDouble(),
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                color: budget.colorValue,
              ),
            ),

            const SizedBox(height: 10),

            // ⭐ HIỂN thị "Còn lại" THÔNG MINH
            Text(
              budget.type == "income"
                  ? (remaining > 0
                  ? "Còn thiếu: ${CurrencyFormatter.format(remaining)}"
                  : "Vượt mục tiêu: ${CurrencyFormatter.format(remaining.abs())}")
                  : "Còn lại: ${CurrencyFormatter.format(remaining)}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: budget.type == "income"
                    ? (remaining > 0 ? Colors.orange : Colors.green)
                    : (remaining >= 0 ? Colors.teal : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

