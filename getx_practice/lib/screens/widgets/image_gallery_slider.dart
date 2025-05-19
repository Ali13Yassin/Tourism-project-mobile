import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageGallerySlider extends StatelessWidget {
  final List<String> imageUrls;
  final double height;
  final double borderRadius;

  const ImageGallerySlider({
    Key? key,
    required this.imageUrls,
    this.height = 280,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        viewportFraction: 1.0,
        enableInfiniteScroll: imageUrls.length > 1,
        enlargeCenterPage: false,
        autoPlay: imageUrls.length > 1,
      ),
      items: imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              child: Image.network(
                url,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: height,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
} 