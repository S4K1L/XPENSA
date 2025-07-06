import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../models/card_model.dart';

class CardDetailsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  RxInt cardBalance = 0.obs;

  late String userUID;
  late String cardDocId;
  late BudgetCardModel currentCard;

  @override
  void onInit() {
    super.onInit();
    userUID = FirebaseAuth.instance.currentUser!.uid;
  }

  void setCardDocId(String docId, BudgetCardModel card) {
    cardDocId = docId;
    currentCard = card;

    fetchTransactions(card.title);
    fetchCardBalance(card.title);
  }

  Future<void> fetchTransactions(String title) async {
    try {
      var snapshot = await _firestore
          .collection('users')
          .doc(userUID)
          .collection('cards')
          .doc(cardDocId)
          .collection('transactions')
          .where('cardTitle', isEqualTo: title)
          .orderBy('date', descending: true)
          .get();

      transactions.value = snapshot.docs
          .map((doc) => {
        'id': doc.id,
        'date': (doc['date'] as Timestamp).toDate(),
        'type': doc['type'] ?? '',
        'amount': (doc['amount'] as num).toDouble(),
        'cardTitle': doc['cardTitle'] ?? '',
      })
          .toList();
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  Future<void> fetchCardBalance(String title) async {
    try {
      final cardDocRef = _firestore
          .collection('users')
          .doc(userUID)
          .collection('cards')
          .doc(cardDocId);

      final docSnapshot = await cardDocRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        if (data == null) return;

        String fieldKey = _getFieldKey(title);
        int balance = (data[fieldKey] as num?)?.toInt() ?? 0;

        cardBalance.value = balance;
      }
    } catch (e) {
      print("Error fetching card balance: $e");
    }
  }

  Future<void> addBalance({
    required BudgetCardModel card,
    required String type,
    required int amount,
    required DateTime date,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userUID)
          .collection('cards')
          .doc(cardDocId)
          .collection('transactions')
          .add({
        'date': date,
        'type': type,
        'amount': amount,
        'cardTitle': card.title,
      });

      await adjustCardAmount(card, amount);
      await fetchTransactions(card.title);
      await fetchCardBalance(card.title);
    } catch (e) {
      print("Error adding transaction: $e");
    }
  }

  Future<void> deleteTransaction(
      BudgetCardModel card, String transactionId, int amount) async {
    try {
      await _firestore
          .collection('users')
          .doc(userUID)
          .collection('cards')
          .doc(cardDocId)
          .collection('transactions')
          .doc(transactionId)
          .delete();

      await adjustCardAmount(card, -amount);
      await fetchTransactions(card.title);
      await fetchCardBalance(card.title);
    } catch (e) {
      print("Error deleting transaction: $e");
    }
  }

  Future<void> adjustCardAmount(BudgetCardModel card, int delta) async {
    final cardDocRef = _firestore
        .collection('users')
        .doc(userUID)
        .collection('cards')
        .doc(cardDocId);

    final docSnapshot = await cardDocRef.get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data == null) return;

      String fieldKey = _getFieldKey(card.title);
      int current = (data[fieldKey] as num?)?.toInt() ?? 0;

      await cardDocRef.update({
        fieldKey: current + delta,
      });
    }
  }

  String _getFieldKey(String title) {
    switch (title) {
      case "Cash":
      case "Current Balance":
        return "cash";
      case "Upcoming":
        return "upcoming";
      case "To-Pay":
        return "topay";
      default:
        return "cash";
    }
  }
}
