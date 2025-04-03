import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/chips/choice_chip.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PProductAttributes extends StatelessWidget {
  const PProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VariationController());
    final dark = PHelperFunctions.isDarkMode(context);

    return Obx(
      () => Column(
        children: [
          if (controller.selectedVariation.value.id.isNotEmpty)
            PRoundedContainer(
              padding: const EdgeInsets.all(PSizes.md),
              backgroundColor: dark ? PColors.darkerGrey : PColors.softGrey,
              child: Column(
                children: [
                  /// Title, Price and Stock Status
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Stock - Hiển thị trạng thái tồn kho với icon và số lượng
                          Row(
                            children: [
                              Icon(
                                controller.getVariationAvailableStock() > 0
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:
                                    controller.getVariationAvailableStock() > 0
                                        ? PColors.info
                                        : PColors.error,
                                size: 18,
                              ),
                              const SizedBox(width: PSizes.spaceBtwItems / 2),

                              // Sử dụng giá trị từ controller đã được cập nhật
                              Text(
                                controller.variationStockStatus.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: controller
                                                  .getVariationAvailableStock() >
                                              0
                                          ? PColors.info
                                          : PColors.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: PSizes.spaceBtwItems / 2),

                          Row(
                            children: [
                              const PProductTitleText(
                                  title: 'Giá:', smallSize: true),

                              const SizedBox(width: PSizes.spaceBtwItems / 2),

                              /// Actual Price
                              if (controller.selectedVariation.value.salePrice >
                                  0)
                                Text(
                                  '${PHelperFunctions.formatCurrency(controller.selectedVariation.value.price)}  ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),

                              /// Sale Price
                              PProductDetailPriceText(
                                price: controller.getVariationPrice(),
                                isLarge: true,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: PColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: PSizes.spaceBtwItems),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!
                .map((attribute) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PSectionHeading(
                            title: attribute.name ?? '',
                            isDetail: true,
                            showActionButton: false),
                        const SizedBox(height: PSizes.spaceBtwItems / 2),
                        Obx(
                          () {
                            final availableValues =
                                controller.getAvailableAttributeValues(
                              product.productVariations!,
                              attribute.name!,
                              controller.selectedAttributes,
                            );

                            return Wrap(
                                spacing: 8,
                                children:
                                    attribute.values!.map((attributeValue) {
                                  final isSelected = controller
                                          .selectedAttributes[attribute.name] ==
                                      attributeValue;
                                  // Kiểm tra xem giá trị thuộc tính có khả dụng không
                                  final available =
                                      availableValues.contains(attributeValue);

                                  return PChoiceChip(
                                      text: attributeValue,
                                      selected: isSelected,
                                      onSelected: (available || isSelected)
                                          ? (selected) {
                                              controller.onAttributeSelected(
                                                  product,
                                                  attribute.name ?? '',
                                                  attributeValue);
                                            }
                                          : null);
                                }).toList());
                          },
                        ),
                        const SizedBox(height: PSizes.spaceBtwItems / 2),
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
