import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/currency_format.dart';

class UpdateBalanceScreen extends StatefulWidget {
  final double currentBalance;

  const UpdateBalanceScreen({super.key, required this.currentBalance});

  @override
  State<UpdateBalanceScreen> createState() => _UpdateBalanceScreenState();
}

class _UpdateBalanceScreenState extends State<UpdateBalanceScreen> {
  late TextEditingController controller;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.currentBalance.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _saveBalance() {
    final value = controller.text.trim();

    if (value.isEmpty) {
      setState(() => _isValid = false);
      return;
    }

    final newValue = double.tryParse(value);
    if (newValue == null || newValue < 0) {
      setState(() => _isValid = false);
      return;
    }

    Navigator.pop(context, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cập nhật số dư",
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveBalance,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF00897B),
            ),
            child: const Text(
              "LƯU",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ================= Hiển thị số dư hiện tại =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Số dư hiện tại",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.format(widget.currentBalance),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================= Input số dư mới =================
            const Text(
              "Số dư mới",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: Text(
                    "đ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
                prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: "Nhập số tiền",
                errorText: _isValid ? null : "Vui lòng nhập số tiền hợp lệ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF00897B), width: 2),
                ),
              ),
              onChanged: (_) {
                if (!_isValid) setState(() => _isValid = true);
              },
            ),

            const SizedBox(height: 16),

            // ================= Gợi ý =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF00897B)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Nhập tổng số tiền hiện có trong ví của bạn.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF00695C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
