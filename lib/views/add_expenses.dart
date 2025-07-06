import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_expense_controller.dart';
import '../utils/Theme/color_theme.dart';
import '../utils/widgets/myTextField.dart';

class AddExpenses extends StatelessWidget {
  final AddExpenseController controller = Get.put(AddExpenseController());
  AddExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new, color: kTextWhiteColor),
          ),
          const Spacer(),
          const Text(
            'Add Expense',
            style: TextStyle(color: kTextWhiteColor, fontSize: 18),
          ),
          const Spacer(),
          const Icon(Icons.more_horiz_rounded, color: kTextWhiteColor),
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/black.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Store your expenses with us',
                        style: TextStyle(
                          color: kTextWhiteColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                    color: kTextWhiteColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_drop_down, size: 30),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () => _showCategoryPicker(context, controller),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(() {
                                      return controller
                                              .selectedCategory
                                              .value
                                              .isNotEmpty
                                          ? Icon(
                                            controller.categoryIcons[controller
                                                .categories
                                                .indexOf(
                                                  controller
                                                      .selectedCategory
                                                      .value,
                                                )],
                                            color: Colors.blue,
                                          )
                                          : const SizedBox.shrink();
                                    }),
                                    const SizedBox(width: 8),
                                    Obx(
                                      () => Text(
                                        controller
                                                .selectedCategory
                                                .value
                                                .isNotEmpty
                                            ? controller.selectedCategory.value
                                            : 'Category',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: controller.nameController,
                          labelText: "Expenses name",
                          obscureText: false,
                          focusNode: FocusNode(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, color: kPrimaryColor),
                            iconSize: 20,
                            onPressed: () => controller.nameController.clear(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: controller.amountController,
                          labelText: "৳ Enter amount",
                          obscureText: false,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, color: kPrimaryColor),
                            iconSize: 20,
                            onPressed:
                                () => controller.amountController.clear(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kPrimaryColor,
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (controller
                                      .selectedCategory
                                      .value
                                      .isNotEmpty &&
                                  controller.amountController.text.isNotEmpty) {
                                await controller.saveExpense();
                                controller.clearInputs();
                              }
                            },
                            child: const Text(
                              'Expenses',
                              style: TextStyle(
                                color: kTextWhiteColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryPicker(
    BuildContext context,
    AddExpenseController controller,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem:
                          controller.selectedCategory.value.isNotEmpty
                              ? controller.categories.indexOf(
                                controller.selectedCategory.value,
                              )
                              : 0,
                    ),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      controller.selectedCategory.value =
                          controller.categories[index]; // Update observable
                    },
                    children: List<Widget>.generate(
                      controller.categories.length,
                      (int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.categoryIcons[index],
                              color: Colors.black,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              controller.categories[index],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                CupertinoButton(
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
