import 'package:flutter/material.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/utils/constants/sizes.dart';

class PCategoryShimmer extends StatelessWidget {
  const PCategoryShimmer({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: PSizes.spaceBtwItems,
        crossAxisSpacing: PSizes.spaceBtwItems / 2,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            const PShimmerEffect(width: 55, height: 55, radius: 55),
            const SizedBox(height: PSizes.spaceBtwItems / 2),

            // Text
            const PShimmerEffect(width: 55, height: 8)
          ],
        );
      },
    );
  }
}
