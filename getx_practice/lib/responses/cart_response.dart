import 'package:getx_practice/models/cart.dart';

class CartResponse {
  final List<CartItem> items;
  final double total;

  CartResponse({
    required this.items,
    required this.total,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    var itemsFromJson = json['items'] as List;
    List<CartItem> items = itemsFromJson.map((i) => CartItem.fromJson(i)).toList();

    return CartResponse(
      items: items,
      total: json['total']?.toDouble() ?? 0.0,
    );
  }
}