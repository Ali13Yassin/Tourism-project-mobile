import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:getx_practice/models/attraction.dart';
import 'package:getx_practice/screens/widgets/map_tooltip.dart';
import '../../controllers/attractions_controller.dart';
import '../models/attraction.dart';
import 'package:getx_practice/screens/booking_details_screen.dart';
import 'package:getx_practice/screens/reviews_screen.dart';
import 'package:getx_practice/Styles/colors.dart';
import 'package:getx_practice/utils/location_utils.dart';
import 'package:getx_practice/utils/slugify.dart';
import 'package:getx_practice/screens/widgets/image_gallery_slider.dart';

class AttractionDetailsScreen extends StatelessWidget {
  final String attractionName;

  const AttractionDetailsScreen({super.key, required this.attractionName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttractionsController>();

    return Scaffold(
      backgroundColor: background,
<<<<<<< Updated upstream
      body: Column(
        children: [
          Stack(
            children: [
              ImageGallerySlider(
                imageUrls: (attraction.gallery != null && attraction.gallery!.isNotEmpty)
                    ? attraction.gallery!
                    : (attraction.image != null ? [attraction.image!] : []),
                height: 280,
                borderRadius: 20,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                child: CircleAvatar(
                  backgroundColor: icons,
                  child: IconButton(
                    icon:  Icon(Icons.arrow_back, color: primary),
                    onPressed: () => Navigator.of(context).pop(),
=======
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final attraction = controller.attractionsList.firstWhere(
          (element) => element.name == attractionName,
          orElse: () => Attraction(
            id: 0,
            name: 'Not Found',
            description: 'Attraction not found.',
            location: null,
            image: null,
            price: null,
            type: null,
            date: null,
            mapImage: null,
          ),
        );

        return Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: attraction.image ?? '',
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 280,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 280,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Icon(Icons.image, size: 50),
                    ),
>>>>>>> Stashed changes
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: icons,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: primary),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
<<<<<<< Updated upstream
            ],
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration:  BoxDecoration(
                color: icons,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (attraction.type != null)
                      Text(
                        attraction.type!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 210, 172, 113),
=======
                if (attraction.price != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'From ${attraction.price} LE',
                        style: TextStyle(
                          color: icons,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
>>>>>>> Stashed changes
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: icons,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Attraction Type
                      if (attraction.type != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              attraction.type!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFD4B98A),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Attraction Name
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            attraction.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Description
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            attraction.description ?? 'No description available.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: primary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Location Section
                      Text(
                        'Location',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (attraction.location != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_city, color: secondary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    attraction.location!,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (attraction.mapImage != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Builder(
                              builder: (_) {
                                final coords = extractLatLngFromUrl(attraction.mapImage!);
                                if (coords == null) return const SizedBox.shrink();
                                return MapWithTooltip(
                                  coords: coords,
                                  attractionName: attraction.name,
                                  mapImageUrl: attraction.mapImage!,
                                  primary: primary ?? Colors.blue,
                                  icons: icons ?? Colors.grey,
                                  onTap: (url) => openInGoogleMaps(url),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Buttons
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Get.to(
                                  () => BookingDetailsScreen(),
                                  arguments: {'location': attraction.location},
                                );
                              },
                              color: const Color(0xFFD4B98A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Book now',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: icons,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            MaterialButton(
                              onPressed: () {
                                final slug = slugify(attraction.name);
                                Get.to(() => ReviewsScreen(slug: slug));
                              },
                              color: const Color(0xFFD4B98A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: icons,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}