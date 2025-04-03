import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/icons/circular_icon.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/variation_controller.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../../../utils/constants/sizes.dart';

class PBottomAddToCart extends StatelessWidget {
  const PBottomAddToCart({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final productController = ProductController.instance;
    final variationController = Get.find<VariationController>();
    final dark = PHelperFunctions.isDarkMode(context);

    // Gọi để lấy số lượng sản phẩm đã có trong giỏ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.updateAlreadyAddedProductCount(product);
    });

    // Kiểm tra và tính tồn kho khả dụng
    int getAvailableStock() {
      // Nếu sản phẩm biến thể và đã chọn biến thể
      if (product.productType == ProductType.variable.toString() &&
          variationController.selectedVariation.value.id.isNotEmpty) {
        return variationController.getVariationAvailableStock();
      }
      // Nếu sản phẩm đơn giản
      else if (product.productType == ProductType.single.toString()) {
        return productController.getProductAvailableStock(
            product.stock, product.soldQuantity);
      }
      // Chưa chọn biến thể
      return 0;
    }

    // Tính số lượng hiện có trong giỏ hàng
    int getCurrentQuantityInCart() {
      if (product.productType == ProductType.variable.toString() &&
          variationController.selectedVariation.value.id.isNotEmpty) {
        return cartController.getVariationQuantityInCart(
            product.id, variationController.selectedVariation.value.id);
      } else {
        return cartController.getProductQuantityInCart(product.id);
      }
    }

    // Kiểm tra có thể thêm vào giỏ không (còn hàng và đã chọn biến thể nếu cần)
    bool canAddToCart() {
      // Không thể thêm nếu hết hàng
      if (getAvailableStock() <= 0) return false;

      // Nếu là sản phẩm biến thể phải chọn biến thể
      if (product.productType == ProductType.variable.toString() &&
          variationController.selectedVariation.value.id.isEmpty) {
        return false;
      }

      return true;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: PSizes.defaultSpace, vertical: PSizes.defaultSpace / 2),
      decoration: BoxDecoration(
          color: dark ? PColors.darkerGrey : PColors.light,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(PSizes.cardRadiusLg),
            topRight: Radius.circular(PSizes.cardRadiusLg),
          )),
      child: Obx(() {
        // Kiểm tra số lượng tối thiểu
        if (cartController.productQuantityInCart.value < 1) {
          cartController.productQuantityInCart.value = 1;
        }

        final availableStock = getAvailableStock();
        final currentInCart = getCurrentQuantityInCart();

        // Kiểm tra nếu số lượng đã chọn + số lượng đã có trong giỏ > tồn kho
        final willExceedStock =
            cartController.productQuantityInCart.value + currentInCart >
                availableStock;
        final maxReached =
            cartController.productQuantityInCart.value >= availableStock;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Nút giảm số lượng
                PCircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: PColors.grey,
                  width: 36,
                  height: 36,
                  color: cartController.productQuantityInCart.value <= 1
                      ? PColors.white
                      : PColors.black,
                  onPressed: cartController.productQuantityInCart.value <= 1
                      ? null
                      : () => cartController.productQuantityInCart.value -= 1,
                ),

                const SizedBox(width: PSizes.spaceBtwItems),
                Text(cartController.productQuantityInCart.value.toString(),
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: PSizes.spaceBtwItems),

                // Nút tăng số lượng - disable khi đạt max
                PCircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: maxReached ? PColors.grey : PColors.primary,
                  width: 36,
                  height: 36,
                  color: PColors.white,
                  onPressed: maxReached
                      ? null
                      : () => cartController.productQuantityInCart.value += 1,
                ),
              ],
            ),

            // Nút thêm vào giỏ hàng - disable khi không thể thêm
            ElevatedButton(
              onPressed: !canAddToCart()
                  ? null
                  : () {
                      // Kiểm tra nếu sẽ vượt quá tồn kho
                      if (willExceedStock) {
                        final remainingStock = availableStock - currentInCart;
                        if (remainingStock <= 0) {
                          PLoaders.warningSnackBar(
                              title: 'Đã đạt giới hạn',
                              message:
                                  'Bạn đã thêm hết số lượng tồn kho vào giỏ hàng');
                        } else {
                          // Giới hạn số lượng thêm bằng số lượng còn lại có thể thêm
                          cartController.productQuantityInCart.value =
                              remainingStock;
                          cartController.addToCart(
                              product, true); // true để cộng dồn
                        }
                      } else {
                        cartController.addToCart(
                            product, true); // true để cộng dồn
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(PSizes.md),
                backgroundColor:
                    !canAddToCart() ? PColors.grey : PColors.primary,
                side: BorderSide(
                    color: !canAddToCart() ? PColors.grey : PColors.primary),
                disabledBackgroundColor: PColors.grey,
                disabledForegroundColor: PColors.white,
              ),
              child: Text(!canAddToCart()
                  ? (product.productType == ProductType.variable.toString() &&
                          variationController.selectedVariation.value.id.isEmpty
                      ? 'Chọn phân loại'
                      : 'Hết hàng')
                  : 'Thêm vào giỏ hàng'),
            )
          ],
        );
      }),
    );
  }
}
