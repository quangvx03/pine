import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:pine/features/shop/screens/home/widgets/home_categories.dart';
import 'package:pine/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:pine/utils/constants/colors.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                /// Appbar
                PHomeAppBar(),
                SizedBox(height: PSizes.spaceBtwItems),

                /// Searchbar
                PSearchContainer(text: 'Tìm kiếm'),
                SizedBox(height: PSizes.defaultSpace),

                /// Promo Slider
                Padding(
                  padding: EdgeInsets.only(left: PSizes.spaceBtwItems, right: PSizes.spaceBtwItems),
                  child: PPromoSlider(
                    banners: [
                      PImages.bannerbf,
                      PImages.promoBanner1,
                      PImages.promoBanner2,
                      PImages.promoBanner3,
                    ],
                  ),
                ),
                SizedBox(height: PSizes.spaceBtwItems),

                /// Categories
                Padding(
                  padding: EdgeInsets.only(left: PSizes.defaultSpace, right: PSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// Heading
                      PSectionHeading(
                        title: 'Danh mục phổ biến',
                        showActionButton: true,
                      ),
                      /// Categories
                      PHomeCategories()
                    ],
                  ),
                ),
              ],
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              child: Column(
                children: [
                  /// Heading
                  PSectionHeading(
                      title: 'Sản phẩm phổ biến',
                      onPressed: () => Get.to(() => const AllProductsScreen())),
                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Popular Products
                  PGridLayout(
                      itemCount: 6,
                      itemBuilder: (_, index) => const PProductCardVertical()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
