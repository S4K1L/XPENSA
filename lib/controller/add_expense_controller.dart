// controllers/add_expense_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseController extends GetxController {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  var selectedCategory = ''.obs; // Make selectedCategory observable
  final List<String> categories = [
    'Payment and Bill',
    'Transportation',
    'Recharge',
    'Grocery',
    'Others'
  ];
  final List<IconData> categoryIcons = [
    Icons.payment,
    Icons.directions_car,
    Icons.phone_android,
    Icons.local_grocery_store,
    Icons.more_horiz,
  ];

  Future<void> saveExpense() async {
    User? user = FirebaseAuth.instance.currentUser ;
    if (user == null) {
      return;
    }

    Map<String, dynamic> expenseData = {
      'category': selectedCategory.value,
      'name': nameController.text,
      'amount': double.parse(amountController.text),
      'timestamp': FieldValue.serverTimestamp(),
      'uid': user.uid
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('expenses')
        .add(expenseData);
    _showSuccess('Successfully added expenses');
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void clearInputs() {
    selectedCategory.value = ''; // Clear the observable variable
    amountController.clear();
    nameController.clear();
  }
}