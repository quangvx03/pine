import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:pine/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/category_controller.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar: PAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              PRoundedImage(
                  width: double.infinity,
                  height: 100,
                  imageUrl: category.image,
                  fit: BoxFit.contain,
                  applyImageRadius: true,
                  isNetworkImage: true),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Sub-Categories
              FutureBuilder(
                future: controller.getSubCategories(category.id),
                builder: (context, snapshot) {
                  /// Handle loader, no record or error message
                  const loader = PHorizontalProductShimmer();
                  final widget = PCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  /// Record found
                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final subCategory = subCategories[index];

                      return FutureBuilder(
                          future: controller.getCategoryProducts(
                              categoryId: subCategory.id),
                          builder: (context, snapshot) {
                            /// Handle loader, no record or error message
                            final widget =
                                PCloudHelperFunctions.checkMultiRecordState(
                                    snapshot: snapshot, loader: loader);
                            if (widget != null) return widget;

                            /// Record found
                            final products = snapshot.data!;

                            return Column(
                              children: [
                                /// Heading
                                PSectionHeading(
                                  title: subCategory.name,
                                  onPressed: () =>
                                      Get.to(() => AllProductsScreen(
                                            title: subCategory.name,
                                            showBackArrow: true,
                                            categoryId: subCategory.id,
                                          )),
                                ),
                                const SizedBox(
                                    height: PSizes.spaceBtwItems / 2),

                                SizedBox(
                                  height: 115,
                                  child: ListView.separated(
                                      itemCount: products.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                              width: PSizes.spaceBtwItems),
                                      itemBuilder: (context, index) =>
                                          PProductCardHorizontal(
                                              product: products[index])),
                                ),

                                const SizedBox(height: PSizes.spaceBtwItems),
                              ],
                            );
                          });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
