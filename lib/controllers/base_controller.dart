import 'package:flutter/material.dart';
import 'package:get/get.dart';


mixin BaseController {
  void showLoading(){
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 150),
        backgroundColor: Color.fromRGBO(210, 172, 113, 1),
        child: Container(
          height: 80,
          width: 5,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      barrierDismissible: false,
      );
  }

  void hideLoading(){
    if(Get.isDialogOpen!){
      Get.back();
    }
  }

}