import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/review_controller.dart';
import '../models/review_model.dart';

class ReviewsScreen extends StatefulWidget {
  final String slug;
  const ReviewsScreen({required this.slug});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final ReviewController controller = Get.put(ReviewController());
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    controller.fetchReviews(widget.slug);
  }

  void _submitReview() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      controller.submitReview(widget.slug, _selectedRating, comment);
      _commentController.clear();
      setState(() => _selectedRating = 5);
    } else {
      Get.snackbar('Error', 'Please write a comment before submitting.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.attractionName.value.isNotEmpty
              ? controller.attractionName.value
              : 'Reviews',
        )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: controller.reviews.isEmpty
                  ? const Center(child: Text('No reviews yet. Be the first!'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.reviews.length,
                      separatorBuilder: (_, __) => const Divider(height: 32),
                      itemBuilder: (context, index) {
                        return _ReviewTile(review: controller.reviews[index]);
                      },
                    ),
            ),
            const Divider(height: 1),
            _ReviewForm(
              selectedRating: _selectedRating,
              onRatingChanged: (rating) {
                setState(() => _selectedRating = rating);
              },
              commentController: _commentController,
              onSubmit: _submitReview,
            ),
          ],
        );
      }),
    );
  }
}
class _ReviewTile extends StatelessWidget {
  final Review review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blueGrey[200],
          child: Text(
            review.name?.substring(0, 1).toUpperCase() ?? '?',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.name ?? 'Anonymous',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    size: 18,
                    color: Colors.amber,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(review.comment),
              const SizedBox(height: 4),
              Text(
                review.createdAt,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewForm extends StatelessWidget {
  final int selectedRating;
  final Function(int) onRatingChanged;
  final TextEditingController commentController;
  final VoidCallback onSubmit;

  const _ReviewForm({
    required this.selectedRating,
    required this.onRatingChanged,
    required this.commentController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Leave a Review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => onRatingChanged(index + 1),
                icon: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              );
            }),
          ),
          TextField(
            controller: commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Write your review...",
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.send),
              label: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          )
        ],
      ),
    );
  }
}

