import 'package:getx_practice/models/ticket_validation.dart';

class TicketValidationResponse {
  late TicketValidation validation;
  late bool success;
  late String message;

  TicketValidationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    
    // Create validation object from the response data
    validation = TicketValidation.fromJson({
      'valid': json['valid'] ?? false,
      'guests_allowed': json['guests_allowed'],
      'guest_type': json['guest_type'],
      'message': json['message'] ?? '',
    });
  }
}
