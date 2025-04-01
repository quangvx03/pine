import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_detail_price_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/popups/loaders.dart';

class PCartItems extends StatelessWidget {
  const PCartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final dark = PHelperFunctions.isDarkMode(context);

    return SlidableAutoCloseBehavior(
      child: Obx(
        () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartController.cartItems.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: PSizes.spaceBtwSections),
          itemBuilder: (_, index) => Obx(() {
            final reversedIndex = cartController.cartItems.length - 1 - index;
            final item = cartController.cartItems[reversedIndex];
            final itemKey = cartController.getItemKey(item);
            final isSelected = cartController.selectedItems[itemKey] ?? false;

            return Slidable(
              key: ValueKey(itemKey),
              endActionPane: ActionPane(
                extentRatio: 0.25,
                motion: const BehindMotion(),
                children: [
                  CustomSlidableAction(
                    onPressed: (context) {
                      final actualIndex = cartController.cartItems.indexWhere(
                          (cartItem) =>
                              cartItem.productId == item.productId &&
                              cartItem.variationId == item.variationId);

                      if (actualIndex >= 0) {
                        cartController.cartItems.removeAt(actualIndex);
                        cartController.updateCart();
                        PLoaders.successSnackBar(
                          title: 'Đã xóa',
                          message: 'Sản phẩm đã được xóa khỏi giỏ hàng',
                        );
                      }
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    borderRadius:
                        BorderRadius.circular(PSizes.productImageRadius),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.trash,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text('Xóa',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                )),
                      ],
                    ),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Checkbox phần lựa chọn
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          cartController.toggleSelectItem(item);
                        },
                        activeColor: PColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),

                  // Thanh dọc ngăn cách
                  Container(
                    width: PSizes.dividerHeight,
                    height: 85,
                    margin: const EdgeInsets.only(right: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? PColors.primary.withValues(alpha: 0.3)
                          : dark
                              ? Colors.grey.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // Sản phẩm và thông tin
                  Expanded(
                    child: Column(
                      children: [
                        /// Cart Item
                        PCartItem(cartItem: item),
                        if (showAddRemoveButtons)
                          const SizedBox(height: PSizes.spaceBtwItems),

                        if (showAddRemoveButtons)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 81),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            PHelperFunctions.screenWidth() *
                                                0.275),
                                    child: PProductDetailPriceText(
                                      price: (item.price).toStringAsFixed(0),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: PProductQuantityWithAddRemoveButton(
                                  quantity: item.quantity,
                                  add: () => cartController.addOneToCart(item),
                                  remove: () =>
                                      cartController.removeOneFromCart(item),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
