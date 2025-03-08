import 'package:flutter/material.dart';
import 'package:pine/features/shop/models/brand_model.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../images/circular_image.dart';
import '../texts/brand_title_text_with_verified_icon.dart';

class PBrandCard extends StatelessWidget {
  const PBrandCard({
    super.key,
    this.onTap,
    required this.showBorder,
    required this.brand,
  });

  final BrandModel brand;
  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,

      /// Container
      child: PRoundedContainer(
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(PSizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Icon
            Flexible(
              child: PCircularImage(
                isNetworkImage: true,
                image: brand.image,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: PSizes.spaceBtwItems / 2),

            /// Texts
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PBrandTitleWithVerifiedIcon(
                      title: brand.name, brandTextSize: TextSizes.medium),
                  Text(
                    '${brand.productsCount ?? 0} sản phẩm',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
