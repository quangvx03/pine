import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/products/cart/add_to_cart_button.dart';
import 'package:pine/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/product_details/product_detail.dart';
import '../../../../utils/constants/enums.dart';

class PProductCardHorizontal extends StatelessWidget {
  const PProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);

    final isInStock =
        controller.isProductInStock(product.stock, product.soldQuantity);

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
              height: 115,
              padding: const EdgeInsets.all(PSizes.sm),
              backgroundColor: dark ? PColors.dark : PColors.white,
              child: Stack(
                children: [
                  /// Thumbnail Image
                  SizedBox(
                      height: 115,
                      width: 110,
                      child: PRoundedImage(
                        imageUrl: product.thumbnail,
                        applyImageRadius: true,
                        isNetworkImage: true,
                      )),

                  if (!isInStock)
                    Container(
                      width: 110,
                      decoration: BoxDecoration(
                        color: PColors.darkerGrey.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(
                            PSizes.productImageRadius + 2),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PSizes.sm,
                            vertical: PSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: PColors.error.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(PSizes.sm),
                          ),
                          child: const Text(
                            'Hết hàng',
                            style: TextStyle(
                              color: PColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                  /// Sale Tag
                  if (salePercentage != null)
                    Positioned(
                      top: 0,
                      child: PRoundedContainer(
                        radius: PSizes.sm,
                        backgroundColor:
                            PColors.secondary.withValues(alpha: 0.8),
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
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PProductTitleText(
                                  title: product.title, smallSize: true),
                              SizedBox(height: PSizes.spaceBtwItems / 2),
                              PBrandTitleWithVerifiedIcon(
                                  title: product.brand!.name),
                            ],
                          ),
                        )),
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
                                  product.salePrice > 0 &&
                                  product.salePrice < product.price)
                                Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Text(
                                      PHelperFunctions.formatCurrency(
                                          product.price),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              Padding(
                                padding: const EdgeInsets.only(right: 2),
                                // padding: EdgeInsets.zero,
                                child: PProductPriceText(
                                  price: (product.salePrice > 0 &&
                                              product.salePrice < product.price
                                          ? product.salePrice
                                          : product.price)
                                      .toString(),
                                ),
                              )
                            ],
                          ),
                        ),

                        ProductCardAddToCartButton(
                          product: product,
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
