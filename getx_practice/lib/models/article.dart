class Article {
  final int id;
  final String title;
  final String body;
  final String? image;
  final String? createdAt;

  Article({
    required this.id,
    required this.title,
    required this.body,
    this.image,
    this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['ArticleHeading'],
      body: json['ArticleBody'],
      image: json['Img'] != null ? 'http://10.0.2.2:8000/storage/${json['Img']}' : null,
      createdAt: json['created_at'],
    );
  }
}
