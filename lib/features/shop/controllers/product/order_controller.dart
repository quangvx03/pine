import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/success_screen/success_screen.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/checkout_controller.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../../data/repositories/order_repository.dart';
import '../../models/order_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      PLoaders.warningSnackBar(title: 'Có lỗi xảy ra!', message: e.toString());
      return [];
    }
  }

  void processOrder(double totalAmount) async {
    try {
      PFullScreenLoader.openLoadingDiaLog(
          'Đơn hàng đang được xử lý', PImages.verify);

      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now(),
        items: cartController.cartItems.toList(),
      );

      // Save the order to Firestore
      await orderRepository.saveOrder(order, userId);

      // Update the cart status
      cartController.clearCart();

      // Show success screen
      Get.off(() => SuccessScreen(
            image: PImages.success,
            title: 'Đặt hàng thành công!',
            subTitle: 'Đơn hàng sẽ sớm được giao đến bạn!',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }
}
