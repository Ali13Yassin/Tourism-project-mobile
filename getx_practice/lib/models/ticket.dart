class Ticket {
  final int id;
  final int ticketId;
  final String title;
  final String description;
  final String image;
  final String location;
  final double price;
  final String category;
  final int quantity;
  final String date;
  final String time;
  final String ticketType;
  final String phone;
  final double subtotal;
  final DateTime bookingTime;
  final String state;
  final double? rating;
  final int? reviewCount;
  final List<String>? gallery;
  final Map<String, dynamic>? features;

  Ticket({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.description,
    required this.image,
    required this.location,
    required this.price,
    required this.category,
    required this.quantity,
    required this.date,
    required this.time,
    required this.ticketType,
    required this.phone,
    required this.subtotal,
    required this.bookingTime,
    required this.state,
    this.rating,
    this.reviewCount,
    this.gallery,
    this.features,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] ?? 0,
      ticketId: json['ticket_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 1,
      date: json['date'] ?? '',
      time: json['time'] ?? 'Not specified',
      ticketType: json['ticket_type'] ?? 'Standard',
      phone: json['phone'] ?? '',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      bookingTime: json['booking_time'] != null 
          ? DateTime.parse(json['booking_time'])
          : DateTime.now(),
      state: json['state'] ?? 'pending',
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      gallery: json['gallery'] != null 
          ? List<String>.from(json['gallery'])
          : null,
      features: json['features'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_id': ticketId,
      'title': title,
      'description': description,
      'image': image,
      'location': location,
      'price': price,
      'category': category,
      'quantity': quantity,
      'date': date,
      'time': time,
      'ticket_type': ticketType,
      'phone': phone,
      'subtotal': subtotal,
      'booking_time': bookingTime.toIso8601String(),
      'state': state,
      'rating': rating,
      'reviewCount': reviewCount,
      'gallery': gallery,
      'features': features,
    };
  }

  // Helper getters
  bool get isActive => state == 'active' || state == 'confirmed';
  bool get isPending => state == 'pending';
  bool get isCancelled => state == 'cancelled';
  bool get isExpired => DateTime.parse(date).isBefore(DateTime.now());
  
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
  
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }
  
  String get formattedBookingTime {
    return '${bookingTime.day}/${bookingTime.month}/${bookingTime.year} ${bookingTime.hour}:${bookingTime.minute.toString().padLeft(2, '0')}';
  }

  String get statusText {
    switch (state.toLowerCase()) {
      case 'active':
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'expired':
        return 'Expired';
      default:
        return state.toUpperCase();
    }
  }

  Ticket copyWith({
    int? id,
    int? ticketId,
    String? title,
    String? description,
    String? image,
    String? location,
    double? price,
    String? category,
    int? quantity,
    String? date,
    String? time,
    String? ticketType,
    String? phone,
    double? subtotal,
    DateTime? bookingTime,
    String? state,
    double? rating,
    int? reviewCount,
    List<String>? gallery,
    Map<String, dynamic>? features,
  }) {
    return Ticket(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      location: location ?? this.location,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      time: time ?? this.time,
      ticketType: ticketType ?? this.ticketType,
      phone: phone ?? this.phone,
      subtotal: subtotal ?? this.subtotal,
      bookingTime: bookingTime ?? this.bookingTime,
      state: state ?? this.state,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      gallery: gallery ?? this.gallery,
      features: features ?? this.features,
    );
  }
}