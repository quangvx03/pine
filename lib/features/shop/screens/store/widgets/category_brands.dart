import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/brands/brand_show_case.dart';
import 'package:pine/features/shop/controllers/brand_controller.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/cloud_helper_functions.dart';

import '../../../../../common/widgets/shimmers/boxes_shimmer.dart';
import '../../../../../common/widgets/shimmers/list_tile_shimmer.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller =
        BrandController.getInstance("category_brands_${category.id}");

    return FutureBuilder(
      future: controller.getTopSellingBrandsForCategory(category.id, limit: 2),
      builder: (context, snapshot) {
        const loader = Column(
          children: [
            PListTileShimmer(),
            SizedBox(height: PSizes.spaceBtwItems),
            PBoxesShimmer(),
            SizedBox(height: PSizes.spaceBtwItems)
          ],
        );

        final widget = PCloudHelperFunctions.checkMultiRecordState(
            snapshot: snapshot, loader: loader);
        if (widget != null) return widget;

        /// Record Found
        final brands = snapshot.data!;

        if (brands.isEmpty) {
          return const SizedBox();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          itemBuilder: (_, index) {
            final brand = brands[index];
            return FutureBuilder(
                future:
                    controller.getBrandProducts(brandId: brand.id, limit: 3),
                builder: (context, snapshot) {
                  /// Handle Loader, No Record or Error Message
                  final widget = PCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot, loader: loader);
                  if (widget != null) return widget;

                  /// Record Found
                  final products = snapshot.data!;

                  return PBrandShowcase(
                      brand: brand,
                      images: products.map((e) => e.thumbnail).toList());
                });
          },
        );
      },
    );
  }
}
