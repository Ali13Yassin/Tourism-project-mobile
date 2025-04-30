import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../controllers/attractions_controller.dart';
import '../../utils/helpers.dart';

class AttractionDetailsScreen extends StatefulWidget {
  final String attractionName;

  const AttractionDetailsScreen({super.key, required this.attractionName});

  @override
  State<AttractionDetailsScreen> createState() =>
      _AttractionDetailsScreenState();
}

class _AttractionDetailsScreenState extends State<AttractionDetailsScreen> {
  final TextEditingController reviewController = TextEditingController();
  final controller = Get.find<AttractionsController>();
  double rating = 5.0; // <-- (NEW) Default rating is set to 5

  @override
  void initState() {
    super.initState();
    final slug = slugify(widget.attractionName);
    controller.fetchReviews(slug);
  }

  Future<void> submitReview() async {
    if (reviewController.text.isEmpty) {
      Get.snackbar('Error', 'Please write a review');
      return;
    }

    try {
      controller.addReview(
        widget.attractionName,
        reviewController.text,
        "Guest",
        rating: rating.toInt(),
      );

      reviewController.clear();
      Get.snackbar('Success', 'Review submitted successfully');
    } catch (e) {
      print('Error submitting review: $e');
      Get.snackbar('Error', 'Failed to submit review');
    }
  }

  // Widget for rating stars
  Widget buildRatingBar(double rating) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      itemSize: 30,
      itemBuilder:
          (context, index) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: (rating) {
        setState(() {
          this.rating = rating;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final attraction = controller.attractionsList.firstWhere(
      (element) => element.name == widget.attractionName,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(
        () => Column(
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
                            backgroundColor: const Color.fromARGB(
                              255,
                              210,
                              172,
                              113,
                            ),
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

                      Obx(() {
                        final reviews = controller.reviewsList;

                        if (reviews.isEmpty) {
                          return const Text(
                            'No reviews yet.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
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
                        );
                      }),

                      const SizedBox(height: 20),

                      // Rating Section
                      const Text(
                        'Rate this attraction:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      buildRatingBar(rating),

                      const SizedBox(height: 10),

                      // Add Review TextField
                      TextField(
                        controller: reviewController,
                        decoration: const InputDecoration(
                          hintText: 'Write your review...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Submit Review Button
                      ElevatedButton(
                        onPressed: submitReview,
                        child: const Text('Submit Review'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
