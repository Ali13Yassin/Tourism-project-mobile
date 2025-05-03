import 'package:flutter/material.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define text styles for consistency
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black87,
        );
    final detailStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black54,
        );

    return Scaffold(
      // Optional: Add an AppBar if needed
      // appBar: AppBar(title: const Text('Ticket Details')),
      backgroundColor: Colors.white, // Match background if needed
      body: SafeArea(
        child: Center( // Center the card on the screen
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Padding around the card
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // 90% of screen width
              height: MediaQuery.of(context).size.height * 0.8, // Set a fixed height for the card
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
              ),
              color: const Color(0xFFF5F5F5), // Light grey background for the card
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Padding inside the card
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Make card wrap content height
                  crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
                  children: [
                    // Title
                    Text(
                      'Karnak Temple',
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Date and Time
                    Text(
                      '13/4/2025',
                      style: subtitleStyle,
                    ),
                    Text(
                      '2 PM',
                      style: subtitleStyle,
                    ),
                    const SizedBox(height: 25),

                    // Placeholder for QR Code/Image
                    Container(
                      width: 180, // Adjust size as needed
                      height: 180, // Adjust size as needed
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500, // Grey placeholder color
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      // In a real app, you might display a QR code here
                      // child: QrImageView(data: 'Your QR Data'),
                    ),
                    const SizedBox(height: 25),

                    // Status Row
                    Row(
                      mainAxisSize: MainAxisSize.min, // Row takes minimum width
                      children: [
                        Text(
                          'Status: Expired',
                          style: detailStyle,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.cyan, // Blue circle color
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Visit Type
                    Text(
                      'Visit type: Guided',
                      style: detailStyle,
                    ),
                    const SizedBox(height: 4),

                    // Ticket Type
                    Text(
                      'Ticket type: Adults',
                      style: detailStyle,
                    ),
                  ],
                ),
              ),
            ),
            )
          ),
        ),
      ),
    );
  }
}