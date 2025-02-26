import 'package:flutter/material.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_detail_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class PCartItems extends StatelessWidget {
  const PCartItems(
      {super.key,
      this.showAddRemoveButtons = true,
      this.showPriceCheckout = false});

  final bool showAddRemoveButtons;
  final bool showPriceCheckout;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      separatorBuilder: (_, __) =>
          const SizedBox(height: PSizes.spaceBtwSections),
      itemBuilder: (_, index) => Column(
        children: [
          /// Cart Item
          const PCartItem(),
          if (showAddRemoveButtons) SizedBox(height: PSizes.spaceBtwItems),

          /// Add Remove Button Row with total Price
          if (showAddRemoveButtons)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 80),

                    /// Add Remove Icon
                    PProductQuantityWithAddRemoveButton(),
                  ],
                ),
                PProductDetailPriceText(price: '1,250,000')
              ],
            ),
          if (showPriceCheckout)
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 80),
                PProductDetailPriceText(price: '1,250,000')
              ],
            ),
        ],
      ),
    );
  }
}
