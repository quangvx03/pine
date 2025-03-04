import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/appbar/tabbar.dart';
import 'package:pine/common/widgets/brands/brand_card.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/screens/brand/all_brands.dart';
import 'package:pine/features/shop/screens/store/widgets/category_tab.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../common/widgets/images/circular_image.dart';
import '../../../../common/widgets/texts/brand_title_text_with_verified_icon.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoryController.instance.featuredCategories;

    return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: PAppBar(
            title: Text('Cửa hàng',
                style: Theme.of(context).textTheme.headlineMedium),
            actions: [
              PCartCounterIcon(
                onPressed: () {},
                iconColor: (PHelperFunctions.isDarkMode(context))
                    ? PColors.light
                    : PColors.dark,
              )
            ],
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
                      padding: const EdgeInsets.symmetric(horizontal:  PSizes.defaultSpace),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          /// Search bar
                          const SizedBox(height: PSizes.spaceBtwItems),
                          const PSearchContainer(
                              text: 'Tìm kiếm',
                              showBorder: true,
                              showBackground: false,
                              padding: EdgeInsets.zero),
                          const SizedBox(height: PSizes.spaceBtwItems),

                          /// Featured Brands
                          PSectionHeading(
                              title: 'Thương hiệu nổi bật', onPressed: () => Get.to(() => const AllBrandsScreen())),
                          const SizedBox(height: PSizes.spaceBtwItems / 1.5),

                          /// Brands
                          PGridLayout(
                              itemCount: 4,
                              mainAxisExtent: 80,
                              itemBuilder: (_, index) {
                                return const PBrandCard(showBorder: true);
                              }),
                        ],
                      ),
                    ),

                    /// Tabs
                    bottom:  PTabBar(
                      tabs: categories.map((category) => Tab(child: Text(category.name))).toList(),
                    ),
                  )
                ];
              },

              /// Body
              body: TabBarView(
                children: categories.map((category) => PCategoryTab(category: category)).toList()
              )),
        ));
  }
}
