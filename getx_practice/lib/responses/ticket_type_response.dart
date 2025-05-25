import '../models/ticket_type.dart';

class TicketTypeResponse {
  final bool success;
  final List<TicketType> ticketTypes;

  TicketTypeResponse({
    required this.success,
    required this.ticketTypes,
  });

  factory TicketTypeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    
    return TicketTypeResponse(
      success: json['success'] ?? false,
      ticketTypes: data.map((item) => TicketType.fromJson(item)).toList(),
    );
  }
}
