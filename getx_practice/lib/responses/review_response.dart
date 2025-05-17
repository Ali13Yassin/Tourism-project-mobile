import '../models/review_model.dart';

class ReviewResponse {
  final String attractionName;
  final String attractionSlug;
  final int attractionId;
  final List<Review> reviews;

  ReviewResponse({
    required this.attractionId,
    required this.attractionName,
    required this.attractionSlug,
    required this.reviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    final attraction = json['attraction'];
    final List<dynamic> reviewsJson = json['reviews'];

    return ReviewResponse(
      attractionId: attraction['id'],
      attractionName: attraction['name'],
      attractionSlug: attraction['slug'],
      reviews: reviewsJson.map((r) => Review.fromJson(r)).toList(),
    );
  }
}