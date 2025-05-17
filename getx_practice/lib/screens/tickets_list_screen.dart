import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/ticket_details_screen.dart';
import '../../controllers/attractions_controller.dart';
import '../Styles/colors.dart';
// Renamed class to match the file purpose
class TicketsListScreen extends StatelessWidget {
  TicketsListScreen({super.key});

  final controller = Get.find<AttractionsController>(); //Used for navbar

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
                ),
                const SizedBox(height: 20),

                // Ticket Items
                _buildTicketItem(
                  context,
                  // Use a placeholder or actual asset path
                  imageUrl: 'assets/images.jpg',
                  itemName: 'Karnak Temple',
                  date: '13/4/2025',
                  price: '399 LE',
                ),
                const SizedBox(height: 5), //Height between items
                _buildTicketItem(
                  context,
                  // Use a placeholder or actual asset path
                  imageUrl: 'assets/images.jpg',
                  itemName: 'Karnak Temple', // Mockup shows same item twice
                  date: '13/4/2025',
                  price: '399 LE',
                ),
                // Removed Payment Method and Pay Now sections
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Renamed and modified method to build ticket items
  Widget _buildTicketItem(
    BuildContext context, {
    required String imageUrl,
    required String itemName,
    required String date, // Added date parameter
    required String price,
  }) {
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
              child: Image.asset( // Assuming local asset
                imageUrl,
                height: 80, // Adjusted height slightly
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 60), // Placeholder on error
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          // fontFamily: 'Serif',
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date, // Display date
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          // fontFamily: 'Serif',
                          color: primary,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          // fontFamily: 'Serif',
                          color: primary,
                        ),
                  ),
                ],
              ),
            ),
            // Details and Review Buttons
                // Details and Review Buttons
                Column( // Use Column for vertical button arrangement if needed, Row for side-by-side
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Get.to(() => TicketDetailsScreen());
                      },
                      color: buttonColor,
                      minWidth: 60, // Adjust width
                      height: 30, // Adjust height
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
      }
    }
