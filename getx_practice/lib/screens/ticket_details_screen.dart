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
        );    return Scaffold(
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
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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

                        // Attraction Image or QR Code placeholder
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: secondary,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ticket.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
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
                              : const Icon(
                                  Icons.confirmation_num,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                        ),
                        const SizedBox(height: 25),                        // Status Row
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
      ),        bottomNavigationBar: Obx(
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
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'expired':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}