import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/budget_model.dart';
import '../providers/transaction_provider.dart';
import '../utils/currency_format.dart';

class BudgetDetailScreen extends StatelessWidget {
  final BudgetModel budget;

  const BudgetDetailScreen({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TransactionProvider>(context);

    // ⭐ TÍNH SỐ TIỀN ĐÃ THÊM (THU NHẬP) HOẶC ĐÃ DÙNG (CHI TIÊU)
    double used;

    if (budget.type == "income") {
      // ⭐ Lấy tất cả giao dịch thu nhập thuộc ngân sách này
      used = txProvider.transactions
          .where((tx) => tx.type == "income" && tx.categoryId == budget.id)
          .fold(0, (sum, tx) => sum + tx.amount);
    } else {
      // ⭐ Chi tiêu → dùng usedAmount đã tính sẵn
      used = budget.usedAmount;
    }

    // ⭐ CÒN LẠI - LOGIC KHÁC NHAU CHO THU NHẬP VÀ CHI TIÊU
    double remaining;
    if (budget.type == "income") {
      // Thu nhập: còn thiếu bao nhiêu để đạt mục tiêu
      // Nếu âm = đã vượt mục tiêu
      remaining = budget.limitAmount - used;
    } else {
      // Chi tiêu: còn được dùng bao nhiêu
      remaining = budget.limitAmount - used;
    }

    // ⭐ % Tiến độ
    final double progress = (used / budget.limitAmount).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          budget.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= ICON + TÊN =================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: budget.colorValue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    budget.iconData,
                    color: budget.colorValue,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  budget.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ================= HẠN MỨC / MỤC TIÊU =================
            Text(
              budget.type == "income" ? "Mục tiêu" : "Hạn mức",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(budget.limitAmount),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // ================= ĐÃ THÊM / ĐÃ DÙNG =================
            Text(
              budget.type == "income" ? "Đã thêm" : "Đã dùng",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(used),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: budget.type == "income" ? Colors.teal : Colors.red,
              ),
            ),

            const SizedBox(height: 24),

            // ================= CÒN LẠI =================
            Text(
              budget.type == "income"
                  ? (remaining > 0 ? "Còn thiếu" : "Vượt mục tiêu")
                  : "Còn lại",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              CurrencyFormatter.format(remaining.abs()), // Hiển thị giá trị tuyệt đối
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: budget.type == "income"
                    ? (remaining > 0 ? Colors.orange : Colors.green) // Còn thiếu = cam, vượt = xanh
                    : (remaining >= 0 ? Colors.teal : Colors.red), // Chi tiêu: còn = xanh, vượt = đỏ
              ),
            ),

            const SizedBox(height: 30),

            // ================= PROGRESS BAR =================
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                color: budget.colorValue,
                backgroundColor: Colors.grey.shade300,
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

