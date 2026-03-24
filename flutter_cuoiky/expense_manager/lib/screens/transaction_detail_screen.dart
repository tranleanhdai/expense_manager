import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../utils/currency_format.dart';
import '../utils/date_format.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel tx;

  const TransactionDetailScreen({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết giao dịch"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================== LOẠI GIAO DỊCH ===================
            _title("Loại giao dịch"),
            Text(
              tx.type == "income" ? "Thu" : "Chi",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // =================== DANH MỤC ===================
            _title("Danh mục"),
            Text(
              tx.categoryName,   // ⭐ DÙNG categoryName mới
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // =================== SỐ TIỀN ===================
            _title("Số tiền"),
            Text(
              CurrencyFormatter.format(tx.amount),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // =================== GHI CHÚ ===================
            _title("Ghi chú"),
            Text(
              tx.note.isEmpty ? "(Không có ghi chú)" : tx.note,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // =================== THỜI GIAN ===================
            _title("Thời gian"),
            Text(
              DateFormatter.format(tx.date),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Hiển thị tiêu đề nhỏ
  Widget _title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Hộp thoại xác nhận xoá
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa giao dịch"),
        content: const Text("Bạn có chắc chắn muốn xóa giao dịch này không?"),
        actions: [
          TextButton(
            child: const Text("Hủy"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Xóa",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              final provider =
              Provider.of<TransactionProvider>(context, listen: false);

              await provider.deleteTransaction(tx.id!);

              Navigator.pop(context); // đóng dialog
              Navigator.pop(context); // quay về màn hình trước

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã xoá giao dịch")),
              );
            },
          ),
        ],
      ),
    );
  }
}
