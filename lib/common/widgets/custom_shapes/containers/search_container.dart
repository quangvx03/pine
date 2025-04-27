import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/device/device_utility.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class PSearchContainer extends StatelessWidget {
  const PSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
    this.height = 50,
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap ??
          () {
            final navController = Get.find<NavigationController>();
            navController.navigateToTab(2);
          },
      child: Padding(
        padding: padding,
        child: Container(
          width: PDeviceUtils.getScreenWidth(context),
          height: height,
          padding: const EdgeInsets.symmetric(
              horizontal: PSizes.md, vertical: PSizes.sm),
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                      ? PColors.dark
                      : PColors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
              border: showBorder ? Border.all(color: PColors.grey) : null),
          child: Row(
            children: [
              Icon(
                icon,
                color: dark ? PColors.darkerGrey : PColors.darkGrey,
                size: 20,
              ),
              const SizedBox(width: PSizes.spaceBtwItems),
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
