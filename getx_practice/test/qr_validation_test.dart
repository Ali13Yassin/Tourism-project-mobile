import 'package:flutter_test/flutter_test.dart';
import 'package:getx_practice/models/ticket_validation.dart';
import 'package:getx_practice/responses/ticket_validation_response.dart';
import 'package:getx_practice/controllers/qr_scan_controller.dart';

void main() {
  group('QR Validation Tests', () {
    late QrScanController controller;

    setUp(() {
      controller = QrScanController();
    });

    test('TicketValidation model should parse JSON correctly', () {
      final json = {
        'valid': true,
        'guests_allowed': 2,
        'guest_type': 'Adult',
        'message': 'Valid ticket for entry'
      };

      final validation = TicketValidation.fromJson(json);

      expect(validation.valid, true);
      expect(validation.guestsAllowed, 2);
      expect(validation.guestType, 'Adult');
      expect(validation.message, 'Valid ticket for entry');
    });

    test('TicketValidationResponse should parse API response correctly', () {
      final json = {
        'success': true,
        'valid': true,
        'guests_allowed': 3,
        'guest_type': 'Family',
        'message': 'Ticket validated successfully'
      };

      final response = TicketValidationResponse.fromJson(json);

      expect(response.success, true);
      expect(response.validation.valid, true);
      expect(response.validation.guestsAllowed, 3);
      expect(response.validation.guestType, 'Family');
      expect(response.validation.message, 'Ticket validated successfully');
    });

    test('QR code validation should work correctly', () {
      // Valid QR codes (encrypted data format)
      expect(controller.isValidQrCode('abc123def456ghi'), true);
      expect(controller.isValidQrCode('encryptedData123'), true);
      
      // Invalid QR codes
      expect(controller.isValidQrCode(''), false);
      expect(controller.isValidQrCode('short'), false);
      expect(controller.isValidQrCode('has spaces in it'), false);
    });

    test('Invalid ticket response should be handled correctly', () {
      final json = {
        'success': false,
        'valid': false,
        'guests_allowed': null,
        'guest_type': null,
        'message': 'Ticket has already been used'
      };

      final response = TicketValidationResponse.fromJson(json);

      expect(response.success, false);
      expect(response.validation.valid, false);
      expect(response.validation.guestsAllowed, null);
      expect(response.validation.guestType, null);
      expect(response.validation.message, 'Ticket has already been used');
    });
  });
}
