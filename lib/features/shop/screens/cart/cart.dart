import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/icons/circular_icon.dart';
import 'package:pine/common/widgets/images/rounded_image.dart';
import 'package:pine/common/widgets/texts/brand_title_text_with_verified_icon.dart';
import 'package:pine/common/widgets/texts/product_detail_price_text.dart';
import 'package:pine/common/widgets/texts/product_title_text.dart';
import 'package:pine/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:pine/features/shop/screens/checkout/checkout.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../common/widgets/products/cart/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PAppBar(
          showBackArrow: true,
          title: Text('Giỏ hàng',
              style: Theme.of(context).textTheme.headlineSmall)),
      body: const Padding(
        padding: EdgeInsets.all(PSizes.defaultSpace),

        /// Item in Cart
        child: PCartItems(),
      ),

      /// Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(PSizes.defaultSpace),
        child: ElevatedButton(
            onPressed: () => Get.to(() => const CheckoutScreen()), child: Text('Thanh toán 1,250,000₫')),
      ),
    );
  }
}
