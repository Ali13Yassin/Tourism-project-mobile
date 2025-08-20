import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfigService extends GetxController {
  static ConfigService get instance => Get.find<ConfigService>();
  
  final GetStorage _storage = GetStorage();
  
  // Default server URL
  static const String _defaultServerUrl = 'http://192.168.100.13:8000';
  static const String _serverUrlKey = 'server_url';
  
  // Observable server URL
  var serverUrl = _defaultServerUrl.obs;
  @override
  void onInit() {
    super.onInit();
    _loadServerUrl();
  }
  
  /// Load server URL from storage
  void _loadServerUrl() {
    final savedUrl = _storage.read(_serverUrlKey);
    if (savedUrl != null && savedUrl.isNotEmpty) {
      serverUrl.value = savedUrl;
    }
  }
  
  /// Get current server URL
  String get currentServerUrl => serverUrl.value;
  
  /// Update server URL
  Future<void> updateServerUrl(String newUrl) async {
    // Validate URL format
    if (!_isValidUrl(newUrl)) {
      throw Exception('Invalid URL format');
    }
    
    // Remove trailing slash if present
    String cleanUrl = newUrl.endsWith('/') ? newUrl.substring(0, newUrl.length - 1) : newUrl;
    
    // Update observable and storage
    serverUrl.value = cleanUrl;
    await _storage.write(_serverUrlKey, cleanUrl);
  }
  
  /// Reset to default server URL
  Future<void> resetToDefault() async {
    serverUrl.value = _defaultServerUrl;
    await _storage.write(_serverUrlKey, _defaultServerUrl);
  }
  
  /// Validate URL format
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  /// Check if current URL is default
  bool get isDefaultUrl => serverUrl.value == _defaultServerUrl;
  
  /// Get default URL
  String get defaultUrl => _defaultServerUrl;
}
