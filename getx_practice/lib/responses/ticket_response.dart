import '../models/ticket.dart';

class TicketResponse {
  final List<Ticket> tickets;
  final double total;
  final List<String>? categories;

  TicketResponse({
    required this.tickets,
    required this.total,
    this.categories,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      tickets: json['tickets'] != null 
          ? (json['tickets'] as List).map((ticket) => Ticket.fromJson(ticket)).toList()
          : [],
      total: (json['total'] ?? 0).toDouble(),
      categories: json['categories'] != null 
          ? List<String>.from(json['categories'])
          : null,
    );
  }
}

class SingleTicketResponse {
  final Ticket ticket;
  final Map<String, dynamic> attraction;
  final Map<String, dynamic>? ticketType;
  final Map<String, dynamic>? reviewStats;
  final List<String>? categories;

  SingleTicketResponse({
    required this.ticket,
    required this.attraction,
    this.ticketType,
    this.reviewStats,
    this.categories,
  });

  factory SingleTicketResponse.fromJson(Map<String, dynamic> json) {
    return SingleTicketResponse(
      ticket: Ticket.fromJson(json['ticket'] ?? {}),
      attraction: json['attraction'] ?? {},
      ticketType: json['ticketType'],
      reviewStats: json['reviewStats'],
      categories: json['categories'] != null 
          ? List<String>.from(json['categories'])
          : null,
    );
  }
}