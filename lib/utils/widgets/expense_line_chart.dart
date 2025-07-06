import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseLineChart extends StatelessWidget {
  final Map<int, double> dailyTotals;
  final int maxDay;

  const ExpenseLineChart({
    super.key,
    required this.dailyTotals,
    required this.maxDay,
  });

  @override
  Widget build(BuildContext context) {
    final spots = dailyTotals.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.deepPurple,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
