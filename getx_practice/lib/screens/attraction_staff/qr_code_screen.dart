import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScreen extends StatefulWidget {
  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }


 void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }


void reassemble() {
    super.reassemble();
if (Platform.isAndroid) {
controller.stop();
    }

controller.start();
  }


  Widget build(BuildContext context) {
    final double cutOutSize = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        title: const Text('Scan QR Code',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: const IconThemeData(
        color: Colors.white, // Set the color of the back button to white
        ),
      ),


body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              final String? code = capture.barcodes.first.rawValue;
              if (code != null) {
                debugPrint('QR Code Scanned: $code');
                Navigator.pop(context, code);
              }
            },
          ),

          // Overlay
          _buildOverlay(cutOutSize),

          // Instructions
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                'Align the QR code within the frame to scan',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
              ),
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
            Colors.black.withOpacity(0.5),
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