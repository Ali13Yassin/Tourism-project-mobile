import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/review_model.dart';
import '../responses/review_response.dart';
import '../services/api.dart';

class ReviewController extends GetxController {
  var reviews = <Review>[].obs;
  var isLoading = false.obs;
  var attractionName = ''.obs;

  Future<void> fetchReviews(String slug) async {
    try {
      isLoading(true);
      final response = await Api.getAttractionReviews(slug);
      final reviewResponse = ReviewResponse.fromJson(response.data);
      reviews.value = reviewResponse.reviews;
      attractionName.value = reviewResponse.attractionName;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> submitReview(String slug, int rating, String comment) async {
  try {
    isLoading(true);

    final token = await GetStorage().read('login_token');

    final response = await Dio().post(
      'http://10.0.2.2:8000/api/attractions/$slug/reviews',
      data: {
        'rating': rating,
        'comment': comment,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    final reviewData = response.data['review'];
    reviews.insert(
      0,
      Review(
        id: reviewData['id'],
        rating: reviewData['rating'],
        comment: reviewData['comment'],
        name: reviewData['tourist']['name'],
        createdAt: reviewData['created_at'],
      ),
    );

    Get.snackbar('Success', response.data['message']);
  } catch (e) {
    Get.snackbar('Error', 'Failed to submit review: $e');
  } finally {
    isLoading(false);
  }
}

}
