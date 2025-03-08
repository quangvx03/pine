import 'package:flutter/material.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/utils/constants/sizes.dart';

class PListTileShimmer extends StatelessWidget {
  const PListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            PShimmerEffect(
              width: 50,
              height: 50,
              radius: 50,
            ),
            SizedBox(width: PSizes.spaceBtwItems),
            Column(
              children: [
                PShimmerEffect(width: 100, height: 15),
                SizedBox(height: PSizes.spaceBtwItems / 2),
                PShimmerEffect(width: 80, height: 12)
              ],
            )
          ],
        )
      ],
    );
  }
}
