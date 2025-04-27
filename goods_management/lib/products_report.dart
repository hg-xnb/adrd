import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'new_definations.dart';

class ProductsReportScreen extends StatefulWidget {
  final ProductList products;

  const ProductsReportScreen({super.key, required this.products});

  @override
  State<ProductsReportScreen> createState() => _ProductsReportScreenState();
}

class _ProductsReportScreenState extends State<ProductsReportScreen> {
  String _groupBy = 'Month'; // Default grouping
  DateTime? _startDate;
  DateTime? _endDate;

  Map<String, Map<String, int>> _groupedData() {
    Map<String, Map<String, int>> grouped = {};

    for (var product in widget.products.allProducts) {
      if (product.importTime == null && product.exportTime == null) continue;

      void addTime(DateTime? time, String type) {
        if (time == null) return;

        if (_groupBy == 'Day') {
          if (_startDate != null && time.isBefore(_startDate!)) return;
          if (_endDate != null && time.isAfter(_endDate!)) return;
        }

        String key;
        if (_groupBy == 'Day') {
          key = DateFormat('yyyy-MM-dd').format(time);
        } else if (_groupBy == 'Week') {
          String weekOfYear = DateFormat('w').format(time).padLeft(2, '0');
          key = '${time.year}-W$weekOfYear';
        } else if (_groupBy == 'Month') {
          key = DateFormat('yyyy-MM').format(time);
        } else if (_groupBy == 'Year') {
          key = DateFormat('yyyy').format(time);
        } else {
          key = DateFormat('yyyy-MM').format(time);
        }

        grouped[key] ??= {'import': 0, 'export': 0};
        grouped[key]![type] = (grouped[key]![type] ?? 0) + 1;
      }

      addTime(product.importTime, 'import');
      addTime(product.exportTime, 'export');
    }

    var sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    var sortedGrouped = {for (var key in sortedKeys) key: grouped[key]!};

    return sortedGrouped;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime initialDate =
        isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _groupedData();
    final totalGoods = widget.products.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thống kê sản phẩm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF006A71),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total goods: $totalGoods',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Dropdown Group By
            Row(
              children: [
                const Text('Group by: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _groupBy,
                  items:
                      ['Day', 'Week', 'Month', 'Year']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _groupBy = val;
                        _startDate = null;
                        _endDate = null;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show date pickers if group by "Day"
            if (_groupBy == 'Day')
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            hintText: 'Select start date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                            text:
                                _startDate != null
                                    ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_startDate!)
                                    : '',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            hintText: 'Select end date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                            text:
                                _endDate != null
                                    ? DateFormat('yyyy-MM-dd').format(_endDate!)
                                    : '',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Chart
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  height: 300,
                  width: data.length * 80,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      groupsSpace: 40,
                      barTouchData: BarTouchData(enabled: false),
                      barGroups:
                          data.entries.mapIndexed((index, entry) {
                            return BarChartGroupData(
                              x: index,
                              barsSpace: 10,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value['import']!.toDouble(),
                                  color: Colors.blue,
                                  width: 6,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                BarChartRodData(
                                  toY: entry.value['export']!.toDouble(),
                                  color: Colors.green,
                                  width: 6,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }).toList(),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() >= data.keys.length)
                                return Container();
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
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1, // <-- Force integer interval
                            getTitlesWidget: (value, meta) {
                              if (value % 1 == 0) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine:
                            (value) => FlLine(
                              color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                              strokeWidth: 1,
                            ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(),
                          bottom: BorderSide(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Legend
            const Row(
              children: [
                LegendItem(color: Colors.blue, text: 'Import'),
                SizedBox(width: 16),
                LegendItem(color: Colors.green, text: 'Export'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
