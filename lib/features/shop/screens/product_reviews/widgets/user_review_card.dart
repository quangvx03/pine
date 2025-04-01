import 'package:flutter/material.dart';
import 'package:pine/common/widgets/products/ratings/ratings_indicator.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        const Divider(),
        const SizedBox(
          height: PSizes.spaceBtwItems,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                    backgroundImage: AssetImage(PImages.userProfileImage1)),
                const SizedBox(width: PSizes.spaceBtwItems),
                Text('Nguyễn Văn A',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(width: PSizes.spaceBtwItems),

        /// Review
        Row(
          children: [
            const PRatingBarIndicator(rating: 4),
            const SizedBox(width: PSizes.spaceBtwItems),
            Text('29/01/2025', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),

        const SizedBox(height: PSizes.spaceBtwItems),
        const ReadMoreText(
          'Áo thể thao Nike rất thoải mái, chất liệu thoáng mát và thấm hút mồ hôi tốt, phù hợp cho các buổi tập luyện. Thiết kế đơn giản nhưng đẹp mắt, dễ phối đồ. Sau nhiều lần giặt, áo vẫn giữ form và màu sắc như mới. Rất đáng tiền, phù hợp với nhiều hoạt động thể thao.',
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' xem thêm',
          trimExpandedText: ' thu gọn',
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: PColors.primary),
          lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: PColors.primary),
        ),
        const SizedBox(height: PSizes.spaceBtwItems),

        /// Company Review
        // PRoundedContainer(
        //   backgroundColor: dark ? PColors.darkerGrey : PColors.grey,
        //   child: Padding(
        //     padding: const EdgeInsets.all(PSizes.md),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Pine Store',
        //                 style: Theme.of(context).textTheme.titleMedium),
        //             Text('29/01/2025',
        //                 style: Theme.of(context).textTheme.titleMedium),
        //           ],
        //         ),
        //         const SizedBox(height: PSizes.spaceBtwItems),
        //         const ReadMoreText(
        //           'Cảm ơn quý khách đã tin tưởng và ủng hộ cửa hàng. Rất mong được phục vụ quý khách trong những lần mua sắm tiếp theo!',
        //           trimLines: 3,
        //           trimMode: TrimMode.Line,
        //           trimCollapsedText: ' xem thêm',
        //           trimExpandedText: ' thu gọn',
        //           moreStyle: TextStyle(
        //               fontSize: 14,
        //               fontWeight: FontWeight.bold,
        //               color: PColors.primary),
        //           lessStyle: TextStyle(
        //               fontSize: 14,
        //               fontWeight: FontWeight.bold,
        //               color: PColors.primary),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: PSizes.spaceBtwSections,
        // )
      ],
    );
  }
}
