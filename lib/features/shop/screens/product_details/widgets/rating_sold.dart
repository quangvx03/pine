import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/review_controller.dart';
import 'package:pine/features/shop/screens/product_reviews/product_reviews.dart';
import '../../../../../utils/constants/sizes.dart';

class PRatingAndSold extends StatelessWidget {
  const PRatingAndSold({
    super.key,
    required this.productId,
    this.soldQuantity,
  });

  final String productId;
  final int? soldQuantity;

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.put(ReviewController(), permanent: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Rating
        FutureBuilder<Map<String, dynamic>>(
          future: reviewController.getProductRatingSummary(productId),
          builder: (context, snapshot) {
            final data = snapshot.data ?? {'count': 0, 'average': 0.0};
            final averageRating = data['average'] as double;
            final reviewCount = data['count'] as int;

            // if (reviewCount <= 0) {
            //   return const SizedBox();
            // }

            return GestureDetector(
              onTap: () =>
                  Get.to(() => ProductReviewsScreen(productId: productId)),
              child: Row(
                children: [
                  const Icon(Iconsax.star5, color: Colors.amber, size: 24),
                  const SizedBox(width: PSizes.xs),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: '${averageRating.toStringAsFixed(1)} ',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextSpan(text: '($reviewCount)'),
                  ])),
                ],
              ),
            );
          },
        ),

        /// Số lượng đã bán
        // if (soldQuantity != null && soldQuantity! > 0)
        Text('Đã bán $soldQuantity',
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
