import 'package:flutter/material.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class PLoginHeader extends StatelessWidget {
  const PLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: PSizes.logoHeight,
          image: AssetImage(dark ? PImages.darkAppLogo : PImages.lightAppLogo),
          // dark ? PImages.lightAppLogo : PImages.darkAppLogo),
        ),
        Text(PTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(
          height: PSizes.sm,
        ),
        Text(PTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
