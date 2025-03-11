import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_detail_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class PCartItems extends StatelessWidget {
  const PCartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        itemCount: cartController.cartItems.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: PSizes.spaceBtwSections),
        itemBuilder: (_, index) => Obx(() {
          final item = cartController.cartItems[index];
          return Column(
            children: [
              /// Cart Item
              PCartItem(cartItem: item),
              if (showAddRemoveButtons) SizedBox(height: PSizes.spaceBtwItems),

              /// Add Remove Button Row with total Price
              if (showAddRemoveButtons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 80),

                        /// Add Remove Icon
                        PProductQuantityWithAddRemoveButton(
                          quantity: item.quantity,
                          add: () => cartController.addOneToCart(item),
                          remove: () => cartController.removeOneFromCart(item),
                        ),
                      ],
                    ),
                    PProductDetailPriceText(
                        price: (item.price * item.quantity).toStringAsFixed(1)),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }
}
