import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  final Map<String, IconData> categoryIcons = {
    'Payment and Bill': Icons.receipt_long,
    'Transportation': Icons.directions_car,
    'Recharge': Icons.phone_android,
    'Grocery': Icons.local_grocery_store,
    'Others': Icons.extension_rounded,
  };

  final Map<String, Color> categoryColors = {
    'Payment and Bill': Colors.blue,
    'Transportation': Colors.purple,
    'Recharge': Colors.orange,
    'Grocery': Colors.green,
    'Others': Colors.deepOrangeAccent,
  };

  RxString selectedCategory = ''.obs;
  RxList<String> categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.value = categoryIcons.keys.toList();
  }

  Stream<List<Expense>> fetchExpenses() {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    final expensesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('expenses');

    if (selectedCategory.value.isEmpty) {
      return expensesCollection
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Expense.fromMap(doc.data(), doc.id))
                .toList();
          });
    } else {
      return expensesCollection
          .where('category', isEqualTo: selectedCategory.value)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Expense.fromMap(doc.data(), doc.id))
                .toList();
          });
    }
  }

  void showCategorySelection(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => CupertinoPicker(
                      itemExtent: 36.0,
                      onSelectedItemChanged: (int index) {
                        selectedCategory.value = categories[index];
                      },
                      children:
                          categories
                              .map((category) => Center(child: Text(category)))
                              .toList(),
                    ),
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> deleteExpense(String docId) async {
    try {
      String userUID = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .collection('expenses')
          .doc(docId)
          .delete();
    } catch (error) {
      print('Error deleting expense: $error');
    }
  }
}
