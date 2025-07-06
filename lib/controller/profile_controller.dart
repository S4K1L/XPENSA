// lib/controller/profile_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:xpensa/controller/card_details_controller.dart';
import 'package:xpensa/controller/expense_controller.dart';
import 'package:xpensa/controller/master_card_controller.dart';
import 'package:xpensa/views/Authentication/login.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userData = <String, dynamic>{}.obs;
  var totalBudget = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    calculateTotalBudget();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading(true);
      String userUID = _auth.currentUser!.uid;
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(userUID).get();
      userData.value = snapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> calculateTotalBudget() async {
    try {
      isLoading(true);
      String userUID = _auth.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userUID)
          .collection('cards')
          .get();

      double total = 0.0;
      for (var doc in snapshot.docs) {
        total += (doc['amount'] ?? 0).toDouble();
      }
      totalBudget.value = total;
    } catch (e) {
      print("Error calculating budget: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    // Clear local observables
    userData.value = {};
    totalBudget.value = 0.0;

    // Optionally delete controller entirely
    Get.delete<ProfileController>();
    Get.delete<MasterCardController>();
    Get.delete<ExpenseController>();
    Get.delete<CardDetailsController>();

    Get.offAll(()=> LoginScreen());
  }


  Future<void> deleteAccount() async {
    try {
      isLoading(true);
      User? user = _auth.currentUser;
      String userUID = user!.uid;

      await _firestore.collection('users').doc(userUID).delete();
      await user.delete();

      Get.offAllNamed('/login');
      Get.snackbar("Success", "Account deleted successfully");
    } catch (e) {
      print("Error deleting account: $e");
      Get.snackbar("Error", "Could not delete account");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteUserData() async {
    try {
      isLoading(true);

      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No logged in user.");
      }
      String userUID = user.uid;

      final userDocRef = _firestore.collection('users').doc(userUID);

      // Delete cards
      var cardsSnapshot = await userDocRef.collection('cards').get();
      for (var doc in cardsSnapshot.docs) {
        await doc.reference.update({
          'cash': 0,
          'topay': 0,
          'upcoming': 0,
        });
      }

      // Delete expenses
      var expensesSnapshot = await userDocRef.collection('expenses').get();
      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete taskManagers
      var tasksSnapshot = await userDocRef.collection('taskManagers').get();
      for (var doc in tasksSnapshot.docs) {
        await doc.reference.delete();
      }


      // Clean up state and navigate away
      userData.value = {};
      totalBudget.value = 0.0;

      Get.offAll(() => LoginScreen());
      Get.snackbar("Success", "Account deleted and data wiped.");
    } catch (e) {
      print("Error deleting user data: $e");
      Get.snackbar("Error", "Failed to delete your data.");
    } finally {
      isLoading(false);
    }
  }


}
