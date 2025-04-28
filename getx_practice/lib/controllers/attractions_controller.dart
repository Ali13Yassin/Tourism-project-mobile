import 'package:get/get.dart';
import '../models/attraction.dart';
import '../models/review.dart';
import '../services/api.dart';
import '../responses/attraction_response.dart';

class AttractionsController extends GetxController {
  final currentNavIndex = 0.obs;
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
    print('Raw API Response: ${response.data}'); // Debugging line to check the raw response
    final attractionResponse = AttractionResponse.fromJson(response.data);
    attractionsList.value = attractionResponse.attractions;
  } catch (e) {
    Get.snackbar('Error', e.toString());
    print('Exception: $e');   // Debugging line to check the exception
  } finally {
    isLoading(false);
  }
}

// Function to add a review (comment) to a specific attraction
void addReview(String attractionName, String comment, String userName) {
  // Find the attraction based on the name
  final attraction = attractionsList.firstWhere((element) => element.name == attractionName);

  // Ensure the reviews list is initialized
  attraction.reviews ??= [];

  // Create a new Review object
  final newReview = Review(userName: userName, comment: comment);

  // Add the new review to the attraction's reviews list
  attraction.reviews?.add(newReview);

  // Update the list to reflect the change
  attractionsList.refresh(); 

  // Here, you can also send the new review to the API if needed
  // Example: Api.addReview(attraction.id, newReview);
}


  void exploreAttraction(String name) {
    Get.snackbar('Explore', 'Exploring $name');
  }
}