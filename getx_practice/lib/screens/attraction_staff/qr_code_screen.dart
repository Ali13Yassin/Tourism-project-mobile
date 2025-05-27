import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';
import 'package:getx_practice/controllers/qr_scan_controller.dart';

class QrCodeScreen extends StatefulWidget {
  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  late AnimationController _animationController;
  final QrScanController qrScanController = Get.put(QrScanController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.stop();
    }
    controller.start();
  }


  @override
  Widget build(BuildContext context) {
    final double cutOutSize = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        elevation: 0,
        title: const Text('Scan QR Code',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: const IconThemeData(
        color: Colors.white, // Set the color of the back button to white
        ),      ),

      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: controller,            onDetect: (BarcodeCapture capture) async {
              final String? code = capture.barcodes.first.rawValue;
              if (code != null && !qrScanController.isProcessing.value) {
                debugPrint('QR Code Scanned: $code');
                
                // Store context reference before async operation
                final navigatorContext = context;
                
                // Validate QR code format
                if (qrScanController.isValidQrCode(code)) {
                  // Validate ticket using the encrypted QR code data
                  final response = await qrScanController.validateTicket(code);
                  
                  if (response != null && navigatorContext.mounted) {
                    // Navigate back with validation response
                    Navigator.pop(navigatorContext, {
                      'success': response.success,
                      'qr_code': code,
                      'validation': response.validation,
                      'valid': response.validation.valid,
                      'message': response.validation.message,
                      'guests_allowed': response.validation.guestsAllowed,
                      'guest_type': response.validation.guestType,
                    });
                  } else {
                    // Stay on screen for retry if validation failed
                    debugPrint('Ticket validation failed, staying on screen for retry');
                  }
                } else {
                  // Invalid QR code format
                  Get.snackbar(
                    'Invalid QR Code',
                    'The scanned QR code format is not valid',
                    backgroundColor: Colors.orange.withValues(alpha: 0.8),
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                  );
                }
              }
            },
          ),          // Overlay
          _buildOverlay(cutOutSize),

          // Loading indicator
          Obx(() => qrScanController.isProcessing.value
              ? Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(210, 172, 113, 1)),
                    ),
                  ),
                )
              : SizedBox()),

          // Instructions
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Obx(() => Text(
                qrScanController.isProcessing.value 
                  ? 'Processing QR code...'
                  : 'Align the QR code within the frame to scan',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(double cutOutSize) {
    return Stack(
      children: [
        // Dimmed background with cut-out center
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: cutOutSize,
                  height: cutOutSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

 // Animated scanning line inside the cut-out box
        Center(
          child: SizedBox(
            width: cutOutSize,
            height: cutOutSize,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) {
                return Align(
                  alignment: Alignment(0, _animationController.value * 2 - 1), // Moves from top (-1) to bottom (+1)
                  child: Container(
                    height: 2,
                    color: const Color.fromRGBO(210, 172, 113, 1),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}