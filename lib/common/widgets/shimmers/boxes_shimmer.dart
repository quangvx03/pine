import 'package:flutter/material.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/utils/constants/sizes.dart';

class PBoxesShimmer extends StatelessWidget {
  const PBoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: PShimmerEffect(width: 150, height: 110)),
            SizedBox(width: PSizes.spaceBtwItems),
            Expanded(child: PShimmerEffect(width: 150, height: 110)),
            SizedBox(width: PSizes.spaceBtwItems),
            Expanded(child: PShimmerEffect(width: 150, height: 110)),
            SizedBox(width: PSizes.spaceBtwItems),
          ],
        )
      ],
    );
  }
}
