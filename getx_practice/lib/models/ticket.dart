class Ticket {
  final String id;
  final String touristId;
  final int attraction; // Changed from String to int
  final int ticketTypesId;
  final int quantity;
  final DateTime bookingTime;
  final double totalCost;
  final String visitDate;
  final String timeSlot;
  final String phoneNumber;
  final String state;
  
  // Additional properties for UI display
  final String? attractionTitle;
  final String? attractionSlug;
  final double? attractionPrice;
  final double? attractionRating;
  final int? reviewCount;
  final String? attractionDescription;  final String? attractionImage;
  final String? ticketTypeName;
  final String? uuid; // Add explicit UUID field for ticket identification
  final String? qrImageUrl; // QR code image URL from backend

  // Getter for backwards compatibility
  String? get image => attractionImage;
  String? get title => attractionTitle;
  String? get date => visitDate;
  String? get time => timeSlot;
  
  // Getter for proper ticket UUID (prioritizes uuid field over id)
  String get ticketUuid => uuid ?? id;

  Ticket({
    required this.id,
    required this.touristId,
    required this.attraction,
    required this.ticketTypesId,
    required this.quantity,
    required this.bookingTime,
    required this.totalCost,
    required this.visitDate,
    required this.timeSlot,
    required this.phoneNumber,
    required this.state,
    this.attractionTitle,
    this.attractionSlug,
    this.attractionPrice,
    this.attractionRating,
    this.reviewCount,    this.attractionDescription,
    this.attractionImage,
    this.ticketTypeName,
    this.uuid,
    this.qrImageUrl,
  });
  factory Ticket.fromJson(Map<String, dynamic> json) {    print('Ticket JSON data: $json');
    
    // Debug all possible ID fields to understand the data structure
    print('Available ID fields:');
    print('  - id: ${json['id']} (${json['id']?.runtimeType})');
    print('  - ticket_id: ${json['ticket_id']} (${json['ticket_id']?.runtimeType})');
    print('  - uuid: ${json['uuid']} (${json['uuid']?.runtimeType})');
    print('  - ticket_uuid: ${json['ticket_uuid']} (${json['ticket_uuid']?.runtimeType})');
    
    // Use ticket_id or uuid field for the unique ticket identifier, not the attraction id
    final ticketId = json['ticket_id']?.toString() ?? 
                     json['uuid']?.toString() ?? 
                     json['ticket_uuid']?.toString() ?? 
                     json['id']?.toString() ?? '';    print('Parsed ticket ID: $ticketId from fields: ticket_id=${json['ticket_id']}, uuid=${json['uuid']}, ticket_uuid=${json['ticket_uuid']}, id=${json['id']}');
    
    return Ticket(
      id: ticketId,
      touristId: json['TouristId']?.toString() ?? json['tourist_id']?.toString() ?? '',
      attraction: _parseInt(json['Attraction'] ?? json['attraction']),
      ticketTypesId: _parseInt(json['TicketTypesId'] ?? json['ticket_types_id']),
      quantity: _parseInt(json['Quantity'] ?? json['quantity']) == 0 ? 1 : _parseInt(json['Quantity'] ?? json['quantity']),
      bookingTime: json['BookingTime'] != null
          ? DateTime.parse(json['BookingTime']) 
          : json['booking_time'] != null
              ? DateTime.parse(json['booking_time'])
              : DateTime.now(),
      totalCost: _parseDouble(json['TotalCost'] ?? json['total_cost'] ?? json['subtotal']),
      visitDate: json['VisitDate']?.toString() ?? json['visit_date']?.toString() ?? json['date']?.toString() ?? '',
      timeSlot: json['TimeSlot']?.toString() ?? json['time_slot']?.toString() ?? json['time']?.toString() ?? '',
      phoneNumber: json['PhoneNumber']?.toString() ?? json['phone_number']?.toString() ?? json['phone']?.toString() ?? '',
      state: json['state']?.toString() ?? 'pending',
      attractionTitle: json['title']?.toString(),
      attractionSlug: json['slug']?.toString(),
      attractionPrice: _parseDouble(json['price']),
      attractionRating: _parseDouble(json['rating']),
      reviewCount: _parseInt(json['reviewCount']),      attractionDescription: json['description']?.toString(),
      attractionImage: json['image']?.toString(),
      ticketTypeName: json['ticket_type']?.toString(),
      uuid: json['uuid']?.toString() ?? json['ticket_uuid']?.toString(), // Parse both uuid and ticket_uuid fields
      qrImageUrl: json['qrImageUrl']?.toString(), // Extract QR code URL from response
    );
  }

  // Helper method to safely parse integers
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  // Helper method to safely parse doubles
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'TouristId': touristId,
      'Attraction': attraction,
      'TicketTypesId': ticketTypesId,
      'Quantity': quantity,
      'BookingTime': bookingTime.toIso8601String(),
      'TotalCost': totalCost,
      'VisitDate': visitDate,
      'TimeSlot': timeSlot,
      'PhoneNumber': phoneNumber,
      'state': state,
    };
  }
}