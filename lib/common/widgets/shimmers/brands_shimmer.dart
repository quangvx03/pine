import 'package:flutter/material.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';

class PBrandsShimmer extends StatelessWidget {
  const PBrandsShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return PGridLayout(
      mainAxisExtent: 80,
      itemCount: itemCount,
      itemBuilder: (_, __) => const PShimmerEffect(width: 300, height: 80),
    );
  }
}
