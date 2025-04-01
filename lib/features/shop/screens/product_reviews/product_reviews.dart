import 'package:flutter/material.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:pine/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../../../common/widgets/products/ratings/ratings_indicator.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(
        title: Text('Đánh giá & xếp hạng',
            style: Theme.of(context).textTheme.headlineSmall!.apply(
                color: (PHelperFunctions.isDarkMode(context))
                    ? PColors.white
                    : PColors.black)),
        showBackArrow: true,
      ),

      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Đánh giá và nhận xét đã được xác minh từ những người dùng thực tế.'),
              const SizedBox(height: PSizes.spaceBtwItems),

              /// Overall Product Ratings
              const POverallProductRating(),
              const PRatingBarIndicator(rating: 4.5),
              Text('156', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// User Reviews List
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
              const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
