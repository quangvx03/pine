import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/shimmers/shimmer.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/features/shop/screens/brand/brand_products.dart';
import 'package:pine/utils/constants/enums.dart';

import '../../../features/shop/models/brand_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';

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
    final dark = PHelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: PRoundedContainer(
        showBorder: true,
        borderColor: PColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(PSizes.md),
        margin: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Brand Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Brand Logo
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: dark ? PColors.darkerGrey : PColors.light,
                    borderRadius: BorderRadius.circular(PSizes.md),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(PSizes.sm),
                    child: CachedNetworkImage(
                      imageUrl: brand.image,
                      fit: BoxFit.contain,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const PShimmerEffect(width: 70, height: 70),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: PColors.error),
                    ),
                  ),
                ),

                const SizedBox(width: PSizes.spaceBtwItems),

                // Brand Name and Products Count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PBrandTitleWithVerifiedIcon(
                        title: brand.name,
                        brandTextSize: TextSizes.large,
                        maxLines: 1,
                      ),
                      const SizedBox(height: PSizes.xs),
                      Text(
                        '${brand.productsCount ?? 0} sản phẩm',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: PSizes.spaceBtwItems),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: PSizes.sm, vertical: PSizes.xs),
              decoration: BoxDecoration(
                color: PColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(PSizes.sm),
              ),
              child: Text(
                'Sản phẩm nổi bật',
                style: Theme.of(context).textTheme.labelSmall!.apply(
                      color: PColors.primary,
                      fontWeightDelta: 1,
                    ),
              ),
            ),

            const SizedBox(height: PSizes.spaceBtwItems),

            /// Brand Top 3 Product Images
            Row(
              children: images.asMap().entries.map((entry) {
                final bool isLastItem = entry.key == images.length - 1;
                return Expanded(
                  child: PRoundedContainer(
                    height: 100,
                    padding: const EdgeInsets.all(PSizes.sm),
                    margin: EdgeInsets.only(right: isLastItem ? 0 : PSizes.sm),
                    backgroundColor: dark ? PColors.darkerGrey : PColors.light,
                    child: CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: entry.value,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const PShimmerEffect(width: 100, height: 100),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
