import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:pine/features/shop/screens/home/widgets/home_categories.dart';
import 'package:pine/features/shop/screens/home/widgets/promo_slider.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/product_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

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
                SizedBox(height: PSizes.defaultSpace * 1.25),

                /// Promo Slider
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
                  child: PPromoSlider(),
                ),
                SizedBox(height: PSizes.spaceBtwSections),

                /// Categories
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
                  child: Column(
                    children: [
                      /// Heading
                      PSectionHeading(
                        title: 'Danh mục phổ biến',
                        showActionButton: false,
                      ),
                      SizedBox(height: PSizes.defaultSpace),

                      /// Categories
                      PHomeCategories()
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: PSizes.spaceBtwItems / 1.5),

            /// Body
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
              child: Column(
                children: [
                  /// Heading
                  PSectionHeading(
                      title: 'Sản phẩm phổ biến',
                      onPressed: () => Get.to(() => AllProductsScreen(
                            title: 'Sản phẩm phổ biến',
                            futureMethod: controller.fetchAllFeaturedProducts(),
                          ))),
                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Popular Products
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const PVerticalProductShimmer();
                    }

                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                          child: Text('Không có dữ liệu!',
                              style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return PGridLayout(
                        itemCount: controller.featuredProducts.length,
                        itemBuilder: (_, index) => PProductCardVertical(
                            product: controller.featuredProducts[index]));
                  }),
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
