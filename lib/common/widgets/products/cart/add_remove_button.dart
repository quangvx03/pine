import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../icons/circular_icon.dart';

class PProductQuantityWithAddRemoveButton extends StatelessWidget {
  const PProductQuantityWithAddRemoveButton({
    super.key,
    required this.quantity,
    this.add,
    this.remove,
  });

  final int quantity;
  final VoidCallback? add, remove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PCircularIcon(
          icon: Iconsax.minus,
          width: 24,
          height: 24,
          size: PSizes.md,
          color: PHelperFunctions.isDarkMode(context)
              ? PColors.white
              : PColors.black,
          backgroundColor: PHelperFunctions.isDarkMode(context)
              ? PColors.darkerGrey
              : PColors.light,
          onPressed: remove,
        ),
        const SizedBox(width: PSizes.spaceBtwItems),
        Text(quantity.toString(),
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: PSizes.spaceBtwItems),
        PCircularIcon(
          icon: Iconsax.add,
          width: 24,
          height: 24,
          size: PSizes.md,
          color: PColors.white,
          backgroundColor: PColors.primary,
          onPressed: add,
        )
      ],
    );
  }
}
