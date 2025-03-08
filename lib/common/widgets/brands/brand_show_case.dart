import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/features/shop/screens/brand/brand_products.dart';

import '../../../features/shop/models/brand_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

class PBrandShowcase extends StatelessWidget {
  const PBrandShowcase({
    super.key,
    required this.images,
    required this.brand,
  });

  final BrandModel brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: PRoundedContainer(
        showBorder: true,
        borderColor: PColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(PSizes.md),
        margin: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
        child: Column(
          children: [
            /// Brand with Products Count
            PBrandCard(showBorder: false, brand: brand),
            const SizedBox(height: PSizes.spaceBtwItems),

            /// Brand Top 3 Product Images
            Row(
                children: images
                    .map((image) => brandTopProductImageWidget(image, context))
                    .toList())
          ],
        ),
      ),
    );
  }
}

Widget brandTopProductImageWidget(String image, context) {
  return Expanded(
    child: PRoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(PSizes.md),
        margin: const EdgeInsets.only(right: PSizes.sm),
        backgroundColor: PHelperFunctions.isDarkMode(context)
            ? PColors.darkerGrey
            : PColors.light,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const PShimmerEffect(width: 100, height: 100),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )),
  );
}
