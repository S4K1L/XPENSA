import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/task_manager_model.dart';

class TaskManagerController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var incompleteTasksCount = <String, int>{}.obs;

  var taskManagers = <TaskManagerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTaskManagers();
  }

  void fetchTaskManagers() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .orderBy('isPinned', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          taskManagers.value =
              snapshot.docs.map((doc) {
                final manager = TaskManagerModel.fromMap(doc.id, doc.data());
                listenToIncompleteTasks(manager.id);
                return manager;
              }).toList();
        });
  }

  Future<void> addTaskManager(TaskManagerModel manager) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .add(manager.toMap());
  }

  Future<void> updateTaskManager(TaskManagerModel updatedManager) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(updatedManager.id)
        .update(updatedManager.toMap());
  }

  Future<void> togglePin(String managerId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId);

    final doc = await docRef.get();

    if (doc.exists) {
      final current = TaskManagerModel.fromMap(doc.id, doc.data()!);
      final updated = current.copyWith(isPinned: !current.isPinned);

      await docRef.update(updated.toMap());
    }
  }

  Future<void> deleteTaskManager(String managerId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Delete tasks inside this manager first
    var tasksRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks');

    var snapshot = await tasksRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the manager document itself
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .delete();
  }

  void listenToIncompleteTasks(String managerId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .where('completed', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
          incompleteTasksCount[managerId] = snapshot.docs.length;
          incompleteTasksCount.refresh();
        });
  }
}
