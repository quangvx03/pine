import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';

class PSearchContainer extends StatelessWidget {
  const PSearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: PSizes.defaultSpace),
    this.height = 50, // Thêm thuộc tính chiều cao
  });

  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  final double height; // Thêm thuộc tính chiều cao

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: PDeviceUtils.getScreenWidth(context),
          height: height, // Sử dụng thuộc tính chiều cao
          padding: const EdgeInsets.symmetric(horizontal: PSizes.md, vertical: PSizes.sm), // Giảm padding dọc
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                  ? PColors.dark
                  : PColors.light
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(PSizes.cardRadiusLg),
              border: showBorder ? Border.all(color: PColors.grey) : null),
          child: Row(
            children: [
              Icon(icon, color: dark ?  PColors.darkerGrey : PColors.grey, size: 20,), // Giảm kích thước icon
              const SizedBox(width: PSizes.spaceBtwItems),
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}