import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../models/expense_category_model.dart';
import 'package:flutter/material.dart';

class MonthlyExpenseController extends GetxController {
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  RxDouble totalExpenses = 0.0.obs;
  RxList<ExpenseCategory> categories = <ExpenseCategory>[].obs;
  RxMap<int, double> dailyTotals = <int, double>{}.obs;
  RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpensesForMonth(selectedMonth.value);
  }

  void changeMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    loadExpensesForMonth(newMonth);
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    loadExpensesForMonth(selectedMonth.value);
  }

  void loadExpensesForMonth(DateTime month) {
    _fetchExpenses(month).listen((expenses) {
      totalExpenses.value = expenses.fold(0.0, (sum, e) => sum + e.amount);

      // Summarize by category
      final Map<String, double> categorySums = {};
      for (var e in expenses) {
        categorySums[e.category] = (categorySums[e.category] ?? 0) + e.amount;
      }

      categories.value =
          categorySums.entries.map((entry) {
            return ExpenseCategory(
              name: entry.key,
              amount: entry.value,
              icon: categoryIcons[entry.key] ?? Icons.help_outline,
              color: categoryColors[entry.key] ?? Colors.grey,
            );
          }).toList();

      // Summarize by day
      final Map<int, double> daySums = {};
      for (var e in expenses) {
        int day = e.timestamp.day;
        daySums[day] = (daySums[day] ?? 0) + e.amount;
      }
      dailyTotals.value = daySums;
    });
  }

  Stream<List<Expense>> _fetchExpenses(DateTime month) {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    final expensesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('expenses');

    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    var query = expensesCollection
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end));

    if (selectedCategory.value.isNotEmpty) {
      query = query.where('category', isEqualTo: selectedCategory.value);
    }

    return query.orderBy('timestamp', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Expense.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  String get formattedMonth {
    return DateFormat("MMMM yyyy").format(selectedMonth.value);
  }

  /// Dummy color/icon maps
  Map<String, Color> categoryColors = {
    'Recharge': Colors.orange,
    'Transportation': Colors.purple,
    'Payment and Bill': Colors.blue,
    'Grocery': Colors.green,
    'Others': Colors.deepOrangeAccent,
  };

  Map<String, IconData> categoryIcons = {
    'Recharge': Icons.phone_android,
    'Grocery': Icons.local_grocery_store_outlined,
    'Payment and Bill': Icons.receipt_long,
    'Transportation': Icons.directions_car,
    'Others': Icons.extension_rounded,
  };
}
