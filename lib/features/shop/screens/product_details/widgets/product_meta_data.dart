import 'package:flutter/material.dart';
import 'package:pine/common/widgets/images/circular_image.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PProductMetaData extends StatelessWidget {
  const PProductMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            /// Sale Tag
            PRoundedContainer(
              radius: PSizes.sm,
              backgroundColor: PColors.secondary.withValues(alpha: 0.8),
              padding: const EdgeInsets.symmetric(
                  horizontal: PSizes.sm, vertical: PSizes.xs),
              child: Text('25%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: PColors.black)),
            ),
            const SizedBox(width: PSizes.spaceBtwItems),

            /// Price
            Text('300,000₫',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(decoration: TextDecoration.lineThrough)),
            const SizedBox(width: PSizes.spaceBtwItems),
            PProductDetailPriceText(price: '225,000', isLarge: true),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Title
        const PProductTitleText(title: 'Áo Thể Thao Nike'),
        const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Stock Status
        Row(
          children: [
            const PProductTitleText(title: 'Trạng thái'),
            const SizedBox(width: PSizes.spaceBtwItems),
            Text('Còn hàng', style: Theme.of(context).textTheme.titleMedium!.apply(color: PColors.primary) ),
          ],
        ),
        const SizedBox(height: PSizes.spaceBtwItems / 1.5),

        /// Brand
        Row(
          children: [
            PCircularImage(
                image: PImages.shoeIcon,
                width: 32,
                height: 32,
                overlayColor: dark ? PColors.white : PColors.black),
            const PBrandTitleWithVerifiedIcon(
                title: 'Nike', brandTextSize: TextSizes.medium),
          ],
        )
      ],
    );
  }
}
