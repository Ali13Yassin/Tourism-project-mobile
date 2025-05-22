import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:getx_practice/Styles/colors.dart';

class ExperienceItem extends StatelessWidget {
  final String image;
  final String title;
  final String date;

  const ExperienceItem({
    super.key,
    required this.image,
    required this.title,
    required this.date,
  });

  static const String defaultImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTn_N9oAwlRDE9lUIvjVpcCOXK5ebpB3-20w2J872ETAjZLH5m7ZtWvRl8jU611YQohvFo&usqp=CAU';

  String formatDate(String inputDate) {
    try {
      final parsedDate = DateTime.parse(inputDate);
      return DateFormat('MMMM d, y').format(parsedDate); // e.g., May 21, 2025
    } catch (e) {
      return inputDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image.isNotEmpty
              ? Image.network(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      defaultImage,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Image.network(
                  defaultImage,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Article",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Published •                  ${formatDate(date)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
