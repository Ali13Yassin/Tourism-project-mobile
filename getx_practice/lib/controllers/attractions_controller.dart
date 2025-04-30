import 'package:get/get.dart';
import '../models/attraction.dart';
import '../models/review.dart';
import '../services/api.dart';
import '../responses/attraction_response.dart';
import '../utils/helpers.dart';

class AttractionsController extends GetxController {
  final currentNavIndex = 0.obs;
  var reviewsList = <Review>[].obs;

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
    Get.snackbar('Navigation', 'Selected index: $index');
  }

  final selectedFilterIndex = 1.obs;
  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    Get.snackbar('Filter', 'Selected filter: ${filterOptions[index]}');
  }

  final filterOptions = ['Museums', 'Historical Sites', 'Beaches'];

  var attractionsList = <Attraction>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttractions();
  }

  Future<void> fetchAttractions() async {
    try {
      isLoading(true);
      final response = await Api.getAttractions();
      print(
        'Raw API Response: ${response.data}',
      ); // Debugging line to check the raw response
      final attractionResponse = AttractionResponse.fromJson(response.data);
      attractionsList.value = attractionResponse.attractions;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Exception: $e'); // Debugging line to check the exception
    } finally {
      isLoading(false);
    }
  }

  void addReview(
    String attractionName,
    String comment,
    String userName, {
    int rating = 5,
  }) {
    final attraction = attractionsList.firstWhere(
      (element) => element.name == attractionName,
    );

    attraction.reviews ??= [];

    final newReview = Review(
      userName: userName,
      comment: comment,
      rating: rating,
      createdAt: DateTime.now().toString(),
    );

    attraction.reviews?.add(newReview);

    attractionsList.refresh();

    // Optionally send to API
    // Api.addReview(attraction.id, newReview);
  }

  // -------------------------- New function Added --------------------------
  Future<void> fetchReviews(String slug) async {
    try {
      final response = await Api.getReviews(slug);

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['data']; // Ensure 'data' is the correct key

        if (data.isNotEmpty) {
          // Update the reviews list with the fetched data
          final reviews = data.map((e) => Review.fromJson(e)).toList();

          // Here, you can handle the reviews as needed
          // For example, update the UI or store the reviews in a variable
          print('Fetched reviews: $reviews');
        }
      } else {
        print('Failed to fetch reviews: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch reviews');
      print('Fetch reviews error: $e');
    }
  }

  // -------------------------- End of New function --------------------------

  void exploreAttraction(String name) {
    final slug = slugify(name);
    fetchReviews(slug);
    Get.snackbar('Explore', 'Exploring $name');
  }
}
