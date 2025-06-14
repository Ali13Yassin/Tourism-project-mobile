class Attraction {
  final int id;
  final String name;
  final String? description;
  final String? location;
  final String? image;
  final String? price;
  final String? type;
  final String? date;
  final String? mapImage;


  Attraction({
    required this.id,
    required this.name,
    this.description,
    this.location,
    this.image,
    this.price,
    this.type,
    this.date,
    this.mapImage,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      image: json['image'],
      price: json['price'],
      type: json['type'],
      date: json['date'],
      mapImage: json['map_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'image': image,
      'price': price,
      'type': type,
      'date': date,
      'mapImage': mapImage,
    };
  }
}