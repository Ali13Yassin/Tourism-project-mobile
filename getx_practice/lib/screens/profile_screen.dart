import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/controllers/auth_controller.dart';
import 'package:getx_practice/screens/attractions_screen.dart';
import 'widgets/profile_option.dart';
import 'package:getx_practice/Styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.user.value;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F6F1), Color(0xFFEDE3D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // AppBar replacement
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Styled back button (like in attraction_details_screen.dart)
                      CircleAvatar(
                        backgroundColor: icons,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: primary),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.settings, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Profile Card
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[700],
                        child: Text(
                          user.firstname.isNotEmpty ? user.firstname[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${user.firstname} ${user.lastname}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Profile Options
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: Column(
                    children: [
                      const ProfileOption(icon: Icons.bookmark, title: 'Saved Attractions'),
                      const Divider(),
                      const ProfileOption(icon: Icons.history, title: 'Ticket History'),
                      const Divider(),
                      const ProfileOption(icon: Icons.help, title: 'About Us'),
                      const Divider(),
                      ProfileOption(
                        icon: Icons.logout,
                        title: 'Log Out',
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
