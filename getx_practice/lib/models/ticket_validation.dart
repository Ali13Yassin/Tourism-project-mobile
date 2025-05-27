class TicketValidation {
  late bool valid;
  late int? guestsAllowed;
  late String? guestType;
  late String message;

  TicketValidation();

  TicketValidation.fromJson(Map<String, dynamic> json) {
    valid = json['valid'] ?? false;
    guestsAllowed = json['guests_allowed']; // Updated to match Laravel API response
    guestType = json['guest_type']; // Updated to match Laravel API response
    message = json['message'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'guests_allowed': guestsAllowed,
      'guest_type': guestType,
      'message': message,
    };
  }
}
