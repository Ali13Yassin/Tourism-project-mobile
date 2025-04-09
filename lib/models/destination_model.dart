class Destination {
  final String id;
  final String name;
  final String image;
  final String price;
  final String location;
  final String description;

  Destination({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.location,
    required this.description,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }
}