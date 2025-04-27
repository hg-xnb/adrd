import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'new_definations.dart';

class ProductsReportScreen extends StatefulWidget {
  final List<Product> products;

  const ProductsReportScreen({super.key, required this.products});

  @override
  State<ProductsReportScreen> createState() => _ProductsReportScreenState();
}

class _ProductsReportScreenState extends State<ProductsReportScreen> {
  String _groupBy = 'Month'; // Default grouping

  Map<String, Map<String, int>> _groupedData() {
    Map<String, Map<String, int>> grouped = {};

    for (var product in widget.products) {
      // Skip if both times are null
      if (product.importTime == null && product.exportTime == null) continue;

      void addTime(DateTime? time, String type) {
        if (time == null) return;

        String key;
        if (_groupBy == 'Day') {
          key = DateFormat('yyyy-MM-dd').format(time);
        } else if (_groupBy == 'Week') {
          int weekOfYear = int.parse(DateFormat('w').format(time));
          key = '${time.year}-W$weekOfYear';
        } else {
          key = DateFormat('yyyy-MM').format(time);
        }

        grouped[key] ??= {'import': 0, 'export': 0};
        grouped[key]![type] = (grouped[key]![type] ?? 0) + 1;

      }

      addTime(product.importTime, 'import');
      addTime(product.exportTime, 'export');
    }

    // Sort keys: newest first
    var sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    var sortedGrouped = {for (var key in sortedKeys) key: grouped[key]!};

    return sortedGrouped;
  }

  @override
  Widget build(BuildContext context) {
    final data = _groupedData();
    final totalGoods = widget.products.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total goods
            Text(
              'Total goods: $totalGoods',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Dropdown to choose Day/Week/Month
            Row(
              children: [
                const Text('Group by: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _groupBy,
                  items: ['Day', 'Week', 'Month']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _groupBy = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Chart
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 300,
                  width: data.length * 60, // Adjust width
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: data.entries.mapIndexed((index, entry) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value['import']!.toDouble(),
                              color: Colors.blue,
                              width: 8,
                            ),
                            BarChartRodData(
                              toY: entry.value['export']!.toDouble(),
                              color: Colors.green,
                              width: 8,
                            ),
                          ],
                          showingTooltipIndicators: [0, 1],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() >= data.keys.length) return Container();
                              return Transform.rotate(
                                angle: -0.5,
                                child: Text(
                                  data.keys.elementAt(value.toInt()),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
