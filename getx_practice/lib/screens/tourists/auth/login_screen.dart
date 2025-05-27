import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:getx_practice/controllers/auth_controller.dart';
import 'package:getx_practice/screens/tourists/auth/register_screen.dart';
import 'package:getx_practice/screens/settings/settings_screen.dart';
import 'package:getx_practice/services/config_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authController = Get.find<AuthController>();
  final configService = ConfigService.instance;
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;
  Map<String, dynamic> loginData ={};  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 202, 202),
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: cons.maxHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Settings and Server URL Header
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Settings button and app title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Massar App',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(210, 172, 113, 1),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => const SettingsScreen());
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: Color.fromRGBO(210, 172, 113, 1),
                                  size: 28,
                                ),
                                tooltip: 'Server Settings',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Server URL indicator
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dns,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Server: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Obx(() => Text(
                                    configService.currentServerUrl,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const SettingsScreen());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(210, 172, 113, 1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Change',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Login Screen Header
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30,30,30,8),
                      child: Column(
                        children: [
                          //Email, Password and login button form
                          Form(
                            key: formkey,
                            child: Column(                              children: [
                                SizedBox(height: cons.maxHeight * 0.3),
                                //email field
                                TextFormField(
                                  controller: emailController,
                                  validator:
                                      (input) =>
                                          input == ''
                                              ? 'Please enter email'
                                              : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    hintText: 'Email',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                      
                                SizedBox(height: cons.maxHeight * 0.04),
                                //password field
                                Obx(
                                  () => TextFormField(
                                    controller: passwordController,
                                    obscureText: isObsecure.value,
                                    validator:
                                        (input) =>
                                            input == ''
                                                ? 'Please enter password'
                                                : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      suffixIcon: Obx(
                                        () => GestureDetector(
                                          onTap: () {
                                            isObsecure.value = !isObsecure.value;
                                          },
                                          child: Icon(
                                            isObsecure.value
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      hintText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                ),
                      
                                SizedBox(height: cons.maxHeight * 0.04),
                                //Login button
                                Material(
                                  color: Color.fromRGBO(210, 172, 113, 1),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      if(formkey.currentState!.validate()){
                                        loginData['email'] = emailController.text;
                                        loginData['password'] = passwordController.text;
                                        authController.login(loginData: loginData);
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: cons.maxHeight * 0.01),
                          
                          //register button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(RegisterScreen());
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Color.fromRGBO(210, 172, 113, 1),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
