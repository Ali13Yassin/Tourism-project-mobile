class CartItem {
  final int id;
  final String userId;
  final String attractionId;
  final int ticketTypeId;
  final int quantity;
  final String date;
  final String time;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Additional properties for UI display
  final String? attractionTitle;
  final String? attractionSlug;
  final double? attractionPrice;
  final double? attractionRating;
  final int? reviewCount;
  final String? attractionDescription;
  final String? attractionImage;
  final String? ticketTypeName;
  final int? cartItemId; // This is used for the cart item ID in some contexts
  final double? subtotal;

  CartItem({
    required this.id,
    required this.userId,
    required this.attractionId,
    required this.ticketTypeId,
    required this.quantity,
    required this.date,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
    required this.cartItemId,
    this.attractionTitle,
    this.attractionSlug,
    this.attractionPrice,
    this.attractionRating,
    this.reviewCount,
    this.attractionDescription,
    this.attractionImage,
    this.ticketTypeName,
    this.subtotal,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? json['cart_item_id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      attractionId: json['attraction_id']?.toString() ?? '',
      ticketTypeId: json['ticket_type_id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      attractionTitle: json['title'],
      attractionSlug: json['slug'],
      attractionPrice: json['price']?.toDouble(),
      attractionRating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      attractionDescription: json['description'],
      attractionImage: json['image'],
      ticketTypeName: json['ticket_type'],
      cartItemId: json['cart_item_id'] ?? json['id'],
      subtotal: json['subtotal']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'attraction_id': attractionId,
      'ticket_type_id': ticketTypeId,
      'quantity': quantity,
      'date': date,
      'time': time,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    int? id,
    String? userId,
    String? attractionId,
    int? ticketTypeId,
    int? quantity,
    String? date,
    String? time,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? attractionTitle,
    String? attractionSlug,
    double? attractionPrice,
    double? attractionRating,
    int? reviewCount,
    String? attractionDescription,
    String? attractionImage,
    String? ticketTypeName,
    int? cartItemId,
    double? subtotal,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      attractionId: attractionId ?? this.attractionId,
      ticketTypeId: ticketTypeId ?? this.ticketTypeId,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attractionTitle: attractionTitle ?? this.attractionTitle,
      attractionSlug: attractionSlug ?? this.attractionSlug,
      attractionPrice: attractionPrice ?? this.attractionPrice,
      attractionRating: attractionRating ?? this.attractionRating,
      reviewCount: reviewCount ?? this.reviewCount,
      attractionDescription: attractionDescription ?? this.attractionDescription,
      attractionImage: attractionImage ?? this.attractionImage,
      ticketTypeName: ticketTypeName ?? this.ticketTypeName,
      cartItemId: cartItemId ?? this.cartItemId,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
