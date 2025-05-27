import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/attractions_controller.dart';
import '../controllers/ticket_controller.dart';
import '../Styles/colors.dart';

class TicketDetailsScreen extends StatelessWidget {
  TicketDetailsScreen({super.key});

  final ticketController = Get.put(TicketController());
  final controller = Get.find<AttractionsController>();

  @override
  Widget build(BuildContext context) {
    // Get ticket ID from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    final ticketId = arguments?['ticketId'] as String?;

    if (ticketId != null) {
      // Fetch ticket details when screen loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ticketController.fetchTicketDetails(ticketId);
      });
    }

    // Define text styles for consistency
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: primary,
        );
    final subtitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: primary,
        );
    final detailStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: primary,
        );

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (ticketController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final ticket = ticketController.selectedTicket.value;
          if (ticket == null) {
            return const Center(
              child: Text('Ticket not found'),
            );
          }          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100, left: 20, right: 20, top: 20),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: const Color(0xFFF5F5F5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          ticket.title ?? 'Ticket',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Date and Time
                        Text(
                          ticket.date ?? 'No date',
                          style: subtitleStyle,
                        ),
                        Text(
                          ticket.time ?? 'No time',
                          style: subtitleStyle,
                        ),
                        const SizedBox(height: 25),

                        // QR Code Section Label
                        if (ticket.qrImageUrl != null) ...[
                          Text(
                            'QR Code - Show to staff at entrance',
                            style: detailStyle?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                        ],

                        // QR Code or Attraction Image
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: primary?.withValues(alpha: 0.2) ?? Colors.grey.withValues(alpha: 0.2), width: 2),
                          ),
                          child: ticket.qrImageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    imageUrl: ticket.qrImageUrl!,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(color: primary),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Loading QR Code...',
                                            style: TextStyle(color: primary, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code,
                                          size: 60,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'QR Code Unavailable',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ticket.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl: ticket.image!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(color: primary),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(
                                          Icons.confirmation_num,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code,
                                          size: 80,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'No QR Code Available',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                        const SizedBox(height: 25),

                        // QR Code Usage Instructions
                        if (ticket.qrImageUrl != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Present this QR code to attraction staff for entry verification',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Status Row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Status: ${ticket.state.toUpperCase()}',
                              style: detailStyle,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getStatusColor(ticket.state),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Ticket Type
                        Text(
                          'Ticket type: ${ticket.ticketTypeName ?? 'Standard'}',
                          style: detailStyle,
                        ),
                        const SizedBox(height: 4),

                        // Quantity
                        Text(
                          'Quantity: ${ticket.quantity}',
                          style: detailStyle,
                        ),
                        const SizedBox(height: 4),

                        // Total Cost
                        Text(
                          'Total: \$${ticket.totalCost.toStringAsFixed(2)}',
                          style: detailStyle?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          onTap: controller.changeNavIndex,
          backgroundColor: background,
          selectedItemColor: primary,
          unselectedItemColor: progressBackground,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'valid':
      case 'confirmed':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'used':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'expired':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}