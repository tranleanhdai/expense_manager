import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/date_format.dart';
import '../utils/currency_format.dart';
import '../screens/transaction_detail_screen.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel tx;
  const TransactionItem(this.tx, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(tx: tx),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                // ===== ICON BÊN TRÁI =====
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tx.type == "income"
                        ? Colors.green.withOpacity(0.12)
                        : Colors.red.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tx.type == "income"
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: tx.type == "income"
                        ? Colors.green[700]
                        : Colors.red[700],
                    size: 24,
                  ),
                ),

                const SizedBox(width: 14),

                // ===== NỘI DUNG GIỮA =====
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ⭐ Hiển thị đúng tên danh mục
                      Text(
                        tx.categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),

                      Text(
                        DateFormatter.format(tx.date),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ===== SỐ TIỀN BÊN PHẢI =====
                Text(
                  CurrencyFormatter.format(tx.amount),
                  style: TextStyle(
                    color: tx.type == "income"
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
