import 'package:flutter/material.dart';
import 'package:pine/features/shop/models/cart_item_model.dart';

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
    required this.cartItem,
  });

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Image
        PRoundedImage(
          imageUrl: cartItem.image ?? '',
          width: 65,
          height: 65,
          isNetworkImage: true,
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
              Flexible(
                  child: PProductTitleText(
                title: cartItem.title,
                maxLines: 1,
              )),
              PBrandTitleWithVerifiedIcon(title: cartItem.brandName ?? ''),

              /// Attributes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (cartItem.selectedVariation ?? {})
                    .entries
                    .map((e) => Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${e.key}: ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: e.value,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),

              // /// Attributes
              // Text.rich(TextSpan(
              //     children: (cartItem.selectedVariation ?? {})
              //         .entries
              //         .map((e) => TextSpan(children: [
              //               TextSpan(
              //                   text: '${e.key}:',
              //                   style: Theme.of(context).textTheme.bodySmall),
              //               TextSpan(
              //                   text: ' ${e.value} ',
              //                   style: Theme.of(context).textTheme.bodyLarge),
              //             ]))
              //         .toList())),
            ],
          ),
        )
      ],
    );
  }
}
