import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine/common/widgets/success_screen/success_screen.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/checkout_controller.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/helpers/network_manager.dart';
import 'package:pine/utils/popups/full_screen_loader.dart';
import 'package:pine/utils/popups/loaders.dart';

import '../../../../data/repositories/order_repository.dart';
import '../../models/order_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final couponController = CouponController.instance;
  final orderRepository = Get.put(OrderRepository());
  final productRepository = Get.put(ProductRepository());

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
      // Kiểm tra kết nối mạng
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PLoaders.warningSnackBar(
            title: 'Không có kết nối mạng',
            message: 'Vui lòng kiểm tra kết nối internet và thử lại.');
        return;
      }

      // Lấy các sản phẩm đã chọn từ giỏ hàng
      final selectedItems = cartController.getSelectedItems();

      // Kiểm tra có sản phẩm được chọn không
      if (selectedItems.isEmpty) {
        PLoaders.warningSnackBar(
            title: 'Chưa có sản phẩm nào được chọn',
            message: 'Vui lòng chọn sản phẩm để thanh toán');
        return;
      }

      // Kiểm tra địa chỉ giao hàng
      if (addressController.selectedAddress.value.id.isEmpty) {
        PLoaders.warningSnackBar(
            title: 'Chưa có địa chỉ giao hàng',
            message: 'Vui lòng thêm địa chỉ giao hàng');
        return;
      }

      // Hiển thị màn hình loading
      PFullScreenLoader.openLoadingDiaLog(
          'Đơn hàng đang được xử lý', PImages.verify);

      // Lấy thông tin người dùng
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) {
        PFullScreenLoader.stopLoading();
        PLoaders.warningSnackBar(
            title: 'Lỗi xác thực', message: 'Vui lòng đăng nhập để tiếp tục');
        return;
      }

      // Kiểm tra và cập nhật tồn kho trước khi xử lý đơn hàng
      final stockCheckResult = await _checkAndUpdateStock(selectedItems);
      if (!stockCheckResult.success) {
        PFullScreenLoader.stopLoading();
        PLoaders.warningSnackBar(
            title: 'Không thể đặt hàng', message: stockCheckResult.message);
        return;
      }

      // Thông tin mã giảm giá
      final couponController = Get.find<CouponController>();
      final coupon = couponController.selectedCoupon.value;
      final subTotal = cartController.selectedItemsPrice.value;
      final discountAmount = couponController.calculateDiscount(subTotal);

      // Tạo đơn hàng mới
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final order = OrderModel(
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        deliveryDate: DateTime.now(),
        items: selectedItems,
        couponId: coupon.id.isNotEmpty ? coupon.id : null,
        couponCode: coupon.id.isNotEmpty ? coupon.couponCode : null,
        discountAmount: discountAmount,
      );

      // Lưu đơn hàng vào Firestore
      await orderRepository.saveOrder(order, userId);

      // Đánh dấu mã giảm giá đã được sử dụng
      if (coupon.id.isNotEmpty) {
        await couponController.markCouponAsUsed(orderId);
      }

      // Xóa sản phẩm đã đặt khỏi giỏ hàng
      cartController.removeSelectedItems(showNotification: false);

      // Hiển thị màn hình thành công
      PFullScreenLoader.stopLoading();
      Get.off(() => SuccessScreen(
            image: PImages.success,
            title: 'Đặt hàng thành công!',
            subTitle: 'Đơn hàng sẽ sớm được giao đến bạn!',
            onPressed: () => Get.offAll(() => const NavigationMenu()),
          ));
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Có lỗi xảy ra', message: e.toString());
    }
  }

  /// Kiểm tra tồn kho và cập nhật số lượng cho tất cả sản phẩm trong đơn hàng
  Future<StockCheckResult> _checkAndUpdateStock(List<CartModel> items) async {
    try {
      // Danh sách sản phẩm đã cập nhật - để tránh cập nhật nhiều lần cùng một sản phẩm
      Map<String, ProductModel> productsToUpdate = {};

      // Kiểm tra từng sản phẩm
      for (final item in items) {
        // Nếu sản phẩm đã được xử lý trước đó, lấy từ map
        ProductModel product;
        if (productsToUpdate.containsKey(item.productId)) {
          product = productsToUpdate[item.productId]!;
        } else {
          // Ngược lại, lấy thông tin sản phẩm mới từ database
          product = await productRepository.getProductById(item.productId);
          productsToUpdate[item.productId] = product;
        }

        // Xử lý với sản phẩm biến thể
        if (item.variationId.isNotEmpty) {
          final variationIndex = product.productVariations?.indexWhere(
                  (variation) => variation.id == item.variationId) ??
              -1;

          // Nếu không tìm thấy biến thể
          if (variationIndex == -1 || product.productVariations == null) {
            return StockCheckResult(
              success: false,
              message: 'Phân loại sản phẩm "${item.title}" không còn tồn tại',
            );
          }

          // Lấy thông tin biến thể
          final variation = product.productVariations![variationIndex];
          final availableStock = variation.stock - variation.soldQuantity;

          // Kiểm tra tồn kho
          if (availableStock < item.quantity) {
            return StockCheckResult(
              success: false,
              message:
                  'Sản phẩm "${item.title}" chỉ còn $availableStock sản phẩm, không đủ số lượng bạn yêu cầu (${item.quantity})',
            );
          }

          // Cập nhật soldQuantity
          product.productVariations![variationIndex].soldQuantity +=
              item.quantity;
        }
        // Xử lý với sản phẩm thường
        else {
          final availableStock = product.stock - product.soldQuantity;

          // Kiểm tra tồn kho
          if (availableStock < item.quantity) {
            return StockCheckResult(
              success: false,
              message:
                  'Sản phẩm "${item.title}" chỉ còn $availableStock sản phẩm, không đủ số lượng bạn yêu cầu (${item.quantity})',
            );
          }

          // Cập nhật soldQuantity
          product.soldQuantity += item.quantity;
        }
      }

      // Cập nhật tất cả sản phẩm vào database
      for (final product in productsToUpdate.values) {
        await _updateProductStock(product);
      }

      return StockCheckResult(success: true);
    } catch (e) {
      return StockCheckResult(
        success: false,
        message: 'Lỗi khi kiểm tra tồn kho: $e',
      );
    }
  }

  /// Cập nhật số lượng đã bán (soldQuantity) của sản phẩm
  Future<void> _updateProductStock(ProductModel product) async {
    try {
      final productRef =
          FirebaseFirestore.instance.collection('Products').doc(product.id);

      // Tạo map data update
      final Map<String, dynamic> data = {
        'SoldQuantity': product.soldQuantity,
      };

      // Nếu có biến thể, cập nhật tất cả
      if (product.productVariations != null &&
          product.productVariations!.isNotEmpty) {
        final variations = product.productVariations!
            .map((variation) => variation.toJson())
            .toList();
        data['ProductVariations'] = variations;
      }

      // Cập nhật dữ liệu
      await productRef.update(data);
    } catch (e) {
      throw 'Lỗi khi cập nhật tồn kho: $e';
    }
  }

  /// Hủy đơn hàng
  Future<bool> cancelOrder(String modelId) async {
    try {
      // Kiểm tra kết nối mạng
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PLoaders.warningSnackBar(
          title: 'Không có kết nối mạng',
          message: 'Vui lòng kiểm tra kết nối internet và thử lại.',
        );
        return false;
      }

      // Hiển thị loading
      PFullScreenLoader.openLoadingDiaLog('Đang hủy đơn hàng', PImages.verify);

      try {
        // Lấy thông tin đơn hàng
        final order = await orderRepository.getOrderDetails(modelId);
        if (order == null) {
          throw 'Không tìm thấy thông tin đơn hàng';
        }

        // Cập nhật trạng thái đơn hàng
        await orderRepository.updateOrderStatus(modelId, OrderStatus.cancelled);

        // Hoàn trả số lượng sản phẩm về kho
        await _restoreProductStock(order);

        // Đóng dialog loading
        PFullScreenLoader.stopLoading();

        // Hiển thị thông báo thành công
        PLoaders.successSnackBar(
          title: 'Thành công',
          message: 'Đơn hàng đã được hủy',
        );

        return true;
      } catch (e) {
        // Đóng dialog loading
        PFullScreenLoader.stopLoading();

        // Hiển thị thông báo lỗi
        PLoaders.errorSnackBar(
          title: 'Lỗi',
          message: 'Không thể hủy đơn hàng: ${e.toString()}',
        );

        return false;
      }
    } catch (e) {
      // Đóng dialog loading
      PFullScreenLoader.stopLoading();

      // Hiển thị thông báo lỗi chung
      PLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Có lỗi xảy ra: ${e.toString()}',
      );

      return false;
    }
  }

  /// Hoàn trả số lượng sản phẩm về kho khi hủy đơn hàng
  Future<void> _restoreProductStock(OrderModel order) async {
    try {
      // Danh sách sản phẩm đã cập nhật - để tránh cập nhật nhiều lần cùng một sản phẩm
      Map<String, ProductModel> productsToUpdate = {};

      // Lặp qua từng sản phẩm trong đơn hàng
      for (final item in order.items) {
        try {
          // Nếu sản phẩm đã được xử lý trước đó, lấy từ map
          ProductModel product;
          if (productsToUpdate.containsKey(item.productId)) {
            product = productsToUpdate[item.productId]!;
          } else {
            // Ngược lại, lấy thông tin sản phẩm mới từ database
            product = await productRepository.getProductById(item.productId);
            productsToUpdate[item.productId] = product;
          }

          // Xử lý với sản phẩm biến thể
          if (item.variationId.isNotEmpty) {
            final variationIndex = product.productVariations?.indexWhere(
                    (variation) => variation.id == item.variationId) ??
                -1;

            // Nếu không tìm thấy biến thể, bỏ qua
            if (variationIndex == -1 || product.productVariations == null) {
              debugPrint(
                  'Không tìm thấy biến thể ${item.variationId} của sản phẩm ${item.title}');
              continue;
            }

            // Giảm số lượng đã bán của biến thể (hoàn trả về kho)
            product.productVariations![variationIndex].soldQuantity -=
                item.quantity;
            if (product.productVariations![variationIndex].soldQuantity < 0) {
              product.productVariations![variationIndex].soldQuantity = 0;
            }

            debugPrint(
                'Hoàn trả ${item.quantity} sản phẩm biến thể ${item.title} vào kho');
          }
          // Xử lý với sản phẩm thường
          else {
            // Giảm số lượng đã bán (hoàn trả về kho)
            product.soldQuantity -= item.quantity;
            if (product.soldQuantity < 0) {
              product.soldQuantity = 0;
            }

            debugPrint(
                'Hoàn trả ${item.quantity} sản phẩm ${item.title} vào kho');
          }
        } catch (e) {
          debugPrint('Lỗi khi xử lý sản phẩm ${item.productId}: $e');
          // Tiếp tục với sản phẩm khác
        }
      }

      // Cập nhật tất cả sản phẩm vào database
      for (final product in productsToUpdate.values) {
        try {
          await _updateProductStock(product);
          debugPrint(
              'Cập nhật tồn kho thành công cho sản phẩm ${product.title}');
        } catch (e) {
          debugPrint(
              'Lỗi khi cập nhật tồn kho cho sản phẩm ${product.title}: $e');
          // Tiếp tục với sản phẩm khác
        }
      }
    } catch (e) {
      debugPrint('Lỗi khi hoàn trả sản phẩm về kho: $e');
      // Không throw exception để quá trình hủy đơn hàng tiếp tục
    }
  }
}

/// Class lưu trữ kết quả kiểm tra tồn kho
class StockCheckResult {
  final bool success;
  final String message;

  StockCheckResult({required this.success, this.message = ''});
}
