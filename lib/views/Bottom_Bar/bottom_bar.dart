import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../utils/Theme/color_theme.dart';
import '../add_expenses.dart';
import '../home_page.dart';
import '../monthly_expense_page.dart';
import '../profile.dart';
import '../task/task_manager.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<CustomBottomBar> with TickerProviderStateMixin {
  int indexColor = 0;
  final List<Widget> screens = [
    HomePage(),
    TaskManagersPage(),
    MonthlyExpensePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // so the FAB can float above the blurred bar
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeInOut,
        child: screens[indexColor],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomAppBar(
          color: kPrimaryColor,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 20,
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimaryColor.withOpacity(0.95), kPrimaryColor.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnimatedItem(Icons.roofing, "Home", 0),
                  _buildAnimatedItem(Icons.task_alt, "Task", 1),
                  const SizedBox(width: 40),
                  _buildAnimatedItem(Icons.stacked_line_chart, "Analysis", 2),
                  _buildAnimatedItem(Icons.person, "Profile", 3),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=>AddExpenses(),transition: Transition.rightToLeft);
        },
        backgroundColor: kPrimaryColor,
        shape: const CircleBorder(),
        elevation: 10,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ).animate().scaleXY(end: 1.1).then().scaleXY(end: 1.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildAnimatedItem(IconData icon, String label, int index) {
    final isSelected = index == indexColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          indexColor = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isSelected ? Colors.white.withOpacity(0.6) : Colors.grey[400],
                size: 24,
                shadows: isSelected
                    ? [Shadow(color: Colors.white.withOpacity(0.9), blurRadius: 12)]
                    : [],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1.0 : 0.0,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
