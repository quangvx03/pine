import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/screens/cart/cart.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../features/shop/controllers/product/variation_controller.dart';
import '../../../../utils/constants/colors.dart';

class PCartCounterIcon extends StatelessWidget {
  const PCartCounterIcon({
    super.key,
    this.iconColor,
    this.counterBgColor,
    this.counterTextColor,
  });

  final Color? iconColor, counterBgColor, counterTextColor;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final dark = PHelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: Icon(Iconsax.shopping_bag, color: iconColor)),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: counterBgColor ?? (dark ? PColors.white : PColors.black),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Obx(
                () => Text(controller.noOfCartItems.value.toString(),
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: counterTextColor ??
                            (dark ? PColors.black : PColors.white),
                        fontSizeFactor: 0.8)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
