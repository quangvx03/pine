import 'package:flutter/material.dart';
import 'package:pine/features/shop/models/brand_model.dart';
import 'package:pine/utils/constants/colors.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
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
      child: PRoundedContainer(
        showBorder: showBorder,
        backgroundColor: dark ? PColors.darkerGrey : Colors.transparent,
        padding: const EdgeInsets.all(PSizes.sm),
        child: Row(
          children: [
            // Phần hình ảnh (1/3)
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(PSizes.md),
                    image: DecorationImage(
                      image: NetworkImage(brand.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: PSizes.sm),

            // Phần text (2/3)
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand name with verified icon
                  PBrandTitleWithVerifiedIcon(
                    title: brand.name,
                    brandTextSize: TextSizes.medium,
                    maxLines: 1,
                  ),

                  // Products count
                  Text(
                    '${brand.productsCount ?? 0} sản phẩm',
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
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
