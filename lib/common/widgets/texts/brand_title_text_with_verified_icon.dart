import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/texts/brand_title_text.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';

import '../../../utils/constants/sizes.dart';

class PBrandTitleWithVerifiedIcon extends StatelessWidget {
  const PBrandTitleWithVerifiedIcon({
    super.key,
    this.textColor,
    this.maxLines = 1,
    required this.title,
    this.iconColor = PColors.primary,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: PBrandTitleText(
          title: title,
          color: textColor,
          maxLines: maxLines,
          textAlign: textAlign,
          brandTextSize: brandTextSize,
        )),
        const SizedBox(width: 2),
        Icon(Iconsax.verify5, color: iconColor, size: PSizes.iconXs)
      ],
    );
  }
}
