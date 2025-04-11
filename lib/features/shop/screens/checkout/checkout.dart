import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/appbar/appbar.dart';
import 'package:pine/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:pine/common/widgets/products/cart/coupon_widget.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/features/shop/controllers/product/order_controller.dart';
import 'package:pine/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:pine/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:pine/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:pine/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:pine/utils/constants/colors.dart';
import 'package:pine/utils/constants/sizes.dart';
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/helpers/pricing_calculator.dart';
import 'package:pine/utils/popups/loaders.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final cartController = CartController.instance;
  final orderController = Get.put(OrderController());
  final couponController = Get.put(CouponController());

  @override
  void dispose() {
    // Reset trạng thái mã giảm giá khi thoát khỏi màn hình checkout
    couponController.resetCouponState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: PAppBar(
          showBackArrow: true,
          title: Text('Xác nhận đơn hàng',
              style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
            children: [
              /// Hiển thị sản phẩm đã chọn
              const PCartItems(
                showAddRemoveButtons: false,
                selectedItemsOnly: true, // Chỉ hiển thị sản phẩm đã chọn
              ),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Coupon TextField
              const PCouponCode(),
              const SizedBox(height: PSizes.spaceBtwSections),

              /// Billing Section
              PRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(PSizes.md),
                backgroundColor: dark ? PColors.black : PColors.white,
                child: const Column(
                  children: [
                    /// Pricing
                    PBillingAmountSection(),
                    SizedBox(height: PSizes.spaceBtwItems),

                    /// Divider
                    Divider(),
                    SizedBox(height: PSizes.spaceBtwItems),

                    /// Payment Methods
                    PBillingPaymentSection(),
                    SizedBox(height: PSizes.spaceBtwItems),

                    /// Address
                    Divider(),
                    SizedBox(height: PSizes.spaceBtwItems),

                    PBillingAddressSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      /// Checkout Button - Sử dụng Obx để cập nhật tự động khi mã giảm giá thay đổi
      bottomNavigationBar: Obx(() {
        final subTotal = cartController.selectedItemsPrice.value;
        final discountAmount = couponController.calculateDiscount(subTotal);
        final totalAmount = PPricingCalculator.calculateTotalPrice(
            subTotal, 'VN',
            discount: discountAmount);

        return Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: ElevatedButton(
              onPressed: cartController.getSelectedItems().isEmpty
                  ? () => PLoaders.warningSnackBar(
                      title: 'Không có sản phẩm được chọn',
                      message: 'Vui lòng chọn sản phẩm để thanh toán.')
                  : () => orderController.processOrder(totalAmount),
              child: Text(
                  'Đặt hàng ${PHelperFunctions.formatCurrency(totalAmount)}')),
        );
      }),
    );
  }
}
