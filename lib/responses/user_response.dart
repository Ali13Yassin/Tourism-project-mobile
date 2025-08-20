import 'package:getx_practice/models/user.dart';

class UserResponse {
  late User user;
  late String? token;

  UserResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    
    if (data == null || data['resource'] == null) {
      throw Exception('Invalid response format: missing data or resource');
    }

    user = User.fromJson(data['resource']); // ✅ Use 'resource' as user
    token = data['token'];
  }
}
