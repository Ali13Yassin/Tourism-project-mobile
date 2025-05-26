import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'qr_code_screen.dart'; // Make sure this file contains your QrCodeScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Attraction Staff Home',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromRGBO(210, 172, 113, 1),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to the QR Scanner App!',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(QrCodeScreen());
        },
        icon: const Icon(Icons.qr_code),
        label: const Text('Scan'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}