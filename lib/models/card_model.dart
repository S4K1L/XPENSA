import 'package:flutter/cupertino.dart';

class BudgetCardModel {
  final String title;
  final int amount;
  final IconData icon;
  final Color backgroundColor;
  final String imageAsset;
  final String docId; // ADD THIS

  BudgetCardModel({
    required this.title,
    required this.amount,
    required this.icon,
    required this.backgroundColor,
    required this.imageAsset,
    required this.docId,
  });
}
