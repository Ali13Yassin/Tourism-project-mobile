import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String type;
  final VoidCallback onExplore;

  const DestinationCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.type,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTn_N9oAwlRDE9lUIvjVpcCOXK5ebpB3-20w2J872ETAjZLH5m7ZtWvRl8jU611YQohvFo&usqp=CAU',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
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
                : Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                const SizedBox(height: 4),

                Text(
                  type.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                                Container(
                  padding: const EdgeInsets.symmetric(),
                  child: Text(
                    'From \$$price',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onExplore,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 210, 172, 113), 
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, 
                      children: const [
                        Text('Explore more'),
                        SizedBox(width: 4), 
                        Icon(
                          Icons.arrow_forward, 
                          size: 16,
                          color: Colors.white, 
                        ),
                      ],
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
