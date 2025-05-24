import '../models/article.dart';

class ArticleResponse {
  late Article article;

  ArticleResponse.fromJson(Map<String, dynamic> json) {
    if (json['success'] == true && json['data'] != null) {
      article = Article.fromJson(json['data']);
    } else {
      throw Exception('Invalid article data');
    }
  }
}
