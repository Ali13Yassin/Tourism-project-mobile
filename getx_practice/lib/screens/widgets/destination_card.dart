import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final String image;
  final String title;
  final String? price;
  final String? type;
  final VoidCallback onExplore;

  const DestinationCard({
    Key? key,
    required this.image,
    required this.title,
    this.price,
    this.type,
    required this.onExplore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onExplore,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (type != null) ...[
                    SizedBox(height: 4),
                    Text(
                      type!,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  if (price != null) ...[
                    SizedBox(height: 4),
                    Text(
                      price!,
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}