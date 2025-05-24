import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/articles_controller.dart';
import 'package:getx_practice/Styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

    // Avoid refetching if already loaded
    if (controller.article.value?.id != articleId) {
      controller.fetchArticle(articleId);
    }

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
            // Top Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
  imageUrl: article.image ?? 'https://via.placeholder.com/600x280.png?text=No+Image',
  placeholder: (context, url) => const SizedBox(
    height: 280,
    child: Center(child: CircularProgressIndicator()),
  ),
  errorWidget: (context, url, error) => const SizedBox(
    height: 280,
    child: Center(child: Icon(Icons.broken_image, size: 40)),
  ),
  height: 280,
  width: double.infinity,
  fit: BoxFit.cover,
  fadeInDuration: const Duration(milliseconds: 300),
  fadeOutDuration: const Duration(milliseconds: 300),
  maxWidthDiskCache: 400,
),

                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: icons,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: primary),
                      onPressed: () => Get.back(),
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
                      if (article.createdAt != null)
                        Text(
                          'Published: ${formatDate(article.createdAt!)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: text,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 16),
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
