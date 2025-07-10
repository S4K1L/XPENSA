import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:xpensa/services/notification_service.dart';
import '../../controller/task_controller.dart';
import '../../models/task_manager_model.dart';
import '../../models/task_model.dart';
import '../../utils/Theme/color_theme.dart';

class TaskListPage extends StatelessWidget {
  final TaskManagerModel manager;

  TaskListPage({super.key, required this.manager});

  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    controller.loadTasks(manager.id);

    return Scaffold(
      backgroundColor: Color(
        int.parse(manager.colorHex.replaceFirst('#', '0xff')),
      ).withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: kWhiteColor),
        ),
        elevation: 0,
        title: Text(
          manager.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: kWhiteColor),
            onPressed: () => _showTaskDialog(controller, managerId: manager.id),
          ),
        ],
      ),
      body: Obx(
        () =>
            controller.tasks.isEmpty
                ? const Center(
                  child: Text(
                    "No tasks here yet.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
                : ListView.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];
                    return GestureDetector(
                      onTap:
                          () => _showTaskDialog(
                            controller,
                            task: task,
                            managerId: manager.id,
                          ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color:
                              task.completed
                                  ? Colors.green.withOpacity(0.6)
                                  : Colors.grey.shade800.withOpacity(0.6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              task.completed
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color:
                                  task.completed ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      decoration:
                                          task.completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                      decorationColor: Colors.white,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      decoration:
                                          task.completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                      decorationColor: Colors.white70,
                                      decorationThickness: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.deleteTask(task.id, manager.id);
                                Get.snackbar(
                                  "Deleted",
                                  "Task deleted successfully.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }

  void _showTaskDialog(
    TaskController controller, {
    TaskModel? task,
    required String managerId,
  }) {
    final titleController = TextEditingController(text: task?.title ?? "");
    final descController = TextEditingController(text: task?.description ?? "");
    final completed = (task?.completed ?? false).obs;

    Get.dialog(
      Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task == null ? "Add Task" : "Edit Task",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "Task Title",
                      prefixIcon: Icon(Icons.title, color: kPrimaryColor),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      prefixIcon: Icon(Icons.description, color: kPrimaryColor),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SwitchListTile(
                      value: completed.value,
                      onChanged: (val) => completed.value = val,
                      title: const Text(
                        "Completed?",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser == null) {
                              Get.back();
                              return;
                            }

                            if (task == null) {
                              // create new doc
                              final newDoc =
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.uid)
                                      .collection('task_manager')
                                      .doc(managerId)
                                      .collection('tasks')
                                      .doc();

                              final newTask = TaskModel(
                                id: newDoc.id,
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                                completed: completed.value,
                                createdAt: DateTime.now(),
                              );
                              controller.addTask(newTask, managerId);
                              Get.back();
                            } else {
                              final updatedTask = TaskModel(
                                id: task.id,
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                                completed: completed.value,
                                createdAt: task.createdAt,
                              );
                              controller.updateTask(updatedTask, managerId);
                              Get.back();
                            }
                          },
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
        ),
      ),
    );
  }
}
