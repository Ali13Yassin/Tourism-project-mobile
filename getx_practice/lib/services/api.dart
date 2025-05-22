import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GET;
import 'package:get_storage/get_storage.dart';



class Api {
  static final dio = Dio(
    BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    receiveDataWhenStatusError: true,
    ),
  );


static void intializeinterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) async {
        // Add the token to the request headers if available
        var token = await GetStorage().read('login_token');
        
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Autherization': 'Bearer ${token}'
        };

        request.headers.addAll(headers);
        
        print('${request.method} ${request.path}');
        print('${request.headers}');

        return handler.next(request); // continue with the request
      },

      onResponse: (response, handler) {
        print('${response.data}');
        if(response.data['error']== 1) throw response.data['message'];
        return handler.next(response); // continue with the response
      },

      onError: (error, handler) {
        if(GET.Get.isDialogOpen == true){
          GET.Get.back();
        } 

        GET.Get.snackbar(
          'error'.tr,
          '${error.message}',
          snackPosition: GET.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 10),
        );
      },
      
      
    ));
  }



  static Future<Response> login({required Map<String, dynamic> loginData}) async{
    return dio.post('/api/login',data: loginData);
  }


  static Future<Response> getAttractions() async {
    return dio.get('/api/get-attractions');
  }

  static Future<Response> getAttractionReviews(String slug) async {
    return dio.get('/api/attractions/$slug/reviews');
  }

  static Future<Response> getArticleById(int id) async {
    return dio.get('/api/articles/$id');
  }

  static Future<Response> getAllArticles() async {
  return dio.get('/api/articles');
}


}
