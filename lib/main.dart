import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/screens/main_screen.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API service
  final apiService = ApiService(baseUrl: 'https://your-api-endpoint.com/api');
  
  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatefulWidget {
  final ApiService apiService;
  
  const MyApp({Key? key, required this.apiService}) : super(key: key);
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: Constants.lightTheme,
      darkTheme: Constants.darkTheme,
      home: MainScreen(apiService: widget.apiService),
    );
  }
}