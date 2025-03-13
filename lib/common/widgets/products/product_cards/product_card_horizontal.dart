import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/styles/shadows.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/product_details/product_detail.dart';
import '../../../../utils/constants/enums.dart';
import '../../icons/circular_icon.dart';

class PProductCardHorizontal extends StatelessWidget {
  const PProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 275,
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
              padding: const EdgeInsets.all(PSizes.sm),
              backgroundColor: dark ? PColors.dark : PColors.white,
              child: Stack(
                children: [
                  /// Thumbnail Image
                  SizedBox(
                      height: 110,
                      width: 110,
                      child: PRoundedImage(
                          imageUrl: product.thumbnail,
                          applyImageRadius: true, isNetworkImage: true,)),

                  /// Sale Tag
                  if(salePercentage != null)
                  Positioned(
                    top: 0,
                    child: PRoundedContainer(
                      radius: PSizes.sm,
                      backgroundColor: PColors.secondary.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: PSizes.sm, vertical: PSizes.xs),
                      child: Text('$salePercentage%',
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
                      child: PFavoriteIcon(
                        productId: product.id,
                      ))
                ],
              ),
            ),

            /// Details
            SizedBox(
              width: 147,
              child: Padding(
                padding: EdgeInsets.only(top: PSizes.sm, left: PSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PProductTitleText(
                              title: product.title, smallSize: true),
                          SizedBox(height: PSizes.spaceBtwItems / 2),
                          PBrandTitleWithVerifiedIcon(title: product.brand!.name),
                        ],
                      ),
                    ),
                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Price
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.productType ==
                                  ProductType.single.toString() &&
                                  product.salePrice > 0)
                                Padding(
                                    // padding: const EdgeInsets.only(left: PSizes.sm),
                                  padding: EdgeInsets.zero,
                                    child: Text(
                                      PHelperFunctions.formatCurrency(product.price),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                          decoration: TextDecoration.lineThrough),
                                    )),
                              Padding(
                                // padding: const EdgeInsets.only(left: PSizes.sm),
                                padding: EdgeInsets.zero,
                                child: PProductPriceText(
                                  price: (product.salePrice > 0
                                      ? product.salePrice
                                      : product.price)
                                      .toString(),
                                ),
                              )
                            ],
                          ),
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
            )
          ],
        ),
      ),
    );
  }
}
