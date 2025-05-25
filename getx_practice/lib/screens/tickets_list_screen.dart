import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/ticket_details_screen.dart';
import '../controllers/attractions_controller.dart';
import '../controllers/ticket_controller.dart';
import '../Styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Renamed class to match the file purpose
class TicketsListScreen extends StatelessWidget {
  TicketsListScreen({super.key});

  final controller = Get.find<AttractionsController>(); //Used for navbar
  final ticketController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx( // Wrap with Obx for reactivity
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value, // Use controller's value
            onTap: controller.changeNavIndex, // Call controller's method on tap
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
          child: SingleChildScrollView( // Keep scrollability
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title - Kept as "My Cart" from the mockup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.confirmation_num),
                    const SizedBox(width: 8),
                    Text(
                      'My Tickets',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            // fontFamily: 'Serif',
                          ),
                    ),
                  ],
                ),                const SizedBox(height: 20),

                // Ticket Items
                Obx(() {
                  if (ticketController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (ticketController.tickets.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.confirmation_num_outlined, 
                               size: 80, 
                               color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No tickets yet',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your tickets will appear here after booking',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      ...ticketController.tickets.map((ticket) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildTicketItem(context, ticket),
                      )).toList(),
                    ],
                  );
                }),
                // Removed Payment Method and Pay Now sections
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Renamed and modified method to build ticket items
  Widget _buildTicketItem(BuildContext context, dynamic ticket) {
    const buttonColor = Color(0xFFD4B98A); // Beige color for buttons
    const buttonTextStyle = TextStyle(fontSize: 12, color: Colors.black);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: ticket.image != null
                ? CachedNetworkImage(
                    imageUrl: ticket.image!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 80,
                      width: 80,
                      color: progressBackground,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 80,
                      width: 80,
                      color: progressBackground,
                      child: const Icon(Icons.image_not_supported, size: 40),
                    ),
                  )
                : Container(
                    height: 80,
                    width: 80,
                    color: progressBackground,
                    child: const Icon(Icons.confirmation_num, size: 40),
                  ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title ?? 'Ticket',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  if (ticket.date != null)
                    Text(
                      'Date: ${ticket.date}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: primary,
                          ),
                    ),
                  const SizedBox(height: 5),
                  if (ticket.time != null)
                    Text(
                      'Time: ${ticket.time}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: primary,
                          ),
                    ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStateColor(ticket.state),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ticket.state.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details Button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                MaterialButton(
                  onPressed: () {
                    Get.to(() => TicketDetailsScreen(), arguments: {'ticketId': ticket.ticketUuid});
                  },
                  color: buttonColor,
                  minWidth: 60,
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Details', style: buttonTextStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
