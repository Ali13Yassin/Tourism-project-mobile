import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/attraction_staff/qr_code_screen.dart';
import 'package:getx_practice/controllers/qr_scan_controller.dart';

class QrScanExampleScreen extends StatelessWidget {
  final QrScanController qrScanController = Get.put(QrScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner Example'),
        backgroundColor: Color.fromRGBO(210, 172, 113, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [            // Scan QR Code Button
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QrCodeScreen()),
                );
                
                if (result != null && result is Map<String, dynamic>) {
                  // Handle validation result
                  final bool isValid = result['valid'] ?? false;
                  final String message = result['message'] ?? 'Unknown result';
                  final int? guestsAllowed = result['guests_allowed'];
                  final int? guestType = result['guest_type'];
                  
                  print('QR Code: ${result['qr_code']}');
                  print('Valid: $isValid');
                  print('Message: $message');
                  print('Guests Allowed: $guestsAllowed');
                  print('Guest Type: $guestType');
                  
                  // The validation result dialog is already shown by the controller
                  // But we can add additional processing here if needed
                }
              },
              icon: Icon(Icons.qr_code_scanner),
              label: Text('Scan Ticket QR Code'),              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(210, 172, 113, 1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Last Scanned QR Code
            Obx(() => Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Scanned QR:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      qrScanController.lastScannedQr.value?.qrCode ?? 'No QR code scanned yet',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (qrScanController.lastScannedQr.value != null) ...[
                      SizedBox(height: 8),
                      Text(
                        'Status: ${qrScanController.lastScannedQr.value!.status}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            )),
            
            SizedBox(height: 20),
            
            // Scan History
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scan History:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => qrScanController.clearScanHistory(),
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Obx(() => ListView.builder(
                      itemCount: qrScanController.scanHistory.length,
                      itemBuilder: (context, index) {
                        final scan = qrScanController.scanHistory[index];
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.qr_code),
                            title: Text(scan.qrCode),
                            subtitle: Text('Status: ${scan.status}'),
                            trailing: Text(
                              scan.scannedAt,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
