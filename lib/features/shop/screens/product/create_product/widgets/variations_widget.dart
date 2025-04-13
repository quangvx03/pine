import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:pine_admin_panel/features/shop/models/product_variation_model.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';

import '../../../../../../../utils/constants/sizes.dart';


class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    final variationController = ProductVariationController.instance;

    return Obx(
      () => CreateProductController.instance.productType.value == ProductType.variable
      ? PRoundedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Variations Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thể loại sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
                TextButton(
                    onPressed: () => variationController.removeVariations(context),
                    child: const Text('Xóa thể loại')),
              ],
            ),
            const SizedBox(height: PSizes.spaceBtwItems),

            // Variations List
            if (variationController.productVariations.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
                separatorBuilder: (_, __) => const SizedBox(height: PSizes.spaceBtwItems),
                itemCount: variationController.productVariations.length,
              itemBuilder: (_, index) {
                final variation = variationController.productVariations[index];
                return _buildVariationTile(context, index, variation, variationController);
              },
            )

            // No variation Message
            else _buildNoVariationsMessage(),
          ],
        ),
      )
    : const SizedBox.shrink(),
    );
  }

  // Helper method to build a variation tile
  Widget _buildVariationTile(
      BuildContext context, int index, ProductVariationModel variation, ProductVariationController variationController) {
    return ExpansionTile(
      backgroundColor: PColors.lightGrey,
        collapsedBackgroundColor: PColors.lightGrey,
        childrenPadding: const EdgeInsets.all(PSizes.md),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.borderRadiusLg)),
        title: Text(variation.attributeValues.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ')),
      children: [
        // Upload Variation Image
        Obx(
            () => PImageUploader(
              right: 0,
                left: null,
                imageType: variation.image.value.isNotEmpty ? ImageType.network : ImageType.asset,
              image: variation.image.value.isNotEmpty ? variation.image.value : PImages.defaultImage,
              onIconButtonPressed: () => ProductImagesController.instance.selectVariationImage(variation),
            )
        ),
        const SizedBox(height: PSizes.spaceBtwInputFields),

        // Variation Stock, and Pricing
        Row(
          children: [
            Expanded(
                child: TextFormField(
                  onChanged: (value) => variation.stock = int.parse(value),
                  controller: variationController.stockControllersList[index][variation],
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Kho', hintText: 'Thêm Kho, chỉ được phép "số"'),
                )
            ),
            const SizedBox(width: PSizes.spaceBtwInputFields),
            Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                  ],
                  onChanged: (value) => variation.price = double.parse(value),
                  controller: variationController.priceControllersList[index][variation],
                  decoration: const InputDecoration(labelText: 'Giá', hintText: 'Thêm Giá, chỉ được phép "số"'),
                )
            ),
            const SizedBox(width: PSizes.spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                onChanged: (value) => variation.salePrice = double.parse(value),
                controller: variationController.salePriceControllersList[index][variation],
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                ],
                decoration: const InputDecoration(labelText: 'Giảm giá', hintText: 'Thêm Giá, chỉ được phép "số"'),
              ),
            ),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwInputFields),

        // Variation Description
        TextFormField(
          onChanged: (value) => variation.description = value,
          controller: variationController.descriptionControllersList[index][variation],
          decoration: const InputDecoration(labelText: 'Mô tả', hintText: 'Thêm mô tả cho phân loại...'),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
      ],
    );
  }

  // Helper method to build message when there are no variations
  Widget _buildNoVariationsMessage() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PRoundedImage(width: 200, height: 200, imageType: ImageType.asset, image: PImages.defaultVariationImageIcon),
          ],
        ),
        SizedBox(height: PSizes.spaceBtwItems),
        Text('Không có phân loại nào được thêm vào sản phẩm'),
      ],
    );
  }
}
