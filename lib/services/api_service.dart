import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination_model.dart';

class ApiService {
  final String baseUrl;
  
  ApiService({required this.baseUrl});
  
  Future<List<Destination>> getDestinations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/destinations'));
      
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Destination> destinations = body.map(
          (item) => Destination.fromJson(item)
        ).toList();
        return destinations;
      } else {
        throw Exception('Failed to load destinations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching destinations: $e');
    }
  }
  
  Future<Destination> getDestination(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/destinations/$id'));
      
      if (response.statusCode == 200) {
        return Destination.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load destination: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching destination: $e');
    }
  }
}