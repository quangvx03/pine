import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/models/review_model.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';
import 'package:pine/utils/constants/sizes.dart';

class POverallProductRating extends StatelessWidget {
  const POverallProductRating({
    super.key,
    required this.productId,
    required this.averageRating,
  });

  final String productId;
  final double averageRating;

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.find<ReviewController>();

    return FutureBuilder<List<ReviewModel>>(
      future: reviewController.getProductReviews(productId),
      builder: (context, snapshot) {
        // Mặc định các giá trị bằng 0 khi chưa có dữ liệu
        Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
        int totalReviews = 0;

        // Nếu có dữ liệu đánh giá, tính toán số lượng cho từng mức sao
        if (snapshot.hasData && snapshot.data != null) {
          final reviews = snapshot.data!;
          totalReviews = reviews.length;

          // Đếm số lượng đánh giá cho mỗi mức sao
          for (var review in reviews) {
            final rating = review.rating.round();
            if (rating >= 1 && rating <= 5) {
              ratingCounts[rating] = (ratingCounts[rating] ?? 0) + 1;
            }
          }
        }

        return Column(
          children: [
            PRatingProgressIndicator(
              text: '5',
              value: totalReviews > 0 ? ratingCounts[5]! / totalReviews : 0,
            ),
            const SizedBox(height: PSizes.xs),
            PRatingProgressIndicator(
              text: '4',
              value: totalReviews > 0 ? ratingCounts[4]! / totalReviews : 0,
            ),
            const SizedBox(height: PSizes.xs),
            PRatingProgressIndicator(
              text: '3',
              value: totalReviews > 0 ? ratingCounts[3]! / totalReviews : 0,
            ),
            const SizedBox(height: PSizes.xs),
            PRatingProgressIndicator(
              text: '2',
              value: totalReviews > 0 ? ratingCounts[2]! / totalReviews : 0,
            ),
            const SizedBox(height: PSizes.xs),
            PRatingProgressIndicator(
              text: '1',
              value: totalReviews > 0 ? ratingCounts[1]! / totalReviews : 0,
            ),
          ],
        );
      },
    );
  }
}
