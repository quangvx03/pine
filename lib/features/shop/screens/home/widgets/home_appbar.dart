import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../cart/cart.dart';

class PHomeAppBar extends StatelessWidget {
  const PHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PAppBar(
      title: Row(
        children: [
        Image.asset(
          PImages.lightAppLogo,
          width: 42,
          height: 42,
        ),
        const SizedBox(width: PSizes.sm),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PTexts.homeAppbarTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: PColors.primary)),
            Text(PTexts.homeAppbarSubTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: PColors.darkerGrey)),
          ],
        ),
        ],
      ),
      actions: [
        PCartCounterIcon(
          onPressed: () {},
          iconColor: PColors.dark,
        )
      ],
    );
  }
}
