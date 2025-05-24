class CartItem {
  final int id;
  final int attractionId;
  final String attractionName;
  final String attractionImage;
  final int ticketTypeId;
  final String ticketTypeName;
  final int quantity;
  final DateTime date;
  final String time;
  final double price;
  final double subtotal;
  final double? rating;
  final int? reviewCount;

  CartItem({
    required this.id,
    required this.attractionId,
    required this.attractionName,
    required this.attractionImage,
    required this.ticketTypeId,
    required this.ticketTypeName,
    required this.quantity,
    required this.date,
    required this.time,
    required this.price,
    required this.subtotal,
    this.rating,
    this.reviewCount,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      attractionId: json['attraction_id'],
      attractionName: json['attraction_name'] ?? '',
      attractionImage: json['attraction_image'] ?? '',
      ticketTypeId: json['ticket_type_id'],
      ticketTypeName: json['ticket_type_name'] ?? '',
      quantity: json['quantity'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      price: json['price']?.toDouble() ?? 0.0,
      subtotal: json['subtotal']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'],
    );
  }
}