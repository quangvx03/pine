import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:pine/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/features/shop/screens/store/widgets/category_brands.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';

import '../../../../../utils/constants/sizes.dart';

class PCategoryTab extends StatelessWidget {
  const PCategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;

    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(PSizes.defaultSpace),
            child: Column(
              children: [
                /// Brands
                CategoryBrands(category: category),
                const SizedBox(height: PSizes.spaceBtwItems),

                /// Products
                FutureBuilder(
                  future:
                      controller.getCategoryProducts(categoryId: category.id),
                  builder: (context, snapshot) {
                    final response =
                        PCloudHelperFunctions.checkMultiRecordState(
                            snapshot: snapshot,
                            loader: const PVerticalProductShimmer());
                    if (response != null) return response;

                    final products = snapshot.data!;

                    return Column(
                      children: [
                        PSectionHeading(
                            title: 'Gợi ý cho bạn',
                            onPressed: () => Get.to(() => AllProductsScreen(
                                  title: category.name,
                                  showBackArrow: true,
                                  categoryId: category.id,
                                ))),
                        const SizedBox(height: PSizes.spaceBtwItems),
                        PGridLayout(
                          itemCount: products.length,
                          itemBuilder: (_, index) =>
                              PProductCardVertical(product: products[index]),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ]);
  }
}
