import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/loaders/animation_loader.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/product_controller.dart';
import 'package:pine/features/shop/screens/all_product/all_products.dart';
import 'package:pine/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:pine/features/shop/screens/checkout/checkout.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final productController = ProductController.instance;
    final dark = PHelperFunctions.isDarkMode(context);

    // Định nghĩa giới hạn giá trị thanh toán
    const double minOrderValue = 75000;
    const double maxOrderValue = 5000000;

    return Scaffold(
      appBar: PAppBar(
          showBackArrow: true,
          title: Text('Giỏ hàng',
              style: Theme.of(context).textTheme.headlineSmall),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => AllProductsScreen(
                      title: 'Tất cả sản phẩm',
                      futureMethod:
                          productController.productRepository.getAllProducts(),
                    ));
              },
              icon: const Icon(
                Iconsax.add,
                color: PColors.primary,
              ),
            ),
            Obx(() {
              final selectedItems = controller.getSelectedItems();
              return IconButton(
                onPressed: () {
                  if (selectedItems.isEmpty) {
                    controller.showWarning(
                        'Chưa có sản phẩm được chọn',
                        'Vui lòng chọn ít nhất một sản phẩm để xóa',
                        'no_items_selected');
                  } else {
                    Get.defaultDialog(
                      contentPadding: const EdgeInsets.all(PSizes.md),
                      title: 'Xóa sản phẩm',
                      middleText:
                          'Bạn có chắc muốn xóa ${selectedItems.length} sản phẩm đã chọn?',
                      confirm: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          controller.removeSelectedItems();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PColors.error,
                          side: const BorderSide(color: PColors.error),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: PSizes.lg),
                          child: Text('Xóa'),
                        ),
                      ),
                      cancel: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Hủy'),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Iconsax.trash,
                  color: Colors.red,
                ),
              );
            }),
          ]),
      body: Obx(() {
        final emptyWidget = SizedBox(
          height: PHelperFunctions.screenHeight() * 0.7,
          child: Center(
            child: PAnimationLoaderWidget(
                text: 'Giỏ hàng của bạn đang trống.',
                animation: PImages.empty,
                showAction: true,
                actionText: 'Khám phá ngay',
                onActionPressed: () => Get.to(() => AllProductsScreen(
                      title: 'Tất cả sản phẩm',
                      futureMethod:
                          productController.productRepository.getAllProducts(),
                    ))),
          ),
        );

        if (controller.cartItems.isEmpty) {
          return emptyWidget;
        } else {
          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(PSizes.defaultSpace),
              child: PCartItems(),
            ),
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PSizes.defaultSpace,
            vertical: PSizes.md,
          ),
          decoration: BoxDecoration(
            color: dark ? PColors.darkerGrey : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(PSizes.cardRadiusLg),
              topRight: Radius.circular(PSizes.cardRadiusLg),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Tổng cộng:',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: PSizes.sm),
                  const Spacer(),
                  Obx(() {
                    final selectedItems = controller.getSelectedItems();
                    final double price = selectedItems.isNotEmpty
                        ? controller.selectedItemsPrice.value
                        : 0;

                    return Text(
                      PHelperFunctions.formatCurrency(price.toInt()),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PColors.primary,
                          ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: PSizes.sm),
              Row(
                children: [
                  Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: controller.selectAll.value,
                                onChanged: (value) {
                                  controller.toggleSelectAll();
                                  controller.updateSelectedPrice();
                                },
                                activeColor: PColors.primary,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          )),
                      Text('Tất cả',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),

                  const SizedBox(
                      width: PSizes.spaceBtwSections + PSizes.defaultSpace),

                  // Nút thanh toán với số lượng sản phẩm
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: () {
                          if (controller.validateCheckout(
                              minOrderValue, maxOrderValue)) {
                            Get.to(() => const CheckoutScreen());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PColors.primary,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: PSizes.md),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(PSizes.buttonRadius),
                          ),
                        ),
                        child: Text(
                          'Thanh toán (${controller.getTotalSelectedQuantity()})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
