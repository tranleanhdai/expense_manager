import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../widgets/transaction_item.dart';
import '../utils/date_title.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ⭐ TÍNH TOÁN PADDING ĐỘNG
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewPadding.bottom;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3F5F7),
        centerTitle: true,
        title: const Text(
          "Danh sách giao dịch",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, txProvider, child) {
          final grouped = txProvider.groupedByDate;

          if (grouped.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Chưa có giao dịch nào",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nhấn nút + để thêm giao dịch mới",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 70 + bottomPadding + 20, // ⭐ TÍNH TOÁN CHÍNH XÁC
            ),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final date = grouped.keys.elementAt(index);
              final transactions = grouped[date] ?? [];

              if (transactions.isEmpty) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: 12,
                      ),
                      child: Text(
                        DateTitle.getTitle(date),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4A4A4A),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    ...transactions.map((tx) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TransactionItem(tx),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}