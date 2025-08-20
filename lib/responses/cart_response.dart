import '../models/cart_item.dart';

class CartResponse {
  final bool success;
  final List<CartItem> attractions;
  final double total;
  final String? message;

  CartResponse({
    required this.success,
    required this.attractions,
    required this.total,
    this.message,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final attractionsList = data['attractions'] as List? ?? [];
    
    return CartResponse(
      success: json['success'] ?? false,
      attractions: attractionsList.map((item) => CartItem.fromJson(item)).toList(),
      total: (data['total'] ?? 0).toDouble(),
      message: json['message'],
    );
  }
}

class CartItemResponse {
  final bool success;
  final CartItem cartItem;
  final String? message;

  CartItemResponse({
    required this.success,
    required this.cartItem,
    this.message,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final cartItemData = data['cart_item'] ?? {};
    
    return CartItemResponse(
      success: json['success'] ?? false,
      cartItem: CartItem.fromJson(cartItemData),
      message: json['message'],
    );
  }
}

class CartCountResponse {
  final bool success;
  final int count;

  CartCountResponse({
    required this.success,
    required this.count,
  });

  factory CartCountResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    
    return CartCountResponse(
      success: json['success'] ?? false,
      count: data['count'] ?? 0,
    );
  }
}
