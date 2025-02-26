import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../images/rounded_image.dart';
import '../../texts/brand_title_text_with_verified_icon.dart';
import '../../texts/product_title_text.dart';

class PCartItem extends StatelessWidget {
  const PCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Image
        PRoundedImage(
          imageUrl: PImages.productImage1,
          width: 65,
          height: 65,
          padding: const EdgeInsets.all(PSizes.sm),
          backgroundColor: PHelperFunctions.isDarkMode(context)
              ? PColors.darkerGrey
              : PColors.light,
        ),

        const SizedBox(width: PSizes.spaceBtwItems),

        /// Title, Price, Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                  child: PProductTitleText(
                title: 'Giày thể thao',
                maxLines: 1,
              )),
              const PBrandTitleWithVerifiedIcon(title: 'Nike'),

              /// Attributes
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Màu sắc: ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: 'Xanh ngọc ',
                    style: Theme.of(context).textTheme.bodyLarge),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Kích cỡ: ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: '40', style: Theme.of(context).textTheme.bodyLarge),
              ])),
            ],
          ),
        )
      ],
    );
  }
}
