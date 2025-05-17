class Review {
  final int id;
  final int rating;
  final String comment;
  final String? name;
  final String? email;
  final String createdAt;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    this.name,
    this.email,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      name: json['tourist']?['name'],
      email: json['tourist']?['email'],
      createdAt: json['created_at'],
    );
  }
}