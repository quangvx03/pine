import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/images/p_rounded_image.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/constants/image_strings.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';
import 'package:pine_admin_panel/utils/validators/validation.dart';

import '../../../../../../../utils/constants/colors.dart';
import '../../../../controllers/product/create_product_controller.dart';
import '../../../../controllers/product/product_attributes_controller.dart';
import '../../../../controllers/product/product_variations_controller.dart';


class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = CreateProductController.instance;
    final attributeController = Get.put(ProductAttributesController());
    final variationController = Get.put(ProductVariationController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return productController.productType.value == ProductType.single
          ? const Column(
            children: [
              Divider(color: PColors.primaryBackground),
              SizedBox(height: PSizes.spaceBtwSections),
            ],
          ) : const SizedBox.shrink();
        }),


        Text('Thêm thuộc tính sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: PSizes.spaceBtwItems),

        // Form to add new attribute
        Form(
          key: attributeController.attributesFormKey,
            child: PDeviceUtils.isDesktopScreen(context)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAttributeName(attributeController)),
                      const SizedBox(width: PSizes.spaceBtwItems),
                      Expanded(
                        flex: 2,
                          child: _buildAttributes(attributeController),
                      ),
                      const SizedBox(width: PSizes.spaceBtwItems),
                      _buildAddAttributeButton(attributeController),
                    ],
            )
                : Column(
              children: [
                _buildAttributeName(attributeController),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildAttributes(attributeController),
                const SizedBox(height: PSizes.spaceBtwItems),
                _buildAddAttributeButton(attributeController),
              ],
            ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
        
        // List of added attributes
        Text('Tất cả thuộc tính', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: PSizes.spaceBtwItems),

        // Display added attributes in a rounded container
        PRoundedContainer(
          backgroundColor: PColors.primaryBackground,
          child: Obx(
            () => attributeController.productAttributes.isNotEmpty
              ? ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_,__) => const SizedBox(height: PSizes.spaceBtwItems),
              itemCount: attributeController.productAttributes.length,
                itemBuilder: (_, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: PColors.white,
                    borderRadius: BorderRadius.circular(PSizes.borderRadiusLg),
                  ),
                  child: ListTile(
                    title: Text(attributeController.productAttributes[index].name ?? ''),
                    subtitle: Text(attributeController.productAttributes[index].values!.map((e) => e.trim()).toString()),
                    trailing: IconButton(
                        onPressed: () => attributeController.removeAttribute(index, context),
                        icon: const Icon(Iconsax.trash, color: PColors.error),
                    ),
                  ),
                );
                },

            )
                : const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PRoundedImage(width: 150, height: 80, imageType: ImageType.asset, image: PImages.defaultAttributeColorsImageIcon),
                  ],
                ),
                SizedBox(height: PSizes.spaceBtwItems),
                Text('Không có thuộc tính nào được chọn'),
              ],
            )
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwSections),
        
        // Generate Variations Button
        Obx(
          () => productController.productType.value == ProductType.variable && variationController.productVariations.isEmpty
            ? Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.activity, color: Colors.white),
                label: const Text('Tạo'),
                onPressed: () => variationController.generateVariationsConfirmation(context),
              ),
            ),
          )
          : const SizedBox.shrink(),
        )
      ],
    );
  }

  SizedBox _buildAddAttributeButton(ProductAttributesController controller) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: () => controller.addNewAttribute(),
        icon: const Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: PColors.black,
          backgroundColor: PColors.secondary,
          side: const BorderSide(color: PColors.secondary),
        ),
        label: const Text('Thêm'),
      ),
    );
  }

  // Build text form field for attribute name
  TextFormField _buildAttributeName(ProductAttributesController controller) {
    return TextFormField(
      controller: controller.attributeName,
      validator: (value) => PValidator.validateEmptyText('Tên thuộc tính', value),
      decoration: const InputDecoration(labelText: 'Tên thuộc tính', hintText: 'Màu sắc, Kích cỡ, Chất liệu'),
    );
  }

  // Build text form field for attribute values
  SizedBox _buildAttributes(ProductAttributesController controller) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        controller: controller.attributes,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) => PValidator.validateEmptyText('Trường thuộc tính', value),
        decoration: const InputDecoration(
          labelText: 'Thuộc tính',
          hintText: 'Thêm thuộc tính cách nhau bởi "|" Ví dụ: Xanh | Đỏ | Vàng',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
