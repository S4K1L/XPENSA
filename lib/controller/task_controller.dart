import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';

class TaskController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var tasks = <TaskModel>[].obs;

  void loadTasks(String managerId) {
    String userId = _auth.currentUser!.uid;
    _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .orderBy('createdAt')
        .snapshots()
        .listen((snapshot) {
      tasks.value = snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addTask(TaskModel task, String managerId) async {
    String userId = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .add(task.toMap());
  }

  Future<void> updateTask(TaskModel task, String managerId) async {
    String userId = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String taskId, String managerId) async {
    String userId = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
