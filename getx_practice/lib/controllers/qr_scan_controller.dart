import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/controllers/base_controller.dart';
import 'package:getx_practice/models/qr_scan.dart';
import 'package:getx_practice/models/ticket_validation.dart';
import 'package:getx_practice/responses/qr_scan_response.dart';
import 'package:getx_practice/responses/ticket_validation_response.dart';
import 'package:getx_practice/services/api.dart';

class QrScanController extends GetxController with BaseController {
  var isProcessing = false.obs;
  var lastScannedQr = Rxn<QrScan>();
  var scanHistory = <QrScan>[].obs;
  // Removed unnecessary override since it only calls super

  /// Process a scanned QR code
  Future<QrScanResponse?> processQrCode(String qrCode) async {
    try {
      isProcessing.value = true;
      showLoading();

      final response = await Api.processQrCode(qrCode: qrCode);
      final qrScanResponse = QrScanResponse.fromJson(response.data);
      
      // Update the last scanned QR and add to history
      lastScannedQr.value = qrScanResponse.qrScan;
      scanHistory.insert(0, qrScanResponse.qrScan);
      
      // Limit history to last 10 scans
      if (scanHistory.length > 10) {
        scanHistory.removeRange(10, scanHistory.length);
      }

      hideLoading();
        // Show success message
      Get.snackbar(
        'Success',
        qrScanResponse.message,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      return qrScanResponse;
    } catch (error) {
      hideLoading();
      
      String errorMessage = 'Failed to process QR code';
      if (error.toString().contains('404')) {
        errorMessage = 'QR code not found or invalid';
      } else if (error.toString().contains('401')) {
        errorMessage = 'Unauthorized access';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'Connection timeout. Please try again';
      }      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );

      debugPrint('QR Scan Error: $error');
      return null;
    } finally {
      isProcessing.value = false;
    }
  }

  /// Validate a ticket using encrypted QR code data
  Future<TicketValidationResponse?> validateTicket(String encryptedData) async {
    try {
      isProcessing.value = true;
      showLoading();

      final response = await Api.validateTicket(encryptedData: encryptedData);
      final validationResponse = TicketValidationResponse.fromJson(response.data);
      
      hideLoading();
      
      // Show validation result
      _showValidationResult(validationResponse.validation);

      return validationResponse;
    } catch (error) {
      hideLoading();
      
      String errorMessage = 'Failed to validate ticket';
      if (error.toString().contains('404')) {
        errorMessage = 'Ticket not found';
      } else if (error.toString().contains('401')) {
        errorMessage = 'Unauthorized access';
      } else if (error.toString().contains('403')) {
        errorMessage = 'Access denied: Not assigned to this attraction';
      } else if (error.toString().contains('400')) {
        errorMessage = 'Invalid ticket or already used';
      } else if (error.toString().contains('timeout')) {
        errorMessage = 'Connection timeout. Please try again';
      }      Get.snackbar(
        'Validation Failed',
        errorMessage,
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        icon: Icon(Icons.error, color: Colors.white),
      );

      debugPrint('Ticket Validation Error: $error');
      return null;
    } finally {
      isProcessing.value = false;
    }
  }

  /// Show validation result with appropriate styling
  void _showValidationResult(TicketValidation validation) {
    if (validation.valid) {
      // Valid ticket - show success
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.green[50],
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 8),
              Text('VALID TICKET', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                validation.message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              if (validation.guestsAllowed != null) ...[
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      'Guests Allowed: ${validation.guestsAllowed}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
              if (validation.guestType != null) ...[
                Row(
                  children: [
                    Icon(Icons.local_activity, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      'Ticket Type: ${validation.guestType}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.thumb_up, color: Colors.green[800]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ALLOW ENTRY',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK', style: TextStyle(color: Colors.green[800])),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      // Invalid ticket - show error
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.red[50],
          title: Row(
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 32),
              SizedBox(width: 8),
              Text('INVALID TICKET', style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                validation.message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red[800]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'DO NOT ALLOW ENTRY',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK', style: TextStyle(color: Colors.red[800])),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }
  /// Validate QR code format before processing
  bool isValidQrCode(String qrCode) {
    // For encrypted ticket data, check basic format
    // Encrypted data should be longer and contain valid characters
    return qrCode.isNotEmpty && 
           qrCode.length >= 10 && // Encrypted data should be longer
           !qrCode.contains(' '); // Should not contain spaces
  }

  /// Get scan history
  List<QrScan> getScanHistory() {
    return scanHistory.toList();
  }

  /// Clear scan history
  void clearScanHistory() {
    scanHistory.clear();
    lastScannedQr.value = null;
  }

  /// Retry last failed scan
  Future<QrScanResponse?> retryLastScan() async {
    if (lastScannedQr.value?.qrCode != null) {
      return await processQrCode(lastScannedQr.value!.qrCode);
    }
    return null;
  }
}
