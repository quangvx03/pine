import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../controllers/product/product_controller.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(title: Text('Giày'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              /// Banner
              const PRoundedImage(
                  width: double.infinity,
                  imageUrl: PImages.banner3,
                  applyImageRadius: true),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Sub-Categories
              Column(
                children: [
                  /// Heading
                  PSectionHeading(
                    title: 'Giày thể thao',
                    onPressed: () {},
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems / 2),

                  SizedBox(
                    height: 110,
                    // height: 120,
                    child: ListView.separated(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: PSizes.spaceBtwItems),
                        itemBuilder: (context, index) => PProductCardHorizontal(
                            product: ProductModel.empty())),
                  ),
                ],
              ),
              Column(
                children: [
                  /// Heading
                  PSectionHeading(
                    title: 'Giày chạy bộ',
                    onPressed: () {},
                  ),
                  const SizedBox(height: PSizes.spaceBtwItems / 2),

                  SizedBox(
                    height: 110,
                    // height: 120,
                    child: ListView.separated(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: PSizes.spaceBtwItems),
                        itemBuilder: (context, index) => PProductCardHorizontal(
                            product: ProductModel.empty())),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
