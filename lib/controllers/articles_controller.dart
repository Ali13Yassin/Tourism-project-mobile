import 'package:get/get.dart';
import '../models/article.dart';
import '../responses/article_response.dart';
import '../services/api.dart';

class ArticlesController extends GetxController {
  var article = Rxn<Article>();
  var isLoading = false.obs;

  Future<void> fetchArticle(int id) async {
    try {
      isLoading(true);
      final response = await Api.getArticleById(id);
      final parsed = ArticleResponse.fromJson(response.data);
      article.value = parsed.article;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
