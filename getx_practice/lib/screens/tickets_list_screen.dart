import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/controllers/attractions_controller.dart';
import 'package:getx_practice/controllers/ticket_controller.dart';
import 'package:getx_practice/models/ticket.dart';
import 'package:getx_practice/screens/ticket_details_screen.dart';
import '../Styles/colors.dart';

class TicketsListScreen extends StatelessWidget {
  TicketsListScreen({super.key});

  final attractionsController = Get.find<AttractionsController>();
  final ticketController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: attractionsController.currentNavIndex.value,
          onTap: attractionsController.changeNavIndex,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (ticketController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ticketController.tickets.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No tickets found'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => ticketController.fetchTickets(),
                      child: const Text('Refresh Tickets'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.confirmation_num),
                      const SizedBox(width: 8),
                      Text(
                        'My Tickets',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Total Amount Card - Similar to CartScreen's design
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Spent:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${ticketController.totalAmount.value.toStringAsFixed(2)} LE',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ticket List - Using similar card design as CartScreen
                  ...ticketController.tickets.map((ticket) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildTicketItem(context, ticket),
                      )),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTicketItem(BuildContext context, Ticket ticket) {
    const buttonColor = Color(0xFFD4B98A); // Same beige color as CartScreen
    const buttonTextStyle = TextStyle(fontSize: 12, color: Colors.black);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ticket.image.isNotEmpty
                      ? Image.network(
                          ticket.image,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 80,
                                width: 80,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              ),
                        )
                      : Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.confirmation_num),
                        ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ticket.formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: primary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${ticket.price.toStringAsFixed(2)} LE',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: primary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Chip(
                        label: Text(ticket.statusText),
                        backgroundColor: _getStatusColor(ticket.state),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Details Button - styled like CartScreen's buttons
                MaterialButton(
                  onPressed: () {
                    Get.to(() => TicketDetailsScreen(), arguments: ticket.id);
                  },
                  color: buttonColor,
                  minWidth: 100,
                  height: 36,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Details', style: buttonTextStyle),
                ),
                // View QR Button - styled like CartScreen's buttons
                MaterialButton(
                  onPressed: () {
                    // QR viewing functionality
                  },
                  color: buttonColor,
                  minWidth: 100,
                  height: 36,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('View QR', style: buttonTextStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'confirmed':
        // ignore: deprecated_member_use
        return Colors.green.withOpacity(0.2);
      case 'pending':
        // ignore: deprecated_member_use
        return Colors.orange.withOpacity(0.2);
      case 'cancelled':
        // ignore: deprecated_member_use
        return Colors.red.withOpacity(0.2);
      case 'expired':
        // ignore: deprecated_member_use
        return Colors.grey.withOpacity(0.2);
      default:
        // ignore: deprecated_member_use
        return Colors.blue.withOpacity(0.2);
    }
  }
}