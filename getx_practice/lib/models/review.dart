class Review {
  final String userName;
  final String comment;
  final int rating;
  final String createdAt; // New: capture review date

  Review({
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName:
          json['tourist'] != null
              ? json['tourist']['name'] ?? 'Unknown'
              : 'Anonymous',
      comment: json['comment'],
      rating: json['rating'] ?? 5,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt,
    };
  }
}
