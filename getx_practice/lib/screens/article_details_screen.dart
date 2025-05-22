import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/articles_controller.dart';
import 'package:getx_practice/Styles/colors.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final int articleId;

  const ArticleDetailsScreen({super.key, required this.articleId});
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
    final controller = Get.put(ArticlesController());

    controller.fetchArticle(articleId);

    return Scaffold(
      backgroundColor: background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final article = controller.article.value;

        if (article == null) {
          return const Center(child: Text('Article not found.'));
        }

        return Column(
          children: [
            // Top Image Section with Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    article.image ?? '',
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      width: double.infinity,
                      color: progressBackground,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: icons,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: primary),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: icons,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      if (article.createdAt != null)
                        Text(
                          'Published: ${formatDate(article.createdAt!)}',
                          style:  TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: text,
                          ),
                        ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Body
                      Text(
                        article.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: primary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
