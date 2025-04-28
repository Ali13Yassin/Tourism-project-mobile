import '../models/attraction.dart';
import '../services/api.dart'; // Assuming this is where the Api functions are defined

// AttractionResponse class (handles attraction parsing)
class AttractionResponse {
  late List<Attraction> attractions;

  AttractionResponse.fromJson(Map<String, dynamic> json) {
    
    final attractionsMap = json;

    if (attractionsMap.isEmpty) {
      throw Exception('Invalid response format: attractions should be a map');
    }

    attractions = attractionsMap.values.map<Attraction>((item) {
      return Attraction(
        id: item['id'],
        name: item['title'],
        description: item['description'],
        location: item['location'],
        image: item['image'] != null
            ? 'http://10.0.2.2:8000${item['image']}'
            : null,
        price: item['price']?.toString(),
        type: item['category'],
        date: item['duration'],
      );
    }).toList();
  }
}

// Fetch reviews and categories for a specific attraction
  void fetchReviews(String slug) async {
    try {
      var response = await Api.getReviews(slug); // Fetch reviews from API

      if (response.statusCode == 200) {
        var data = response.data;
        var attraction = data['attraction'];  // attraction info
        var categories = data['categories'];  // list of categories

        print('Attraction Details: $attraction');
        print('Categories: $categories');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  // Submit a new review for a specific attraction
  void submitReview(String slug, int rating, String comment) async {
    try {
      var response = await Api.addReview(slug, rating, comment); // Send review to API

      if (response.statusCode == 201) {
        print('Review submitted successfully!');
        print('Review data: ${response.data}'); // Display the submitted review data
      }
    } catch (e) {
      print('Error submitting review: $e');
    }
  
}
