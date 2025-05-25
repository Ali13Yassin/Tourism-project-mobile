import '../models/ticket.dart';

class CheckoutResponse {
  final bool success;
  final String message;
  final CheckoutData? data;

  CheckoutResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
      data: json['data'] != null ? CheckoutData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  // Helper getters for backward compatibility
  int get ticketsCreated => data?.ticketsCreated ?? 0;
  List<Ticket>? get tickets => data?.tickets;
}

class CheckoutData {
  final int ticketsCreated;
  final List<Ticket> tickets;

  CheckoutData({
    required this.ticketsCreated,
    required this.tickets,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      ticketsCreated: _parseInt(json['tickets_created']),
      tickets: (json['tickets'] as List<dynamic>?)
          ?.map((ticket) => Ticket.fromJson(ticket))
          .toList() ?? [],
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

  Map<String, dynamic> toJson() {
    return {
      'tickets_created': ticketsCreated,
      'tickets': tickets.map((ticket) => ticket.toJson()).toList(),
    };
  }
}