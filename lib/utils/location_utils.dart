import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

LatLng? extractLatLngFromUrl(String url) {
  final regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
  final match = regex.firstMatch(url);
  if (match != null && match.groupCount == 2) {
    final lat = double.tryParse(match.group(1)!);
    final lng = double.tryParse(match.group(2)!);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
  }
  return null;
}



Future<void> openInGoogleMaps(String mapUrl) async {
  final Uri url = Uri.parse(mapUrl);

  try {
    // Launch the URL directly
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    print("Error launching Google Maps: $e");
  }
}
