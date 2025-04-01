import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart'; // Thêm import
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/models/product_variation_model.dart';
import 'package:pine/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:pine/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:pine/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:readmore/readmore.dart';

// Chuyển sang StatefulWidget
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final variationController = VariationController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetVariations();
    });
  }

  // Reset hoàn toàn các biến thể
  void _resetVariations() {
    variationController.selectedAttributes.clear();
    variationController.selectedVariation.value = ProductVariationModel.empty();
    variationController.variationStockStatus.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(
        showBackArrow: true,
        actions: [
          PFavoriteIcon(productId: widget.product.id),
          PCartCounterIcon(),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: PBottomAddToCart(product: widget.product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            PProductImageSlider(product: widget.product),

            const SizedBox(height: PSizes.spaceBtwItems),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(
                  right: PSizes.defaultSpace,
                  left: PSizes.defaultSpace,
                  bottom: PSizes.defaultSpace),
              child: Column(
                children: [
                  /// Rating
                  const PRatingAndShare(),
                  const SizedBox(height: PSizes.spaceBtwItems / 2),

                  /// Price, Title, Stock & Brand
                  PProductMetaData(product: widget.product),

                  /// Attributes
                  if (widget.product.productType ==
                      ProductType.variable.toString())
                    PProductAttributes(product: widget.product),

                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Description
                  const PSectionHeading(
                      title: 'Mô tả', showActionButton: false),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  ReadMoreText(
                    widget.product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' xem thêm',
                    trimExpandedText: ' thu gọn',
                    moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PColors.primary),
                    lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: PColors.primary),
                  ),

                  /// Reviews
                  const Divider(),
                  const SizedBox(height: PSizes.spaceBtwSections),
                  GestureDetector(
                    onTap: () => Get.to(() => const ProductReviewsScreen()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const PSectionHeading(
                            title: 'Đánh giá (11)', showActionButton: false),
                        IconButton(
                            icon: const Icon(Iconsax.arrow_right_3, size: 18),
                            onPressed: () =>
                                Get.to(() => const ProductReviewsScreen())),
                      ],
                    ),
                  ),
                  const SizedBox(height: PSizes.spaceBtwSections),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
