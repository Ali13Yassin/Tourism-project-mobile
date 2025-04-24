import '../models/attraction.dart';

class AttractionResponse {
  late List<Attraction> attractions;

  AttractionResponse.fromJson(Map<String, dynamic> json) {
    // We are receiving the attractions as the root-level map
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
