import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:pine/common/widgets/success_screen/success_screen.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/data/repositories/product_repository.dart';
import 'package:pine/features/personalization/controllers/address_controller.dart';
import 'package:pine/features/shop/controllers/product/cart_controller.dart';
import 'package:pine/features/shop/controllers/product/checkout_controller.dart';
import 'package:pine/features/shop/controllers/product/coupon_controller.dart';
import 'package:pine/features/shop/models/cart_model.dart';
import 'package:pine/features/shop/models/product_model.dart';
import 'package:pine/features/shop/screens/checkout/widgets/vnppay_webview.dart';
import 'package:pine/navigation_menu.dart';
import 'package:pine/utils/constants/enums.dart';
import 'package:pine/utils/constants/image_strings.dart';
import 'package:pine/utils/helpers/network_manager.dart';
import 'package:pine/utils/helpers/vnpay_helper.dart';
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
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PLoaders.warningSnackBar(
            title: 'Không có kết nối mạng',
            message: 'Vui lòng kiểm tra kết nối internet.');
        return;
      }

      final selectedItems = cartController.getSelectedItems();
      if (selectedItems.isEmpty) {
        PLoaders.warningSnackBar(
            title: 'Chưa chọn sản phẩm',
            message: 'Vui lòng chọn sản phẩm để thanh toán.');
        return;
      }

      if (addressController.selectedAddress.value.id.isEmpty) {
        PLoaders.warningSnackBar(
            title: 'Chưa chọn địa chỉ',
            message: 'Vui lòng thêm địa chỉ giao hàng.');
        return;
      }
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) {
        PFullScreenLoader.stopLoading();
        PLoaders.warningSnackBar(
            title: 'Lỗi xác thực', message: 'Vui lòng đăng nhập để tiếp tục');
        return;
      }

      final paymentMethod = checkoutController.selectedPaymentMethod.value.name;

      if (paymentMethod == 'VNPAY') {
        // ================= XỬ LÝ VNPAY =================
        PFullScreenLoader.openLoadingDiaLog(
            'Đang tạo yêu cầu VNPAY...', PImages.verify);

        final vnpayTxnRef = '${DateTime.now().millisecondsSinceEpoch}_$userId';
        final orderInfo = 'Thanh toan don hang $vnpayTxnRef';

        String? ipAddress = '127.0.0.1';
        try {
          ipAddress = await NetworkInfo().getWifiIP();
          ipAddress ??= '127.0.0.1';
        } catch (e) {
          print("Lỗi khi lấy địa chỉ IP: $e. Sử dụng IP mặc định.");
          ipAddress = '127.0.0.1';
        }

        // Tạo URL thanh toán VNPAY
        final paymentUrl = VNPAYHelper.generatePaymentUrl(
          orderId: vnpayTxnRef,
          amount: totalAmount,
          orderInfo: orderInfo,
          ipAddress: ipAddress,
        );

        PFullScreenLoader.stopLoading();

        final result = await Get.to<Map<String, String>?>(
            () => VnpayWebViewScreen(paymentUrl: paymentUrl));

        if (result != null) {
          await handleVnpayReturn(result, totalAmount, vnpayTxnRef);
        } else {
          PLoaders.warningSnackBar(
              title: 'Đã hủy',
              message: 'Quá trình thanh toán VNPAY đã bị hủy.');
        }
        // ================= KẾT THÚC XỬ LÝ VNPAY =================
      } else {
        // ================= XỬ LÝ CÁC PHƯƠNG THỨC COD =================
        PFullScreenLoader.openLoadingDiaLog(
            'Đang xử lý đơn hàng...', PImages.verify);

        // 7. Kiểm tra và cập nhật tồn kho (cho COD)
        final stockCheckResult = await _checkAndUpdateStock(selectedItems);
        if (!stockCheckResult.success) {
          PFullScreenLoader.stopLoading();
          PLoaders.warningSnackBar(
              title: 'Không thể đặt hàng', message: stockCheckResult.message);
          return;
        }

        final coupon = couponController.selectedCoupon.value;
        final subTotal = cartController.selectedItemsPrice.value;
        final discountAmount = couponController.calculateDiscount(subTotal);

        final finalOrderId = UniqueKey().toString();

        final order = OrderModel(
          id: finalOrderId,
          userId: userId,
          status: OrderStatus.pending,
          totalAmount: totalAmount,
          orderDate: DateTime.now(),
          paymentMethod: paymentMethod,
          address: addressController.selectedAddress.value,
          deliveryDate: null,
          items: selectedItems,
          couponId: coupon.id.isNotEmpty ? coupon.id : null,
          couponCode: coupon.id.isNotEmpty ? coupon.couponCode : null,
          discountAmount: discountAmount,
        );

        await orderRepository.saveOrder(order, userId);

        if (coupon.id.isNotEmpty) {
          await couponController.markCouponAsUsed(finalOrderId);
        }

        cartController.removeSelectedItems(showNotification: false);

        PFullScreenLoader.stopLoading();
        Get.off(() => SuccessScreen(
              image: PImages.success,
              title: 'Đặt hàng thành công!',
              subTitle: 'Đơn hàng của bạn sẽ sớm được giao.',
              onPressed: () => Get.offAll(() => const NavigationMenu()),
            ));
        // ================= KẾT THÚC XỬ LÝ COD =================
      }
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(
          title: 'Ôi không!',
          message: 'Đã xảy ra lỗi khi xử lý đơn hàng: ${e.toString()}');
    }
  }

  /// Xử lý dữ liệu trả về từ VNPAY sau khi người dùng hoàn tất trên WebView
  Future<void> handleVnpayReturn(Map<String, String> returnParams,
      double totalAmount, String vnpayTxnRef) async {
    try {
      PFullScreenLoader.openLoadingDiaLog(
          'Đang xác nhận thanh toán VNPAY...', PImages.verify);

      final paramsToValidate = Map<String, String>.from(returnParams);
      final isValidSignature = VNPAYHelper.validateReturnData(paramsToValidate);
      if (!isValidSignature) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(
            title: 'Lỗi bảo mật', message: 'Chữ ký VNPAY không hợp lệ.');
        return;
      }

      final responseCode = returnParams['vnp_ResponseCode'];
      final transactionNo = returnParams['vnp_TransactionNo'] ?? 'N/A';
      final bankCode = returnParams['vnp_BankCode'] ?? '';
      final payDate = returnParams['vnp_PayDate'] ?? '';
      final orderInfo = returnParams['vnp_OrderInfo'] ?? '';
      final returnedTxnRef = returnParams['vnp_TxnRef'] ?? '';

      if (returnedTxnRef != vnpayTxnRef) {
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(
            title: 'Lỗi đối chiếu',
            message: 'Mã tham chiếu giao dịch không khớp.');
        return;
      }

      if (responseCode == '00') {
        PLoaders.successSnackBar(
            title: 'Thành công', message: 'Thanh toán VNPAY thành công!');

        final selectedItems = cartController.getSelectedItems();
        final stockCheckResult = await _checkAndUpdateStock(selectedItems);
        if (!stockCheckResult.success) {
          PFullScreenLoader.stopLoading();
          PLoaders.errorSnackBar(
              title: 'Lỗi sau thanh toán',
              message:
                  "${stockCheckResult.message}. Đã thanh toán nhưng không thể cập nhật kho. Liên hệ hỗ trợ.");
          return;
        }

        final userId = AuthenticationRepository.instance.authUser?.uid;
        if (userId == null || userId.isEmpty) {
          PFullScreenLoader.stopLoading();
          PLoaders.errorSnackBar(
              title: 'Lỗi người dùng',
              message: 'Không tìm thấy người dùng sau khi thanh toán.');
          return;
        }

        final coupon = couponController.selectedCoupon.value;
        final subTotal = cartController.selectedItemsPrice.value;
        final discountAmount = couponController.calculateDiscount(subTotal);

        final finalOrderId = UniqueKey().toString();

        final order = OrderModel(
          id: finalOrderId,
          userId: userId,
          status: OrderStatus.processing,
          totalAmount: totalAmount,
          orderDate: DateTime.now(),
          paymentMethod: 'VNPAY',
          address: addressController.selectedAddress.value,
          deliveryDate: null,
          items: selectedItems,
          couponId: coupon.id.isNotEmpty ? coupon.id : null,
          couponCode: coupon.id.isNotEmpty ? coupon.couponCode : null,
          discountAmount: discountAmount,
        );

        await orderRepository.saveOrder(order, userId);
        print(
            'VNPAY Success: OrderID=$finalOrderId, TxnRef=$vnpayTxnRef, VNPAYTxnNo=$transactionNo, Bank=$bankCode, PayDate=$payDate');

        if (coupon.id.isNotEmpty) {
          await couponController.markCouponAsUsed(finalOrderId);
        }

        cartController.removeSelectedItems(showNotification: false);

        PFullScreenLoader.stopLoading();
        Get.off(() => SuccessScreen(
              image: PImages.success,
              title: 'Thanh toán thành công!',
              subTitle: 'Đơn hàng $finalOrderId của bạn đã được ghi nhận.',
              onPressed: () => Get.offAll(() => const NavigationMenu()),
            ));
      } else {
        // --- THANH TOÁN THẤT BẠI ---
        PFullScreenLoader.stopLoading();
        PLoaders.errorSnackBar(
            title: 'Thanh toán không thành công',
            message:
                'Lý do: ${getVnpayErrorMessage(responseCode)} (Mã: $responseCode)');
      }
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(
          title: 'Lỗi xử lý kết quả VNPAY', message: e.toString());
    }
  }

  /// Trả về thông báo lỗi dựa trên mã phản hồi của VNPAY
  String getVnpayErrorMessage(String? responseCode) {
    switch (responseCode) {
      case '01':
        return 'Giao dịch đã tồn tại';
      case '02':
        return 'Merchant không hợp lệ (kiểm tra TmnCode)';
      case '03':
        return 'Dữ liệu gửi sang không đúng định dạng';
      case '04':
        return 'Khởi tạo GD không thành công do Website đang bị tạm khóa';
      case '05':
        return 'Giao dịch không thành công do: Quý khách nhập sai mật khẩu thanh toán quá số lần quy định.';
      case '06':
        return 'Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP).';
      case '07':
        return 'Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường). Cần xác minh.';
      case '09':
        return 'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking.';
      case '10':
        return 'Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần';
      case '11':
        return 'Giao dịch không thành công do: Đã hết hạn chờ thanh toán.';
      case '12':
        return 'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.';
      case '13':
        return 'Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP).';
      case '24':
        return 'Giao dịch không thành công do: Khách hàng hủy giao dịch';
      case '51':
        return 'Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư.';
      case '65':
        return 'Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.';
      case '75':
        return 'Ngân hàng thanh toán đang bảo trì.';
      case '79':
        return 'Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định.';
      case '99':
        return 'Các lỗi khác không xác định.';
      default:
        return 'Lỗi không xác định từ VNPAY.';
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
