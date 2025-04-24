import '../models/attraction.dart';

class AttractionResponse {
  late List<Attraction> attractions;

  AttractionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    if (data == null || data['resources'] == null) {
      throw Exception('Invalid response format: missing data or resources');
    }

    attractions = (data['resources'] as List)
        .map((item) => Attraction.fromJson(item))
        .toList();
  }
}