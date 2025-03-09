import 'package:flutter/material.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';

import '../../../utils/constants/sizes.dart';

class PHorizontalProductShimmer extends StatelessWidget {
  const PHorizontalProductShimmer({super.key,  this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: PSizes.spaceBtwSections),
      height: 105,
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: PSizes.spaceBtwItems),
        itemBuilder: (_, __) => const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Image
            PShimmerEffect(width: 105, height: 105),
            SizedBox(width: PSizes.spaceBtwItems),

            /// Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: PSizes.spaceBtwItems / 2),
                PShimmerEffect(width: 140, height: 15),
                SizedBox(height: PSizes.spaceBtwItems / 2),
                PShimmerEffect(width: 100, height: 15),
                SizedBox(height: PSizes.spaceBtwItems / 2),
                PShimmerEffect(width: 70, height: 15),
                Spacer(),
              ],
            )

          ],
        ),
      ),
    );
  }
}
