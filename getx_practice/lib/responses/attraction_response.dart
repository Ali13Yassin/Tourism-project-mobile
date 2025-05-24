import '../models/attraction.dart';

class AttractionResponse {
  late List<Attraction> attractions;
  late int currentPage;
  late int lastPage;

  AttractionResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'];

    if (dataList == null || dataList.isEmpty) {
      throw Exception('No attractions found');
    }

    attractions = List<Attraction>.from(dataList.map((item) => Attraction(
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
          mapImage: item['mapImage'],
        )));

    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }
}