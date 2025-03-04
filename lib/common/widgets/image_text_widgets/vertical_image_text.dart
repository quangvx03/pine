import 'package:flutter/material.dart';
import 'package:pine/common/widgets/images/circular_image.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class PVerticalImageText extends StatelessWidget {
  const PVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = PColors.white,
    this.backgroundColor = PColors.white,
    this.isNetworkImage = true,
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          /// Circular Icon
          PCircularImage(
              image: image,
              padding: 7,
              fit: BoxFit.fitWidth,
              isNetworkImage: isNetworkImage,
              backgroundColor: backgroundColor),

          /// Text
          const SizedBox(height: PSizes.spaceBtwItems / 2),
          SizedBox(
              width: 65,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: dark ? PColors.light : PColors.dark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
