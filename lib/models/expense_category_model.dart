import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final double amount;
  final IconData icon;
  final Color color;

  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.icon,
    required this.color,
  });
}
