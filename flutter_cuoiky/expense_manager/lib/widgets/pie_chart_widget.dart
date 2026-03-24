import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../utils/color_generator.dart';
import '../utils/currency_format.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, double> data;

  const PieChartWidget({super.key, required this.data});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text("Không có dữ liệu chi tiêu"));
    }

    final total = widget.data.values.fold(0.0, (sum, v) => sum + v);

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            centerSpaceRadius: 45,
            sectionsSpace: 2,
            sections: _buildSections(total),

            /// ⭐ Bật touch đẹp hơn
            pieTouchData: PieTouchData(
              enabled: true,
              touchCallback: (event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    touchedIndex = null;
                    return;
                  }
                  touchedIndex = response.touchedSection!.touchedSectionIndex;
                });
              },
            ),
          ),
        ),

        /// ⭐ Tooltip tuỳ chỉnh
        if (touchedIndex != null) _buildTooltip(total),
      ],
    );
  }

  /// ⭐ Tooltip xuất hiện khi chạm
  Widget _buildTooltip(double total) {
    final entry = widget.data.entries.elementAt(touchedIndex!);
    final percent = (entry.value / total) * 100;

    return Positioned(
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              entry.key,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              "${CurrencyFormatter.format(entry.value)} (${percent.toStringAsFixed(1)}%)",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ⭐ Tạo từng miếng của biểu đồ tròn (ĐÃ FIX MÀU)
  List<PieChartSectionData> _buildSections(double total) {
    return widget.data.entries.mapIndexed((index, entry) {
      final color = ColorGenerator.getColorForCategory(entry.key);
      final isTouched = index == touchedIndex;

      return PieChartSectionData(
        value: entry.value,
        color: color,
        radius: isTouched ? 80 : 70,
        title: "",
        borderSide: BorderSide(
          color: Colors.white,
          width: isTouched ? 3 : 1.5,
        ),
      );
    }).toList();
  }
}

/// Kotlin-style mapIndexed
extension MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E item) f) {
    int index = 0;
    return map((item) => f(index++, item));
  }
}
