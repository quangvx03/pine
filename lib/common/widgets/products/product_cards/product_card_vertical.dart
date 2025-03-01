import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/styles/shadows.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/screens/product_details/product_detail.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../icons/circular_icon.dart';
import '../../texts/brand_title_text_with_verified_icon.dart';
import '../../texts/product_price_text.dart';

class PProductCardVertical extends StatelessWidget {
  const PProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetailScreen()),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [PShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(PSizes.productImageRadius),
          color: dark ? PColors.darkerGrey : PColors.white,
        ),
        child: Column(
          children: [
            /// Thumbnail, WishList Button, Sale Tag
            PRoundedContainer(
                height: 150,
                padding: const EdgeInsets.all(PSizes.sm),
                backgroundColor: dark ? PColors.dark : PColors.light,
                child: Stack(
                  children: [
                    /// Thumbnail Image
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: PRoundedImage(
                          imageUrl: PImages.productImage1,
                          applyImageRadius: true,
                        ),
                      ),
                    ),

                    /// Sale Tag
                    Positioned(
                      top: 0,
                      child: PRoundedContainer(
                        radius: PSizes.sm,
                        backgroundColor:
                            PColors.secondary.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: PSizes.sm, vertical: PSizes.xs),
                        child: Text('25%',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: PColors.black)),
                      ),
                    ),

                    /// Favorite Icon Button
                    Positioned(
                        top: 0,
                        right: 0,
                        child: PCircularIcon(
                          width: 35,
                          height: 35,
                          size: 20,
                          icon: Iconsax.heart5,
                          color: PColors.favorite,
                        ))
                  ],
                )),
            const SizedBox(height: PSizes.spaceBtwItems / 2),

            /// Details
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: PSizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PProductTitleText(
                      title: 'Sữa TH True Milk',
                      smallSize: true,
                    ),
                    SizedBox(height: PSizes.spaceBtwItems / 2),
                    PBrandTitleWithVerifiedIcon(title: 'TH'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Price
                Padding(
                  padding: const EdgeInsets.only(left: PSizes.sm),
                  child: const PProductPriceText(price: '12,000'),
                ),

                /// Add to Cart Button
                Container(
                  decoration: const BoxDecoration(
                      color: PColors.dark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(PSizes.cardRadiusMd),
                        bottomRight: Radius.circular(PSizes.productImageRadius),
                      )),
                  child: const SizedBox(
                    width: PSizes.iconLg * 1.2,
                    height: PSizes.iconLg * 1.2,
                    child:
                        Center(child: Icon(Iconsax.add, color: PColors.white)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
