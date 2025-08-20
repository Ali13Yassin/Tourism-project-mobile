import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/base_controller.dart';
import '../models/cart_item.dart';
import '../models/ticket_type.dart';
import '../responses/cart_response.dart';
import '../responses/ticket_type_response.dart';
import '../responses/ticket_response.dart';
import '../services/api.dart';

class CartController extends GetxController with BaseController {
  var cartItems = <CartItem>[].obs;
  var ticketTypes = <TicketType>[].obs;
  var isLoading = false.obs;
  var isCheckingOut = false.obs;
  var cartCount = 0.obs;
  var cartTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
    fetchTicketTypes();
  }

  // Check if user is authenticated
  bool get isAuthenticated {
    final storage = GetStorage();
    final token = storage.read('login_token');
    return token != null;
  }  
  
  Future<void> fetchCart() async {
    try {
      // Only fetch cart if user is authenticated
      if (!isAuthenticated) {
        cartItems.clear();
        cartTotal.value = 0.0;
        cartCount.value = 0;
        return;
      }

      isLoading(true);
      final response = await Api.getCart();
      final cartResponse = CartResponse.fromJson(response.data);
      cartItems.value = cartResponse.attractions;
      cartTotal.value = cartResponse.total;
      cartCount.value = cartResponse.attractions.length;
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('404')) {
        // Cart not found or empty - this is normal for new users
        cartItems.clear();
        cartTotal.value = 0.0;
        cartCount.value = 0;
        print('Cart not found - initializing empty cart');
      } else {
        Get.snackbar('Error', 'Failed to load cart: ${e.toString()}');
        print('Cart fetch error: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTicketTypes() async {
    try {
      final response = await Api.getTicketTypes();
      final ticketTypeResponse = TicketTypeResponse.fromJson(response.data);
      ticketTypes.value = ticketTypeResponse.ticketTypes;
    } catch (e) {
      print('Ticket types fetch error: $e');
    }
  }
  Future<void> addToCart({
    required int attractionId,
    required String date,
    required String time,
    required int quantity,
    required int ticketTypeId,
  }) async {
    try {
      // Check authentication first
      if (!isAuthenticated) {
        Get.snackbar(
          'Authentication Required',
          'Please log in to add items to your cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      showLoading();
      
      final cartData = {
        'attraction_id': attractionId,
        'date': date,
        'time': time,
        'quantity': quantity,
        'ticket_type_id': ticketTypeId,
      };      await Api.addToCart(cartData: cartData);
      
      Get.snackbar(
        'Success',
        'Item added to cart successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh cart after adding
      await fetchCart();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add to cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Add to cart error: $e');
    } finally {
      hideLoading();
    }
  }  Future<void> updateCartItem(int cartItemId, {
    int? quantity,
    String? date,
    String? time,
    int? ticketTypeId,
  }) async {
    try {
      showLoading();

      final updateData = <String, dynamic>{};
      if (quantity != null) updateData['quantity'] = quantity;
      if (date != null) updateData['date'] = date;
      if (time != null) updateData['time'] = time;
      if (ticketTypeId != null) updateData['ticket_type_id'] = ticketTypeId;

      await Api.updateCartItem(cartItemId, updateData: updateData);
      
      Get.snackbar(
        'Success',
        'Cart updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh cart after updating
      await fetchCart();
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('404')) {
        Get.snackbar(
          'Item Not Found',
          'The cart item no longer exists. Refreshing cart...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        // Remove item from local cart and refresh
        cartItems.removeWhere((item) => item.id == cartItemId);
        await fetchCart();
      } else if (e.toString().contains('401')) {
        Get.snackbar(
          'Authentication Error',
          'Please log in again to update cart items.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update cart: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      print('Update cart error: $e');
    } finally {
      hideLoading();
    }
  }
  Future<void> removeFromCart(int cartItemId) async {
    try {
      showLoading();
      
      await Api.removeFromCart(cartItemId);
      
      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh cart after removing
      await fetchCart();
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('404')) {
        Get.snackbar(
          'Item Not Found',
          'The cart item was already removed. Refreshing cart...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        // Remove from local cart and refresh
        cartItems.removeWhere((item) => item.cartItemId == cartItemId);
        await fetchCart();
      } else if (e.toString().contains('401')) {
        Get.snackbar(
          'Authentication Error',
          'Please log in again to remove cart items.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove from cart: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      print('Remove from cart error: $e');
    } finally {
      hideLoading();
    }
  }
  Future<void> clearCart() async {
    try {
      showLoading();
      
      await Api.clearCart();
      
      // Clear local data immediately without making another API call
      cartItems.clear();
      cartTotal.value = 0.0;
      cartCount.value = 0;
      
      Get.snackbar(
        'Success',
        'Cart cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('404') || e.toString().contains('401')) {
        // Cart was already empty or user not authenticated
        cartItems.clear();
        cartTotal.value = 0.0;
        cartCount.value = 0;
        Get.snackbar(
          'Info',
          'Cart is already empty',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to clear cart: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      print('Clear cart error: $e');
    } finally {
      hideLoading();
    }
  }

  Future<void> getCartCount() async {
    try {
      final response = await Api.getCartCount();
      final countData = response.data['data'] ?? {};
      cartCount.value = countData['count'] ?? 0;
    } catch (e) {
      print('Cart count error: $e');
    }
  }
  Future<void> checkout({
    required String phoneNumber,
  }) async {
    try {
      isCheckingOut(true);
      
      final checkoutData = {
        'PhoneNumber': phoneNumber
      };

      final response = await Api.checkout(checkoutData: checkoutData);
      print('Checkout response: ${response.data}');
      final checkoutResponse = CheckoutResponse.fromJson(response.data);

      // Clear cart after successful checkout
      cartItems.clear();
      cartTotal.value = 0.0;
      cartCount.value = 0;
      
      Get.snackbar(
        'Success',
        'Checkout successful! ${checkoutResponse.ticketsCreated} tickets created.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Navigate to tickets screen or show success dialog
      Get.dialog(
        AlertDialog(
          title: const Text('Checkout Successful!'),
          content: Text('${checkoutResponse.ticketsCreated} tickets have been created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                // You can navigate to tickets screen here if needed
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Checkout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Checkout error: $e');
    } finally {
      isCheckingOut(false);
    }
  }
  // Helper method to increment quantity
  void incrementQuantity(int cartItemId) {
    try {
      final item = cartItems.firstWhere((item) => item.cartItemId == cartItemId);
      print(cartItemId);
      updateCartItem(cartItemId, quantity: item.quantity + 1);
    } catch (e) {
      print('Item not found in cart: $cartItemId');
      fetchCart(); // Refresh cart if item not found
    }
  }

  // Helper method to decrement quantity
  void decrementQuantity(int cartItemId) {
    try {
      final item = cartItems.firstWhere((item) => item.cartItemId == cartItemId);
      if (item.quantity > 1) {
        updateCartItem(cartItemId, quantity: item.quantity - 1);
      } else {
        removeFromCart(cartItemId);
      }
    } catch (e) {
      print('Item not found in cart: $cartItemId');
      fetchCart(); // Refresh cart if item not found
    }
  }

  // Get ticket type name by ID
  String getTicketTypeName(int ticketTypeId) {
    try {
      final ticketType = ticketTypes.firstWhere((type) => type.id == ticketTypeId);
      return ticketType.title;
    } catch (e) {
      return 'Unknown';
    }
  }
}
