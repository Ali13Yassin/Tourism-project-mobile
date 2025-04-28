class Review {
  final String userName;
  final String comment;
  final int rating; // Assuming you want to include a rating for the review

  Review({
    required this.userName,
    required this.comment,
    this.rating = 5, // Default rating of 5 if not provided
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['userName'],
      comment: json['comment'],
      rating: json['rating'] ?? 5, // Default to 5 if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'comment': comment,
      'rating': rating,
    };
  }
}
