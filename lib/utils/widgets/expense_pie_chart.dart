import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/expense_category_model.dart';

class ExpensePieChart extends StatelessWidget {
  final List<ExpenseCategory> categories;

  const ExpensePieChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Text("No data for this month");
    }

    return AspectRatio(
      aspectRatio: 2.0,
      child: PieChart(
        PieChartData(
          sections: categories
              .map((c) => PieChartSectionData(
            value: c.amount,
            color: c.color,
            title: "${c.name}\n৳${c.amount.toStringAsFixed(0)}",
            titleStyle: const TextStyle(
              fontSize: 12,

            ),
          ))
              .toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
