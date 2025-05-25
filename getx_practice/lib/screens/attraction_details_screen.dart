import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/widgets/map_tooltip.dart';
import '../../controllers/attractions_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/ticket_controller.dart';
import 'package:getx_practice/screens/booking_details_screen.dart';
import 'package:getx_practice/screens/reviews_screen.dart';
import 'package:getx_practice/Styles/colors.dart';
import 'package:getx_practice/utils/location_utils.dart';
import 'package:getx_practice/utils/slugify.dart';
import 'package:cached_network_image/cached_network_image.dart';


class AttractionDetailsScreen extends StatelessWidget {
  final String attractionName;

  const AttractionDetailsScreen({super.key, required this.attractionName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttractionsController>();
    final cartController = Get.put(CartController());
    final ticketController = Get.put(TicketController());
    final attraction = controller.attractionsList.firstWhere(
      (element) => element.name == attractionName,
    );

    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child:
                  CachedNetworkImage(
                    imageUrl: attraction.image ?? '',
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 280,
                      width: double.infinity,
                      color: progressBackground,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 280,
                      width: double.infinity,
                      color: progressBackground,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: secondary,
                        ),
                      ),
                    ),
                  )

              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: CircleAvatar(
                  backgroundColor: icons,
                  child: IconButton(
                    icon:  Icon(Icons.arrow_back, color: primary),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
              if (attraction.price != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'From \$${attraction.price}',
                      style:  TextStyle(
                        color: icons,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration:  BoxDecoration(
                color: icons,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (attraction.type != null)
                      Text(
                        attraction.type!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 210, 172, 113),
                        ),
                      ),

                    const SizedBox(height: 6),

                    Text(
                      attraction.name,
                      style:  TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      attraction.description ?? 'No description available.',
                      style:  TextStyle(
                        fontSize: 14,
                        color: primary,
                        height: 1.5,
                      ),
                    ),


                    //Location Section
                    
                    Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (attraction.location != null)
                      Row(
                        children: [
                          const Icon(Icons.location_city, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              attraction.location!,
                              style:  TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                    if (attraction.mapImage != null)
                      Builder(
                        builder: (_) {
                          final coords = extractLatLngFromUrl(attraction.mapImage!);
                          if (coords == null) return const SizedBox.shrink();

                          return MapWithTooltip(
                            coords: coords,
                            attractionName: attraction.name,
                            mapImageUrl: attraction.mapImage!,
                            primary: primary ?? Colors.blue,
                            icons: icons ?? Colors.grey,
                            onTap: (url) => openInGoogleMaps(url),
                          );
                        },
                      ),

                    

                    SizedBox(
                      width: double.infinity,                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showAddToCartDialog(context, attraction, cartController, ticketController);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 34, 139, 34),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 18,
                                color: icons,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(
                                () => BookingDetailsScreen(),
                                arguments: {'location': attraction.location},
                              );
                            },

                            style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 210, 172, 113),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                            child:  Text(
                              'Book now',
                              style: TextStyle(
                                fontSize: 18,
                                color: icons,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              final slug = slugify(attraction.name);
                              Get.to(() => ReviewsScreen(slug: slug));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 210, 172, 113),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 18,
                                color: icons,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],      ),
    );
  }
  void _showAddToCartDialog(BuildContext context, dynamic attraction, CartController cartController, TicketController ticketController) {
    final TextEditingController quantityController = TextEditingController(text: '1');
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    int? selectedTicketTypeId;

    // Initialize cart controller and fetch ticket types
    cartController.fetchTicketTypes();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${attraction.name} to Cart'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quantity
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              
              // Date Selection
              ListTile(
                title: const Text('Date'),
                subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
              ),
              
              // Time Selection
              ListTile(
                title: const Text('Time'),
                subtitle: Text('${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
              ),
              
              // Ticket Type Selection
              Obx(() => cartController.isLoading.value
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Ticket Type',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedTicketTypeId,                    items: cartController.ticketTypes.map((ticketType) {
                      return DropdownMenuItem<int>(
                        value: ticketType.id,
                        child: Text(ticketType.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedTicketTypeId = value;
                    },
                  ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? 1;
              
              if (selectedTicketTypeId == null) {
                Get.snackbar('Error', 'Please select a ticket type');
                return;
              }
              
              final dateString = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
              final timeString = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00';
              
              Get.back();
              cartController.addToCart(
                attractionId: attraction.id,
                date: dateString,
                time: timeString,
                quantity: quantity,
                ticketTypeId: selectedTicketTypeId!,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
