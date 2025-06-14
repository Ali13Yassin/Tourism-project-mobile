import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_practice/controllers/auth_controller.dart';
import 'package:getx_practice/services/api.dart';
import 'package:getx_practice/services/config_service.dart';
import 'package:getx_practice/screens/tourists/auth/login_screen.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized(); // Avoiding white screen in the beginning
  await GetStorage.init(); // Initialize GetStorage
  
  // Initialize ConfigService first
  Get.put(ConfigService());
  
  // Initialize API with configurable URL
  Api.initializeDio();
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
      title: 'Massar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

