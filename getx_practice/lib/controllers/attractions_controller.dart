import 'package:get/get.dart';
import '../models/attraction.dart';
import '../services/api.dart';
import '../responses/attraction_response.dart';
import '../screens/cart_screen.dart';
import 'package:getx_practice/screens/attractions_screen.dart';
import '../screens/tickets_list_screen.dart';
class AttractionsController extends GetxController {

void changeNavIndex(int index) {
  if (index == 3) {
    // Custom behavior when Cart tab is tapped
    print("Cart tab tapped!");
    
    Get.to(() => CartScreen()); // Example navigation
  } 
  else if (index == 2) {
    
    Get.to(() => TicketsListScreen()); 
  } 
  else if (index == 0) {
    Get.to(() => AttractionsScreen()); 
  }
  else {
    currentNavIndex.value = index;
  }
}

  

  final currentNavIndex = 0.obs;
  final selectedFilterIndex = 0.obs; 
  final filterOptions = ['All', 'Historical', 'Natural', 'Entertainment'];


  var attractionsList = <Attraction>[].obs;
  var isLoading = false.obs;


  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttractions();
  }


  Future<void> fetchAttractions() async {
    try {
      isLoading(true);
      final response = await Api.getAttractions();
      print('Raw API Response: ${response.data}');
      final attractionResponse = AttractionResponse.fromJson(response.data);
      attractionsList.value = attractionResponse.attractions;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print('Exception: $e');
    } finally {
      isLoading(false);
    }
  }


  List<Attraction> get filteredAttractions {
    var filtered = attractionsList.toList();


    if (selectedFilterIndex.value != 0) { 
      final selectedCategory = filterOptions[selectedFilterIndex.value];
      filtered = filtered.where((attraction) => attraction.type == selectedCategory).toList();
    }


    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((attraction) {
        return attraction.name.toLowerCase().contains(query) ||
               (attraction.location?.toLowerCase().contains(query) ?? false) ||
               (attraction.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }


  void changeFilter(int index) {
    selectedFilterIndex.value = index;
    Get.snackbar('Filter', 'Selected filter: ${filterOptions[index]}');
  }


  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }


  void clearSearch() {
    searchQuery.value = '';
  }


  void exploreAttraction(String name) {
    Get.snackbar('Explore', 'Exploring $name');
  }
}