import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GET;
import 'package:get_storage/get_storage.dart';



class Api {
  static final dio = Dio(
    BaseOptions(
    baseUrl: 'http://192.168.100.13:8000',
    receiveDataWhenStatusError: true,
    ),
  );


static void intializeinterceptors() {
    dio.interceptors.add(InterceptorsWrapper(      onRequest: (request, handler) async {
        // Add the token to the request headers if available
        var token = await GetStorage().read('login_token');
        
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        };

        // Only add Authorization header if token exists
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }

        request.headers.addAll(headers);
        
        print('${request.method} ${request.path}');
        print('Token: $token');
        print('Headers: ${request.headers}');

        return handler.next(request); // continue with the request
      },

      onResponse: (response, handler) {
        print('${response.data}');
        if(response.data['error']== 1) throw response.data['message'];
        return handler.next(response); // continue with the response
      },      onError: (error, handler) {
        if(GET.Get.isDialogOpen == true){
          GET.Get.back();
        } 

        // Handle 401 Unauthorized errors specifically
        if (error.response?.statusCode == 401) {
          GET.Get.snackbar(
            'Authentication Required',
            'Please log in to access this feature',
            snackPosition: GET.SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
          
          // Optionally navigate to login screen
          // GET.Get.offAllNamed('/login');
          
          return handler.next(error);
        }

        GET.Get.snackbar(
          'error'.tr,
          '${error.message}',
          snackPosition: GET.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 10),
        );
        
        return handler.next(error);
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

  // Cart Endpoints
  static Future<Response> getCart() async {
    return dio.get('/api/cart');
  }

  static Future<Response> addToCart({required Map<String, dynamic> cartData}) async {
    return dio.post('/api/cart/add', data: cartData);
  }

  static Future<Response> updateCartItem(int id, {required Map<String, dynamic> updateData}) async {
    return dio.put('/api/cart/$id', data: updateData);
  }

  static Future<Response> removeFromCart(int id) async {
    return dio.delete('/api/cart/$id');
  }

  static Future<Response> clearCart() async {
    return dio.delete('/api/cart');
  }

  static Future<Response> getCartCount() async {
    return dio.get('/api/cart/count');
  }

  static Future<Response> checkout({required Map<String, dynamic> checkoutData}) async {
    return dio.post('/api/cart/checkout', data: checkoutData);
  }

  // Ticket Endpoints
  static Future<Response> getTickets() async {
    return dio.get('/api/tickets');
  }

  static Future<Response> getTicket(String id) async {
    return dio.get('/api/tickets/$id');
  }

  static Future<Response> getTicketTypes() async {
    return dio.get('/api/ticket-types');
  }
  // QR Code scanning functionality
  static Future<Response> processQrCode({required String qrCode}) async {
    return dio.post('/api/qr-scan', data: {
      'qr_code': qrCode,
      'timestamp': DateTime.now().toIso8601String(),
      'device_info': {
        'platform': 'mobile',
        'app_version': '1.0.0',
      }
    });
  }

  static Future<Response> validateTicket({required String encryptedData}) async {
    return dio.post('/api/validate-ticket', data: {
      'encrypted_data': encryptedData,
    });
  }

}
