import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/transaction_item.dart';
import '../utils/color_generator.dart';
import '../utils/currency_format.dart';
import 'update_balance_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = Provider.of<TransactionProvider>(context);
    final chartData = tx.expenseByCategory;

    // ⭐ TÍNH SPACE ĐỂ TRÁNH FAB + BOTTOM BAR CHE
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            bottom: 150 + bottomPadding, // ⭐ CHÍNH XÁC – KO BỊ CHE NỮA
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              _buildHeader(),
              const SizedBox(height: 20),

              _buildWalletCard(context, tx),
              const SizedBox(height: 28),

              _sectionTitle("Tháng này"),
              const SizedBox(height: 16),

              _buildChartSection(chartData),
              const SizedBox(height: 28),

              _sectionTitle("Giao dịch gần đây"),
              const SizedBox(height: 12),

              _buildRecentTransactions(tx),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================================
  // ⭐ HEADER
  // ======================================================================
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Xin chào Nguyễn Hữu Bình",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1E),
          ),
        ),
        SizedBox(height: 4),

      ],
    );
  }
  // ======================================================================
  // ⭐ WALLET CARD
  // ======================================================================
  Widget _buildWalletCard(BuildContext context, TransactionProvider tx) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UpdateBalanceScreen(
              currentBalance: tx.balance,
            ),
          ),
        );

        if (result != null && result is double) {
          tx.updateBalance(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF1DE9B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ví tiền",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.format(tx.balance),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  // ⭐ SECTION TITLE
  // ======================================================================
  Widget _sectionTitle(String text, {String? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1C1E),
          ),
        ),
        if (action != null)
          Text(
            action,
            style: const TextStyle(
              color: Color(0xFF00A896),
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  // ======================================================================
  // ⭐ PIE CHART
  // ======================================================================
  Widget _buildChartSection(Map<String, double> data) {
    if (data.isEmpty) return _emptyBox("Không có dữ liệu chi tiêu");

    final total = data.values.fold(0.0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: PieChartWidget(data: data),
            ),
          ),

          const SizedBox(height: 20),

          Column(
            children: data.entries.map((entry) {
              final percent = (entry.value / total) * 100;
              final color = ColorGenerator.getColorForCategory(entry.key);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "${percent.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ======================================================================
  // ⭐ LAST 5 TRANSACTIONS
  // ======================================================================
  Widget _buildRecentTransactions(TransactionProvider tx) {
    final recent = tx.transactions.take(5).toList();

    if (recent.isEmpty) return _emptyBox("Không có giao dịch gần đây");

    return Column(
      children: recent
          .map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TransactionItem(e),
      ))
          .toList(),
    );
  }

  // ======================================================================
  // ⭐ EMPTY BOX
  // ======================================================================
  Widget _emptyBox(String text) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
