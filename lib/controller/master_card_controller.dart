import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/card_model.dart';

class MasterCardController extends GetxController {
  final RxList<BudgetCardModel> cards = <BudgetCardModel>[].obs;
  final RxInt cashMonthly = 0.obs;
  final RxInt topayMonthly = 0.obs;
  final RxInt upcomingMonthly = 0.obs;
  final RxInt totalExpenses = 0.obs;
  final RxString uid = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCardData();
    listenToExpenses();
  }

  void fetchCardData() async {
    try {
      String userUID = FirebaseAuth.instance.currentUser!.uid;
      uid.value = userUID;

      var snapshot = await _firestore
          .collection('users')
          .doc(userUID)
          .collection('cards')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        var userData = doc.data();

        cashMonthly.value = userData['cash'] ?? 0;
        topayMonthly.value = userData['topay'] ?? 0;
        upcomingMonthly.value = userData['upcoming'] ?? 0;

        cards.clear();
        cards.addAll([
          BudgetCardModel(
            title: 'Cash',
            amount: cashMonthly.value - totalExpenses.value,
            icon: Icons.roofing,
            backgroundColor: Colors.blueAccent,
            imageAsset: 'assets/images/background.png',
            docId: doc.id,
          ),
          BudgetCardModel(
            title: 'Upcoming',
            amount: upcomingMonthly.value,
            icon: Icons.lightbulb_outline,
            backgroundColor: Colors.deepPurple,
            imageAsset: 'assets/images/black.png',
            docId: doc.id,
          ),
          BudgetCardModel(
            title: 'To-Pay',
            amount: topayMonthly.value,
            icon: Icons.account_balance_wallet,
            backgroundColor: Colors.orange,
            imageAsset: 'assets/images/blue.png',
            docId: doc.id,
          ),
        ]);
      } else {
        cards.clear();
        cashMonthly.value = 0;
        topayMonthly.value = 0;
        upcomingMonthly.value = 0;
      }
    } catch (e) {
      print("Error fetching card data: $e");
    }
  }

  void listenToExpenses() {
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(userUID)
        .collection('expenses')
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      int expensesSum = 0;
      for (var doc in querySnapshot.docs) {
        expensesSum += (doc['amount'] as num?)?.toInt() ?? 0;
      }
      totalExpenses.value = expensesSum;
      fetchCardData(); // Refresh card data with updated expense
    });
  }

  Future<void> createNewCard(String title) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .add({
      "title": 0,
    });

    fetchCardData();
  }



}