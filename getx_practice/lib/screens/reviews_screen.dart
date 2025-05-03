import 'package:flutter/material.dart';
import 'package:getx_practice/Styles/colors.dart';
import '../../models/review_model.dart';
import '../../styles/styles.dart';
import 'package:getx_practice/Styles/colors.dart';
class ReviewPage extends StatelessWidget {
  final List<Review> reviews = [
    Review(
      name: "Avery",
      date: "July 2022",
      rating: 5,
      comment:
          "The pyramids are one of the most amazing things I’ve ever seen.",
      imageUrl: "https://i.pravatar.cc/100?img=1",
    ),
    Review(
      name: "Eva",
      date: "June 2022",
      rating: 5,
      comment: "This is an experience that everyone should have.",
      imageUrl: "https://i.pravatar.cc/100?img=2",
    ),
    Review(
      name: "Leo",
      date: "June 2022",
      rating: 4,
      comment: "The pyramids are a must-visit if you’re in Egypt.",
      imageUrl: "https://i.pravatar.cc/100?img=3",
    ),
    Review(
      name: "Emily",
      date: "2 months ago",
      rating: 5,
      comment:
          "I was so excited to see the pyramids and it didn't disappoint. The tour guide was very informative and made the experience even more memorable.",
      imageUrl: "https://i.pravatar.cc/100?img=4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        leading: BackButton(color: primary),
        title: Text("Giza Pyramid", style: AppTextStyles.title),
        backgroundColor: background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingHeader(),
            SizedBox(height: 20),
            ...reviews.map((r) => ReviewTile(review: r)).toList(),
            SizedBox(height: 20),
            ReviewInput(),
          ],
        ),
      ),
    );
  }
}

class RatingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("4.5", style: AppTextStyles.ratingNumber),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20),
            SizedBox(width: 6),
            Text("1.2K reviews", style: AppTextStyles.subText),
          ],
        ),
        SizedBox(height: 12),
        RatingBar(label: "5", percent: 0.70),
        RatingBar(label: "4", percent: 0.20),
        RatingBar(label: "3", percent: 0.07),
        RatingBar(label: "2", percent: 0.02),
        RatingBar(label: "1", percent: 0.01),
      ],
    );
  }
}

class RatingBar extends StatelessWidget {
  final String label;
  final double percent;

  const RatingBar({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label)),
        SizedBox(width: 6),
        Expanded(
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: progressBackground,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
        ),
        SizedBox(width: 8),
        Text("${(percent * 100).round()}%"),
      ],
    );
  }
}

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(review.imageUrl),
            radius: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.name, style: AppTextStyles.reviewName),
                Text(review.date, style: AppTextStyles.reviewDate),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < review.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    );
                  }),
                ),
                SizedBox(height: 4),
                Text(review.comment, style: AppTextStyles.reviewComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
          radius: 20,
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Write a review...",
              hintStyle: AppTextStyles.hintText,
              filled: true,
              fillColor: inputFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_emotions_outlined, color: secondary),
                  SizedBox(width: 8),
                  Icon(Icons.send, color: secondary),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
