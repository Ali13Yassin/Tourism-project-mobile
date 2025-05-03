import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Text('Massar App',style: TextStyle(fontSize: 25,color: Colors.black),
            ),
            SizedBox(height: 20,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}