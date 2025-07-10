import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:xpensa/views/task/task_list.dart';
import '../../controller/task_manager_controller.dart';
import '../../models/task_manager_model.dart';
import '../../utils/theme/color_theme.dart';
import '../../utils/widgets/task_manager_tile.dart';

class TaskManagersPage extends StatelessWidget {
  TaskManagersPage({super.key});

  final TaskManagerController controller = Get.put(TaskManagerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: const Text(
          "My Task Boards",
          style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: kWhiteColor),
            onPressed: () => _showCreateBoardDialog(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.fetchTaskManagers(),
        child: Obx(
          () =>
              controller.taskManagers.isEmpty
                  ? const Center(
                    child: Text(
                      "No task managers yet.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                  : ListView.builder(
                    itemCount: controller.taskManagers.length,
                    itemBuilder: (context, index) {
                      final manager = controller.taskManagers[index];
                      return BounceInRight(
                        child: TaskManagerTile(
                          manager: manager,
                          onTap: () {
                            Get.to(
                              () => TaskListPage(manager: manager),
                              transition: Transition.rightToLeft,
                            );
                          },
                          onMorePressed: () {
                            _showTaskManagerOptions(manager);
                          },
                          incompleteCount:
                              controller.incompleteTasksCount[manager.id] ?? 0,
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  void _showCreateBoardDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    Color selectedColor = kPrimaryColor;

    Get.defaultDialog(
      title: "Create New Board",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descController,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: selectedColor),
            onPressed: () {
              Get.defaultDialog(
                title: "Pick a Color",
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      selectedColor = color;
                    },
                  ),
                ),
                textConfirm: "Select",
                onConfirm: () {
                  Get.back();
                },
              );
            },
            child: const Text(
              "Pick Theme Color",
              style: TextStyle(color: kWhiteColor),
            ),
          ),
        ],
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        final manager = TaskManagerModel(
          id: '', // leave empty initially; Firestore doc ID will be assigned on add
          title: titleController.text.trim(),
          description: descController.text.trim(),
          colorHex:
              '#${selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
          createdAt: DateTime.now(),
          isPinned: false, // add this field
        );

        controller.addTaskManager(manager);
        Get.back();
      },
    );
  }

  void _showEditBoardDialog(TaskManagerModel manager) {
    final titleController = TextEditingController(text: manager.title);
    final descController = TextEditingController(text: manager.description);
    Color selectedColor = Color(
      int.parse(manager.colorHex.replaceFirst('#', '0xff')),
    );

    Get.defaultDialog(
      title: "Edit Board",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descController,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: selectedColor),
            onPressed: () {
              Get.defaultDialog(
                title: "Pick a Color",
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      selectedColor = color;
                    },
                  ),
                ),
                textConfirm: "Select",
                onConfirm: () {
                  Get.back();
                },
              );
            },
            child: const Text("Pick Theme Color"),
          ),
        ],
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        final updatedManager = manager.copyWith(
          title: titleController.text.trim(),
          description: descController.text.trim(),
          colorHex:
              '#${selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        );
        controller.updateTaskManager(updatedManager);
        Get.back();
      },
    );
  }

  void _confirmDelete(TaskManagerModel manager) {
    Get.defaultDialog(
      title: "Delete Board",
      middleText: "Are you sure you want to delete this board?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteTaskManager(manager.id);
        Get.back();
      },
    );
  }

  void _showTaskManagerOptions(TaskManagerModel manager) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.push_pin, color: kWhiteColor),
              title: Text(
                manager.isPinned ? "Unpin Board" : "Pin Board",
                style: TextStyle(color: kWhiteColor),
              ),
              onTap: () {
                Get.back();
                controller.togglePin(manager.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: kWhiteColor),
              title: Text("Edit Board", style: TextStyle(color: kWhiteColor)),
              onTap: () {
                Get.back();
                _showEditBoardDialog(manager);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete Board", style: TextStyle(color: kWhiteColor)),
              onTap: () {
                Get.back();
                _confirmDelete(manager);
              },
            ),
          ],
        ),
      ),
    );
  }
}
