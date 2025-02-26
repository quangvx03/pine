import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

class PBrandShowcase extends StatelessWidget {
  const PBrandShowcase({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return PRoundedContainer(
      showBorder: true,
      borderColor: PColors.darkGrey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(PSizes.md),
      margin: const EdgeInsets.only(bottom: PSizes.spaceBtwItems),
      child: Column(
        children: [
          /// Brand with Products Count
          const PBrandCard(showBorder: false),
          const SizedBox(height: PSizes.spaceBtwItems),

          /// Brand Top 3 Product Images
          Row(
              children: images
                  .map((image) => brandTopProductImageWidget(image, context))
                  .toList())
        ],
      ),
    );
  }
}

Widget brandTopProductImageWidget(String image, context) {
  return Expanded(
    child: PRoundedContainer(
      height: 100,
      padding: const EdgeInsets.all(PSizes.md),
      margin: const EdgeInsets.only(right: PSizes.sm),
      backgroundColor: PHelperFunctions.isDarkMode(context)
          ? PColors.darkerGrey
          : PColors.light,
      child: Image(fit: BoxFit.contain, image: AssetImage(image)),
    ),
  );
}
