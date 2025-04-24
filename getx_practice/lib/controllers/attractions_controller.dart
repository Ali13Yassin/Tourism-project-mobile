import 'package:get/get.dart';
import '../models/attraction.dart';
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
      final attractionResponse = AttractionResponse.fromJson(response.data); 
      attractionsList.value = attractionResponse.attractions;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void exploreAttraction(String name) {
    Get.snackbar('Explore', 'Exploring $name'); 
  }
}