import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:pine/common/widgets/icons/circular_icon.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:pine/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:pine/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:pine/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: PBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            const PProductImageSlider(),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(
                  right: PSizes.defaultSpace,
                  left: PSizes.defaultSpace,
                  bottom: PSizes.defaultSpace),
              child: Column(
                children: [
                  /// Rating & Share Button
                  PRatingAndShare(),

                  /// Price, Title, Stock & Brand
                  PProductMetaData(),

                  /// Attributes
                  PProductAttributes(),
                  const SizedBox(height: PSizes.spaceBtwSections),

                  /// Checkout Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text('Thanh toán'))),
                  const SizedBox(height: PSizes.spaceBtwSections),

                  /// Description
                  const PSectionHeading(
                      title: 'Mô tả', showActionButton: false),
                  const SizedBox(height: PSizes.spaceBtwItems),
                  const ReadMoreText(
                    'Áo thể thao Nike được thiết kế để mang lại sự thoải mái và phong cách cho người sử dụng. Với chất liệu vải cao cấp, áo giúp thoáng khí, thấm hút mồ hôi hiệu quả, giữ cơ thể luôn khô thoáng trong suốt quá trình vận động.',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' xem thêm',
                    trimExpandedText: ' thu gọn',
                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: PColors.primary),
                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: PColors.primary),
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
                            title: 'Đánh giá (156)', showActionButton: false),
                        IconButton(
                            icon: const Icon(Iconsax.arrow_right_3, size: 18),
                            onPressed: () => Get.to(() => const ProductReviewsScreen())),
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const PSectionHeading(
                  //         title: 'Đánh giá (156)', showActionButton: false),
                  //     IconButton(
                  //         icon: const Icon(Iconsax.arrow_right_3, size: 18),
                  //         onPressed: () => Get.to(() => const ProductReviewsScreen())),
                  //   ],
                  // ),
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
