import '../models/ticket.dart';

class TicketResponse {
  final bool success;
  final List<Ticket> tickets;
  final double total;
  final String? message;

  TicketResponse({
    required this.success,
    required this.tickets,
    required this.total,
    this.message,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final ticketsList = data['tickets'] as List? ?? [];
    
    return TicketResponse(
      success: json['success'] ?? false,
      tickets: ticketsList.map((item) => Ticket.fromJson(item)).toList(),
      total: (data['total'] ?? 0).toDouble(),
      message: json['message'],
    );
  }
}

class CheckoutResponse {
  final bool success;
  final String message;
  final int ticketsCreated;
  final List<Ticket> tickets;

  CheckoutResponse({
    required this.success,
    required this.message,
    required this.ticketsCreated,
    required this.tickets,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final ticketsList = data['tickets'] as List? ?? [];
    
    return CheckoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      ticketsCreated: data['tickets_created'] ?? 0,
      tickets: ticketsList.map((item) => Ticket.fromJson(item)).toList(),
    );
  }
}
