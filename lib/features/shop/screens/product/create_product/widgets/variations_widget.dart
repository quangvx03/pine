import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Variations Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Phân loại sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
              TextButton(onPressed: () {}, child: const Text('Bỏ phân loại')),
            ],
          ),
          const SizedBox(height: PSizes.spaceBtwItems),

          // Variations List
          ListView.separated(
            shrinkWrap: true,
              itemBuilder: (_, index) {
                return _buildVariationTile();
              },
              separatorBuilder: (_, __) => const SizedBox(height: PSizes.spaceBtwItems),
              itemCount: 2
          ),

          // No variation Message
          _buildNoVariationsMessage(),
        ],
      ),
    );
  }

  // Helper method to build a variation tile
  Widget _buildVariationTile() {
    return ExpansionTile(
      backgroundColor: PColors.lightGrey,
        collapsedBackgroundColor: PColors.lightGrey,
        childrenPadding: const EdgeInsets.all(PSizes.md),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PSizes.borderRadiusLg)),
        title: const Text('Kích cỡ: Nhỏ, Kích cỡ: Lớn'),
      children: [
        // Upload Variation Image
        Obx(
            () => PImageUploader(
              right: 0,
                left: null,
                imageType: ImageType.asset,
              image: PImages.defaultImage,
              onIconButtonPressed: () {},
            )
        ),
        const SizedBox(height: PSizes.spaceBtwInputFields),

        // Variation Stock, and Pricing
        Row(
          children: [
            Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Kho', hintText: 'Thêm Kho, chỉ được phép "số"'),
                )
            ),
            const SizedBox(width: PSizes.spaceBtwInputFields),
            Expanded(
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0}đ'))],
                  decoration: const InputDecoration(labelText: 'Giá', hintText: 'Thêm Giá, chỉ được phép "số"'),
                )
            ),
            const SizedBox(width: PSizes.spaceBtwInputFields),
            Expanded(
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0}đ'))],
                  decoration: const InputDecoration(labelText: 'Giảm giá', hintText: 'Thêm Giá, chỉ được phép "số"'),
                )
            ),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwInputFields),

        // Variation Description
        TextFormField(
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
