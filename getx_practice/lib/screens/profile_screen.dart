import 'package:flutter/material.dart';
import 'package:getx_practice/models/attraction.dart';
import 'package:getx_practice/screens/attractions_screen.dart';
import 'widgets/profile_option.dart';
import 'package:get/get.dart';
import 'package:getx_practice/Styles/colors.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(AttractionsScreen());
          },
          icon: Icon(Icons.arrow_back, size: 33, color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile Picture and Name
            Center(
              child: Column(
                children:[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/taha.jpg'), // Add your image here
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ayman Taha',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'TahaYman@gmail.com',
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

