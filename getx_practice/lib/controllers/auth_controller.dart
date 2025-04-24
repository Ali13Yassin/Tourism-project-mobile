import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' as GET;
import 'package:get_storage/get_storage.dart';
import 'package:getx_practice/controllers/base_controller.dart';
import 'package:getx_practice/models/user.dart';
import 'package:getx_practice/responses/user_response.dart';
import 'package:getx_practice/screens/tourists/attractions_screen.dart'; 
import 'package:getx_practice/services/api.dart';

class AuthController extends GetxController with BaseController {
  var user = User().obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    redirect();
    super.onInit();
  }

  Future<void> redirect() async {
    var token = await GetStorage().read('login_token');

    if (token != null) {
      isLoggedIn.value = true;
      Get.offAll(() => AttractionsScreen()); 
    }
  }

  Future<void> login({required Map<String, dynamic> loginData}) async {
    try {
      showLoading();

      var response = await Api.login(loginData: loginData);

      if (response.data['error'] != 0) {
        throw response.data['message'] ?? 'Login failed';
      }

      var userResponse = UserResponse.fromJson(response.data);

      user.value = userResponse.user;
      isLoggedIn.value = true;

      await GetStorage().write('login_token', userResponse.token);

      Get.offAll(() => AttractionsScreen()); 
    } catch (e) {
      print('Login error: $e');
      GET.Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      hideLoading();
    }
  }
}