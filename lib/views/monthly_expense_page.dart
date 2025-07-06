import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpensa/utils/Theme/color_theme.dart';
import '../controller/monthly_expense_controller.dart';
import '../utils/widgets/expense_category_card.dart';
import '../utils/widgets/expense_summary_card.dart';
import '../utils/widgets/expense_pie_chart.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:animate_do/animate_do.dart';

class MonthlyExpensePage extends StatelessWidget {
  MonthlyExpensePage({super.key});

  final MonthlyExpenseController controller = Get.put(
    MonthlyExpenseController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF), // Soft pastel background
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B1FA8), kPrimaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Obx(
          () => GestureDetector(
            onTap: () async {
              final picked = await showMonthPicker(
                context: context,
                initialDate: controller.selectedMonth.value,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                controller.changeMonth(picked);
              }
            },
            child: Row(
              children: [
                Text(
                  controller.formattedMonth,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(
        () => FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filter dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.filter_list, color: Colors.blueAccent),
                          const SizedBox(width: 12),
                          const Text(
                            "Filter Category:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _showCupertinoCategoryPicker(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Text(
                                controller.selectedCategory.value.isEmpty
                                    ? "All"
                                    : controller.selectedCategory.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                ExpenseSummaryCard(amount: controller.totalExpenses.value),

                const SizedBox(height: 24),

                // Pie chart
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF2E6FF), Color(0xFFFFFFFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ExpensePieChart(categories: controller.categories),
                ),

                const SizedBox(height: 16),

                // Category cards grid
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      controller.categories.isEmpty
                          ? const Center(
                            child: Text(
                              "No categories found.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                          : ListView.separated(
                            itemCount: controller.categories.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return ExpenseCategoryCard(
                                category: controller.categories[index],
                              );
                            },
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCupertinoCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("All"),
                onTap: () {
                  controller.changeCategory("");
                  Navigator.pop(context);
                },
              ),
              ...controller.categories.map(
                (c) => ListTile(
                  title: Text(c.name),
                  onTap: () {
                    controller.changeCategory(c.name);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
