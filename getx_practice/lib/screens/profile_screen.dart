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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const AttractionsScreen());
          },
          icon: const Icon(Icons.arrow_back, size: 33, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  // Profile circle with first letter of first name
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFD2AC71),
                    child: Text(
                      user.firstname.isNotEmpty ? user.firstname[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Dynamic name
                  Text(
                    '${user.firstname} ${user.lastname}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  // Dynamic email
                  Text(
                    user.email,
                    style: TextStyle(color: secondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Profile Options
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: const [
                  ProfileOption(icon: Icons.person, title: 'My Account'),
                  Divider(),
                  ProfileOption(icon: Icons.bookmark, title: 'Saved Attractions'),
                  Divider(),
                  ProfileOption(icon: Icons.history, title: 'Ticket History'),
                  Divider(),
                  ProfileOption(icon: Icons.settings, title: 'Settings'),
                  Divider(),
                  ProfileOption(icon: Icons.help, title: 'About Us'),
                  Divider(),
                  ProfileOption(icon: Icons.logout, title: 'Log Out', iconColor: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
