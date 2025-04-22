// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' as GET;
// Removed the unnecessary prefix import
import 'package:get_storage/get_storage.dart';
import 'package:getx_practice/controllers/base_controller.dart';
import 'package:getx_practice/models/user.dart';
import 'package:getx_practice/responses/user_response.dart';
import 'package:getx_practice/screens/tourists/welcome_screen.dart';
import 'package:getx_practice/services/api.dart';

class AuthController extends GetxController with BaseController{

    var user = User().obs;
    var isLoggedIn = false.obs;

  @override
  void onInit() {

    redirect();
    super.onInit();
  }

  Future<void> redirect() async{
    var token = await GetStorage().read('login_token');

    if(token != null){
      isLoggedIn.value = true;
    }
    
    
    // Future.delayed(Duration(seconds: 5)).then((value){  //Just For Testing Purpose

      // Get.to(
      // WelcomeScreen(),
      // preventDuplicates: false,
      // );

    // }).catchError((error){
    //   print('${error.toString()}');

    // });
    }


    // Future<void> login({required Map<String, dynamic> loginData}) async{
    //   showLoading();
    //   var response = await Api.login(loginData: loginData);
    //   var userResponse = UserResponse.fromJson(response.data);
    //   await GetStorage().write('login_token', userResponse.token);
    //   user.value = userResponse.user;
    //   isLoggedIn.value = true;  
    //   hideLoading();
    //   Get.to(WelcomeScreen());
    // }


    Future<void> login({required Map<String, dynamic> loginData}) async {
      try {
        showLoading();

        var response = await Api.login(loginData: loginData);

        // ✅ Check for error flag from the backend
        if (response.data['error'] != 0) {
          throw response.data['message'] ?? 'Login failed';
        }

        var userResponse = UserResponse.fromJson(response.data);

        user.value = userResponse.user;
        isLoggedIn.value = true;

        await GetStorage().write('login_token', userResponse.token);

        Get.offAll(() => WelcomeScreen());
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
        hideLoading(); // ✅ Always hide loading spinner
      }
}

}
