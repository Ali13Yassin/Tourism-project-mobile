import 'package:getx_practice/models/qr_scan.dart';

class QrScanResponse {
  late QrScan qrScan;
  late String message;
  late bool success;
  late Map<String, dynamic>? additionalData;

  QrScanResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    
    if (data == null) {
      throw Exception('Invalid response format: missing data');
    }

    success = json['success'] ?? true;
    message = json['message'] ?? 'QR code processed successfully';
    
    if (data['qr_scan'] != null) {
      qrScan = QrScan.fromJson(data['qr_scan']);
    } else if (data['resource'] != null) {
      qrScan = QrScan.fromJson(data['resource']);
    } else {
      // Fallback: create QrScan from the data itself
      qrScan = QrScan.fromJson(data);
    }
    
    additionalData = data['additional_data'];
  }
}
