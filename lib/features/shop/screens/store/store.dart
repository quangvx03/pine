import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/appbar/tabbar.dart';
import 'package:pine/common/widgets/brands/brand_card.dart';
import 'package:pine/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/screens/brand/all_brands.dart';
import 'package:pine/features/shop/screens/brand/brand_products.dart';
import 'package:pine/features/shop/screens/store/widgets/category_tab.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/shimmers/brands_shimmer.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;

    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: PAppBar(
            title: Text('Cửa hàng',
                style: Theme.of(context).textTheme.headlineMedium),
            actions: [PCartCounterIcon()],
          ),
          body: NestedScrollView(

              /// Header
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    expandedHeight: 390,
                    automaticallyImplyLeading: false,
                    backgroundColor: PHelperFunctions.isDarkMode(context)
                        ? PColors.black
                        : PColors.white,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: PSizes.defaultSpace),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          /// Search bar
                          const SizedBox(height: PSizes.spaceBtwItems),
                          const PSearchContainer(
                              text: 'Tìm kiếm',
                              showBorder: true,
                              padding: EdgeInsets.zero),
                          const SizedBox(height: PSizes.spaceBtwItems),

                          /// Featured Brands
                          PSectionHeading(
                              title: 'Thương hiệu nổi bật',
                              onPressed: () =>
                                  Get.to(() => const AllBrandsScreen())),
                          const SizedBox(height: PSizes.spaceBtwItems / 1.5),

                          /// Brands Grid
                          Obx(
                            () {
                              if (brandController.isLoading.value) {
                                return const PBrandsShimmer();
                              }

                              if (brandController.featuredBrands.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Không tìm thấy dữ liệu!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: Colors.white),
                                  ),
                                );
                              }

                              return PGridLayout(
                                itemCount:
                                    brandController.featuredBrands.length,
                                mainAxisExtent: 80,
                                itemBuilder: (_, index) {
                                  final brand =
                                      brandController.featuredBrands[index];
                                  return PBrandCard(
                                    showBorder: true,
                                    brand: brand,
                                    onTap: () => Get.to(
                                        () => BrandProducts(brand: brand)),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    /// Tabs
                    bottom: PTabBar(
                      tabs: categories
                          .map((category) => Tab(child: Text(category.name)))
                          .toList(),
                    ),
                  )
                ];
              },

              /// Body
              body: TabBarView(
                  children: categories
                      .map((category) => PCategoryTab(category: category))
                      .toList())),
        ));
  }
}
