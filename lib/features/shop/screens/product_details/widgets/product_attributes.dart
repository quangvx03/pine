import 'package:flutter/material.dart';
import 'package:pine/common/widgets/chips/choice_chip.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/common/widgets/texts/section_heading.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PProductAttributes extends StatelessWidget {
  const PProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        /// Selected Attribute Pricing & Description
        PRoundedContainer(
          padding: const EdgeInsets.all(PSizes.md),
          backgroundColor: dark ? PColors.darkerGrey : PColors.grey,
          child: Column(
            children: [
              /// Title, Price and Stock Status
              Row(
                children: [
                  const PSectionHeading(
                      title: 'Phân loại', showActionButton: false),
                  const SizedBox(width: PSizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const PProductTitleText(
                              title: 'Giá : ', smallSize: true),

                          /// Actual Price
                          Text(
                            '50,000₫',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(width: PSizes.spaceBtwItems),

                          /// Sale Price
                          const PProductDetailPriceText(price: '30,000'),
                        ],
                      ),

                      /// Stock
                      Row(
                        children: [
                          const PProductTitleText(
                              title: 'Kho : ', smallSize: true),
                          Text('Còn hàng',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              /// Variation Description
              const PProductTitleText(
                title:
                    'Đây là mô tả của sản phẩm và có thể lên đến tối đa 4 dòng.',
                smallSize: true,
                maxLines: 4,
              )
            ],
          ),
        ),
        const SizedBox(height: PSizes.spaceBtwItems),

        /// Attributes
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PSectionHeading(title: 'Màu sắc', showActionButton: false),
            const SizedBox(height: PSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                PChoiceChip(text: 'Green', selected: true, onSelected: (value) {}),
                PChoiceChip(text: 'Blue', selected: false, onSelected: (value) {}),
                PChoiceChip(text: 'Yellow', selected: false, onSelected: (value) {}),
              ],
            )
          ],
        ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PSectionHeading(title: 'Kích cỡ', showActionButton: false),
            const SizedBox(height: PSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                PChoiceChip(text: 'M', selected: true, onSelected: (value) {}),
                PChoiceChip(text: 'L', selected: false, onSelected: (value) {}),
                PChoiceChip(text: 'XL', selected: false, onSelected: (value) {}),
              ],
            )
          ],
        ),
      ],
    );
  }
}
