import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/layouts/grid_layout.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/models/category_model.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class PCategoryTab extends StatelessWidget {
  const PCategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [ Padding(
        padding: EdgeInsets.all(PSizes.defaultSpace),
        child: Column(
          children: [
            /// Brands
            PBrandShowcase(
              images: [
                PImages.productImage3,
                PImages.productImage2,
                PImages.productImage1
              ],
            ),PBrandShowcase(
              images: [
                PImages.productImage4,
                PImages.productImage5,
                PImages.productImage6
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwItems),
      
            /// Products
            PSectionHeading(title: 'Gợi ý cho bạn', onPressed: () => Get.to(() => const AllProductsScreen())),
            const SizedBox(height: PSizes.spaceBtwItems),
            
            PGridLayout(itemCount: 6, itemBuilder: (_, index) => const PProductCardVertical()),
          ],
        ),
      ),]
    );
  }
}
