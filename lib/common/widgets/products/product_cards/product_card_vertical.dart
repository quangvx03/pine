import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/styles/shadows.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/screens/product_details/product_detail.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../texts/brand_title_text_with_verified_icon.dart';
import '../../texts/product_price_text.dart';
import '../cart/add_to_cart_button.dart';

class PProductCardVertical extends StatelessWidget {
  const PProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage =
        controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
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
                width: 180,
                padding: const EdgeInsets.all(PSizes.sm),
                backgroundColor: dark ? PColors.dark : PColors.light,
                child: Stack(
                  children: [
                    /// Thumbnail Image
                    Center(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          PRoundedImage(
                            imageUrl: product.thumbnail,
                            applyImageRadius: true,
                            isNetworkImage: true,
                          ),

                          // Hiển thị overlay "Hết hàng" nếu sản phẩm hết tồn kho
                          if (!controller.isProductInStock(
                              product.stock, product.soldQuantity))
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    PColors.darkerGrey.withValues(alpha: 0.7),
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
                                    borderRadius:
                                        BorderRadius.circular(PSizes.sm),
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
                        ],
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
                        child: PFavoriteIcon(productId: product.id))
                  ],
                )),
            const SizedBox(height: PSizes.spaceBtwItems / 2),

            /// Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: PSizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PProductTitleText(
                      title: product.title,
                      smallSize: true,
                    ),
                    SizedBox(height: PSizes.spaceBtwItems / 2),
                    PBrandTitleWithVerifiedIcon(
                        title: product.brand?.name ?? 'Không có thương hiệu'),
                  ],
                ),
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
                          product.salePrice > 0 &&
                          product.salePrice < product.price)
                        Padding(
                            padding: const EdgeInsets.only(
                                left: PSizes.sm, right: 4),
                            child: Text(
                              PHelperFunctions.formatCurrency(product.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                      decoration: TextDecoration.lineThrough),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: PSizes.sm, right: 2),
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

                /// Add to Cart Button
                ProductCardAddToCartButton(
                  product: product,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
