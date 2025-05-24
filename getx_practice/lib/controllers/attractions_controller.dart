import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/attraction.dart';
import '../services/api.dart';
import '../responses/attraction_response.dart';
import '../screens/cart_screen.dart';
import '../screens/attractions_screen.dart';
import '../screens/tickets_list_screen.dart';

class AttractionsController extends GetxController {
  final currentNavIndex = 0.obs;
  final selectedFilterIndex = 0.obs;
  final filterOptions = ['All', 'Historical', 'Natural', 'Entertainment'];
  final searchQuery = ''.obs;

  var attractionsList = <Attraction>[].obs;
  var articles = <Article>[].obs;
  var isLoading = false.obs;

  // Pagination variables
  int currentPage = 1;
  int lastPage = 1;

  // ScrollController for ListView pagination
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        // Load more attractions when near bottom
        fetchAttractions(loadMore: true);
      }
    });

    fetchAttractions();
    fetchArticles();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
    if (index == 3) {
      Get.to(() => CartScreen());
    } else if (index == 2) {
      Get.to(() => TicketsListScreen());
    } else if (index == 0) {
      Get.to(() => AttractionsScreen());
    } else if (index == 1) {
      // Future option
    }
  }

  Future<void> fetchAttractions({bool loadMore = false}) async {
    if (loadMore && currentPage > lastPage) return;

    try {
      isLoading(true);
      final response = await Api.getAttractions(page: currentPage);
      final attractionResponse = AttractionResponse.fromJson(response.data);

      if (loadMore) {
        attractionsList.addAll(attractionResponse.attractions);
      } else {
        attractionsList.value = attractionResponse.attractions;
      }

      currentPage = attractionResponse.currentPage + 1;
      lastPage = attractionResponse.lastPage;
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
      final selectedCategory = filterOptions[selectedFilterIndex.value].toLowerCase();
      filtered = filtered.where((attraction) =>
          (attraction.type ?? '').toLowerCase() == selectedCategory).toList();
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

  // Articles section
  List<Article> get filteredArticles {
    if (searchQuery.value.isEmpty) return articles;

    final query = searchQuery.value.toLowerCase();
    return articles.where((article) {
      return article.title.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading(true);
      final response = await Api.getAllArticles(); 
      final dataList = response.data['data'] as List;
      articles.value = dataList.map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load articles');
      print('Articles fetch error: $e');
    } finally {
      isLoading(false);
    }
  }
}
