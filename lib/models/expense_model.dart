import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String category;
  final String name;
  final double amount;
  final DateTime timestamp;

  Expense({
    required this.id,
    required this.category,
    required this.name,
    required this.amount,
    required this.timestamp,
  });

  factory Expense.fromMap(Map<String, dynamic> data, String documentId) {
    return Expense(
      id: documentId,
      category: data['category'] ?? 'Others',
      amount: (data['amount'] ?? 0).toDouble(),
      name: data['name'] ?? 'Others',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}