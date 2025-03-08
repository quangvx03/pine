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
          /// Selected Attribute Pricing & Description
          // Display variation price and stock when same variation is selected
          if (controller.selectedVariation.value.id.isNotEmpty)
            PRoundedContainer(
              padding: const EdgeInsets.all(PSizes.md),
              backgroundColor: dark ? PColors.darkerGrey : PColors.softGrey,
              child: Column(
                children: [
                  /// Title, Price and Stock Status
                  Row(
                    children: [
                      // const PSectionHeading(
                      //     title: 'Phân loại', showActionButton: false),
                      // const SizedBox(width: PSizes.spaceBtwItems),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Stock
                          Row(
                            children: [
                              const PProductTitleText(
                                  title: 'Trạng thái:', smallSize: true),
                              const SizedBox(width: PSizes.spaceBtwItems / 2),
                              Text(controller.variationStockStatus.value,
                                  style:
                                  Theme.of(context).textTheme.titleMedium!.apply(color: PColors.info)),
                            ],
                          ),
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
                                textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: PColors.primary), // Ghi đè style trực tiếp
                              ),
                            ],
                          ),


                        ],
                      ),
                    ],
                  ),

                  // /// Variation Description
                  // PProductTitleText(
                  //   title: controller.selectedVariation.value.description ?? '',
                  //   smallSize: true,
                  //   maxLines: 4,
                  // )
                ],
              ),
            ),
          const SizedBox(height: PSizes.spaceBtwItems),

          /// Attributes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!
                .map((attribute) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PSectionHeading(
                            title: attribute.name ?? '',
                            showActionButton: false),
                        const SizedBox(height: PSizes.spaceBtwItems / 2),
                        Obx(
                          () => Wrap(
                              spacing: 8,
                              children: attribute.values!.map((attributeValue) {
                                final isSelected = controller
                                        .selectedAttributes[attribute.name] ==
                                    attributeValue;
                                final available = controller
                                    .getAttributesAvailabilityInVariation(
                                        product.productVariations!,
                                        attribute.name!)
                                    .contains(attributeValue);

                                return PChoiceChip(
                                    text: attributeValue,
                                    selected: isSelected,
                                    onSelected: available
                                        ? (selected) {
                                            if (selected && available) {
                                              controller.onAttributeSelected(
                                                  product,
                                                  attribute.name ?? '',
                                                  attributeValue);
                                            }
                                          }
                                        : null);
                              }).toList()),
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
