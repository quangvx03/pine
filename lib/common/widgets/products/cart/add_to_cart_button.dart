import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/screens/product_details/product_detail.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ProductCardAddToCartButton extends StatelessWidget {
  const ProductCardAddToCartButton({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final productController = ProductController.instance;

    // Kiểm tra tồn kho
    final isInStock =
        productController.isProductInStock(product.stock, product.soldQuantity);

    return InkWell(
      onTap: () {
        // Nếu hết hàng thì không làm gì cả
        if (!isInStock) return;

        if (product.productType == ProductType.single.toString()) {
          final cartItem = cartController.convertToCartItem(product, 1);
          cartController.addOneToCart(cartItem);
        } else {
          Get.to(() => ProductDetailScreen(product: product));
        }
      },
      child: Obx(() {
        // Lấy số lượng hiện có trong giỏ hàng
        final productQuantityInCart =
            cartController.getProductQuantityInCart(product.id);

        final buttonColor = !isInStock
            ? PColors.grey
            : (productQuantityInCart > 0 ? PColors.primary : PColors.dark);

        final buttonIcon = !isInStock
            ? const Icon(Iconsax.slash, color: PColors.white)
            : (productQuantityInCart > 0
                ? Text(productQuantityInCart.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: PColors.white))
                : const Icon(Iconsax.add, color: PColors.white));

        return Container(
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PSizes.cardRadiusMd),
                bottomRight: Radius.circular(PSizes.productImageRadius),
              )),
          child: SizedBox(
            width: PSizes.iconLg * 1.2,
            height: PSizes.iconLg * 1.2,
            child: Center(child: buttonIcon),
          ),
        );
      }),
    );
  }
}
