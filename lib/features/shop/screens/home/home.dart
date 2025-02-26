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
            const PPrimaryHeaderContainer(
                child: Column(
              children: [
                /// Appbar
                PHomeAppBar(),
                SizedBox(height: PSizes.spaceBtwSections),

                /// Searchbar
                PSearchContainer(text: 'Tìm kiếm'),
                SizedBox(height: PSizes.spaceBtwSections),

                /// Categories
                Padding(
                  padding: EdgeInsets.only(left: PSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// Heading
                      PSectionHeading(
                        title: 'Danh mục phổ biến',
                        showActionButton: false,
                        textColor: PColors.white,
                      ),
                      SizedBox(height: PSizes.spaceBtwItems),

                      /// Categories
                      PHomeCategories()
                    ],
                  ),
                ),
                 SizedBox(height: PSizes.spaceBtwSections * 1.5),
              ],
            )),

            /// Body
            Padding(
              padding: const EdgeInsets.all(PSizes.defaultSpace),
              child: Column(
                children: [
                  /// Promo Slider
                  const PPromoSlider(
                    banners: [
                      PImages.promoBanner1,
                      PImages.promoBanner2,
                      PImages.promoBanner3
                    ],
                  ),
                  const SizedBox(height: PSizes.spaceBtwSections),

                  /// Heading
                  PSectionHeading(title: 'Sản phẩm phổ biến', onPressed: () => Get.to(() => const AllProductsScreen())),
                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Popular Products
                  PGridLayout(
                      itemCount: 4,
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
