import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/cart.dart';
import '../responses/cart_response.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var total = 0.0.obs;
  var isLoading = false.obs;
  var itemCount = 0.obs;

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8000/api'));

  Future<void> fetchCart() async {
    try {
      isLoading(true);
      final token = await GetStorage().read('login_token');
      
      final response = await _dio.get(
        '/cart',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final cartResponse = CartResponse.fromJson(response.data);
      cartItems.assignAll(cartResponse.items);
      total.value = cartResponse.total;
      itemCount.value = cartItems.length;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cart: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart({
    required int attractionId,
    required int ticketTypeId,
    required int quantity,
    required DateTime date,
    required String time,
  }) async {
    try {
      isLoading(true);
      final token = await GetStorage().read('login_token');

      await _dio.post(
        '/cart/add',
        data: {
          'attraction_id': attractionId,
          'ticket_type_id': ticketTypeId,
          'quantity': quantity,
          'date': date.toIso8601String(),
          'time': time,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      await fetchCart(); // Refresh cart after adding
      Get.snackbar('Success', 'Item added to cart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to cart: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCartItem({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      isLoading(true);
      final token = await GetStorage().read('login_token');

      await _dio.put(
        '/cart/$cartItemId',
        data: {
          'quantity': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      await fetchCart(); // Refresh cart after updating
      Get.snackbar('Success', 'Cart updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update cart: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    try {
      isLoading(true);
      final token = await GetStorage().read('login_token');

      await _dio.delete(
        '/cart/$cartItemId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      await fetchCart(); // Refresh cart after removing
      Get.snackbar('Success', 'Item removed from cart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkout() async {
    try {
      isLoading(true);
      final token = await GetStorage().read('login_token');

      final response = await _dio.post(
        '/cart/checkout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      cartItems.clear();
      total.value = 0.0;
      itemCount.value = 0;
      Get.snackbar('Success', response.data['message'] ?? 'Checkout successful');
    } catch (e) {
      Get.snackbar('Error', 'Failed to checkout: $e');
    } finally {
      isLoading(false);
    }
  }
}