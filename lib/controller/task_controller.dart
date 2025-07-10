import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:xpensa/controller/task_manager_controller.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  final TaskManagerController controller = Get.put(TaskManagerController());
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final RxList<TaskModel> tasks = <TaskModel>[].obs;

  /// Loads all tasks under a given manager.
  void loadTasks(String managerId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .orderBy('createdAt')
        .snapshots()
        .listen((snapshot) {
          tasks.value =
              snapshot.docs.map((doc) {
                return TaskModel.fromMap(doc.id, doc.data());
              }).toList();
        });
  }

  /// Adds a new task under a specific manager.
  Future<void> addTask(TaskModel task, String managerId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .add(task.toMap());
  }

  /// Updates an existing task under a manager.
  Future<void> updateTask(TaskModel task, String managerId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  /// Deletes a task from a manager.
  Future<void> deleteTask(String taskId, String managerId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  /// Toggles a task's `completed` status and updates Firestore.
  Future<void> toggleTaskCompleted(String managerId, String taskId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final taskRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('taskManagers')
        .doc(managerId)
        .collection('tasks')
        .doc(taskId);

    final snapshot = await taskRef.get();
    if (!snapshot.exists) return;

    final current = snapshot.data()!;
    final isCompleted = current['completed'] as bool? ?? false;

    await taskRef.update({'completed': !isCompleted});
    controller.listenToIncompleteTasks(managerId);
  }
}
