import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/styles/shadows.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../features/shop/screens/product_details/product_detail.dart';
import '../../icons/circular_icon.dart';

class PProductCardHorizontal extends StatelessWidget {
  const PProductCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => const ProductDetailScreen()),
      child: Container(
        width: 275,
        // width: 310,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PSizes.productImageRadius),
          color: dark ? PColors.darkerGrey : PColors.lightContainer,
        ),
        child: Row(
          children: [
            /// Thumbnail
            PRoundedContainer(
              height: 110,
              // height: 120,
              padding: const EdgeInsets.all(PSizes.sm),
              backgroundColor: dark ? PColors.dark : PColors.white,
              child: Stack(
                children: [
                  /// Thumbnail Image
                  SizedBox(
                      height: 110,
                      width: 110,
                      // height: 120,
                      // width: 120,
                      child: PRoundedImage(
                          imageUrl: PImages.productImage1,
                          applyImageRadius: true)),

                  /// Sale Tag
                  Positioned(
                    top: 0,
                    child: PRoundedContainer(
                      radius: PSizes.sm,
                      backgroundColor: PColors.secondary.withValues(alpha: 0.8),
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
                  const Positioned(
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
              ),
            ),

            /// Details
             SizedBox(
              width: 147,
              // width: 172,
              child: Padding(
                padding: EdgeInsets.only(top: PSizes.sm, left: PSizes.sm),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PProductTitleText(
                              title: 'Giày Nike Air', smallSize: true),
                          SizedBox(height: PSizes.spaceBtwItems / 2),
                          PBrandTitleWithVerifiedIcon(title: 'Nike'),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Pricing
                        const Flexible(child: PProductPriceText(price: '1,250,000')),

                        /// Add to cart
                        Container(
                          decoration: const BoxDecoration(
                            color: PColors.dark,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(PSizes.cardRadiusMd),
                              bottomRight: Radius.circular(PSizes.productImageRadius),
                            )
                          ),
                          child: const SizedBox(
                            width: PSizes.iconLg * 1.2,
                            height: PSizes.iconLg * 1.2,
                            child: Center(child: Icon(Iconsax.add, color: PColors.white),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
