import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/attraction.dart';
import '../models/review.dart';
import '../../controllers/attractions_controller.dart';

class AttractionDetailsScreen extends StatelessWidget {
  final String attractionName;
  final TextEditingController reviewController = TextEditingController(); // Controller for the review text field

  AttractionDetailsScreen({super.key, required this.attractionName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttractionsController>();
    final attraction = controller.attractionsList.firstWhere(
      (element) => element.name == attractionName,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  attraction.image ?? '',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 280,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
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
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'From \$${attraction.price}',
                      style: const TextStyle(
                        color: Colors.white,
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
              decoration: const BoxDecoration(
                color: Colors.white,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 210, 172, 113),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      attraction.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      attraction.description ?? 'No description available.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (attraction.location != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              attraction.location!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nearby places',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/istockphoto-1488375208-612x612.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 210, 172, 113),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book now',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    // Review Section
                    const SizedBox(height: 24),
                    const Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Display Reviews List
                    if (attraction.reviews != null && attraction.reviews!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: attraction.reviews!.length,
                        itemBuilder: (context, index) {
                          final review = attraction.reviews![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    review.comment,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    else
                      const Text(
                        'No reviews yet.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),

                    const SizedBox(height: 20),

                    // Add Review Text Field
                    TextField(
                      controller: reviewController,  // Text field controller
                      decoration: const InputDecoration(
                        hintText: 'Write your review...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Submit Review Button
                    ElevatedButton(
                      onPressed: () {
                        if (reviewController.text.isNotEmpty) {
                          controller.addReview(
                            attraction.name,
                            reviewController.text,
                            'User', // This can be dynamic, for example, the current user's name
                          );
                          reviewController.clear(); // Clear the text field after submission
                          Get.snackbar('Success', 'Review added successfully');
                        } else {
                          Get.snackbar('Error', 'Please write a review');
                        }
                      },
                      child: const Text('Submit Review'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
