import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_practice/controllers/auth_controller.dart';
import 'package:getx_practice/screens/attractions_screen.dart';
// import 'package:getx_practice/screens/splash_screen.dart';
import 'package:getx_practice/screens/tourists/auth/login_screen.dart';
import 'package:getx_practice/services/api.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized(); // Avoiding white screen in the beginning
  await GetStorage.init(); // Initialize GetStorage
  Api.intializeinterceptors(); // Initialize API interceptors
  Get.put(AuthController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Masar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AttractionsScreen(),
    );
  }
}

