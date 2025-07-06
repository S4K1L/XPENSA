import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/profile_controller.dart';
import '../Theme/color_theme.dart';

class ProfileButtons extends StatelessWidget {
  ProfileButtons({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(
            context,
            label: "My Account",
            icon: Icons.account_circle_outlined,
            onTap: () => _showUserDetails(context),
          ),
          const SizedBox(height: 20),
          _buildButton(
            context,
            label: "Erase Data",
            icon: Icons.phonelink_erase,
            onTap: () => _confirmEraseData(context),
          ),
          const SizedBox(height: 20),
          _buildButton(
            context,
            label: "Deactivate Account",
            icon: Icons.delete_outline,
            onTap: () => _confirmDeleteAccount(context),
          ),
          const SizedBox(height: 20),
          _buildButton(
            context,
            label: "Logout",
            icon: Icons.logout,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigoAccent.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(100),
            topLeft: Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.shade200.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,color: kWhiteColor,),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    _showConfirmDialog(context, "Are you sure you want to logout?", () {
      controller.signOut();
    });
  }

  void _confirmDeleteAccount(BuildContext context) {
    _showConfirmDialog(
      context,
      "Are you sure you want to delete your account?",
          () {
        controller.deleteAccount();
      },
    );
  }

  void _confirmEraseData(BuildContext context) {
    _showConfirmDialog(
      context,
      "Are you sure you want to erase your data?",
          () {
        controller.deleteUserData();
      },
    );
  }

  void _showConfirmDialog(
      BuildContext context,
      String message,
      VoidCallback onYes,
      ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text("Confirmation"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              Get.back();
              onYes();
            },
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context) {
    final userData = controller.userData;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
        title: const Text("User Details"),
        content: Text(
          "Name: ${userData['name']}\nEmail: ${userData['email']}\nPassword: ${userData['password']}",
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
