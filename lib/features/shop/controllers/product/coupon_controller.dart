import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/data/repositories/coupon_repository.dart';
import 'package:pine/features/shop/models/coupon_model.dart';
import 'package:pine/features/shop/models/used_coupon_model.dart';
import 'package:pine/features/shop/screens/coupon/coupon_selection.dart'; // Import file mới
import 'package:pine/utils/helpers/helper_functions.dart';
import 'package:pine/utils/popups/loaders.dart';

class CouponController extends GetxController {
  static CouponController get instance => Get.find();

  // Repository
  final couponRepository = Get.put(CouponRepository());

  // Observable variables
  final RxList<CouponModel> availableCoupons = <CouponModel>[].obs;
  final Rx<CouponModel> selectedCoupon = CouponModel.empty().obs;
  final RxDouble orderAmount = 0.0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAvailableCoupons();
  }

  /// Reset trạng thái của controller (gọi khi thoát khỏi màn hình checkout)
  void resetCouponState() {
    selectedCoupon.value = CouponModel.empty();
    orderAmount.value = 0.0;
  }

  /// Lấy danh sách mã giảm giá hiện có cho người dùng
  Future<void> fetchAvailableCoupons() async {
    try {
      isLoading.value = true;

      // Lấy ID người dùng trực tiếp từ AuthenticationRepository
      final userId = AuthenticationRepository.instance.authUser?.uid ?? '';
      if (userId.isEmpty) {
        availableCoupons.clear();
        return;
      }

      final coupons = await couponRepository.getAvailableCouponsForUser(userId);
      availableCoupons.assignAll(coupons);
    } catch (e) {
      debugPrint('Lỗi khi tải mã giảm giá: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Chọn mã giảm giá
  void selectCoupon(CouponModel coupon) {
    if (!isCouponApplicable(coupon)) {
      PLoaders.warningSnackBar(
        title: 'Không thể áp dụng',
        message:
            'Đơn hàng tối thiểu ${PHelperFunctions.formatCurrency(coupon.minimumPurchaseAmount)}',
      );
      return;
    }
    selectedCoupon.value = coupon;
    Get.back(); // Đóng bottom sheet sau khi chọn
  }

  /// Xóa mã giảm giá đã chọn
  void clearSelectedCoupon() {
    selectedCoupon.value = CouponModel.empty();
  }

  /// Kiểm tra mã giảm giá có áp dụng được không
  bool isCouponApplicable(CouponModel coupon) {
    return couponRepository.isCouponValid(
        coupon: coupon, orderAmount: orderAmount.value);
  }

  /// Tính giá trị giảm giá
  double calculateDiscount(double amount) {
    final coupon = selectedCoupon.value;
    if (coupon.id.isEmpty) return 0;

    return couponRepository.calculateDiscount(
      coupon: coupon,
      orderAmount: amount,
    );
  }

  /// Đánh dấu mã giảm giá đã sử dụng
  Future<void> markCouponAsUsed(String orderId) async {
    try {
      final coupon = selectedCoupon.value;
      if (coupon.id.isEmpty) return;

      // Lấy userId trực tiếp từ AuthenticationRepository
      final userId = AuthenticationRepository.instance.authUser?.uid ?? '';
      if (userId.isEmpty) return;

      // Tạo model UsedCoupon trong controller (đã chuyển từ repository)
      final usedCoupon = UsedCouponModel(
        id: '', // ID sẽ được Firestore tạo tự động
        userId: userId,
        couponId: coupon.id,
        orderId: orderId,
        usedAt: DateTime.now(),
        couponCode: coupon.couponCode,
        discountAmount: coupon.discountAmount,
        type: coupon.type,
      );

      // Gọi repository chỉ để lưu model
      await couponRepository.markCouponAsUsed(usedCoupon);

      // Làm mới danh sách mã giảm giá
      await fetchAvailableCoupons();
    } catch (e) {
      debugPrint('Lỗi khi đánh dấu mã giảm giá đã sử dụng: $e');
    }
  }

  /// Hiển thị màn hình chọn mã giảm giá dạng bottom sheet
  Future<dynamic> showCouponSelectionModal(double amount) async {
    // Cập nhật số tiền đơn hàng hiện tại
    orderAmount.value = amount;
    fetchAvailableCoupons();

    // Hiển thị bottom sheet
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (_) => const CouponSelectionModal(),
    );
  }

  /// Format thông tin giảm giá để hiển thị
  String getDiscountText(CouponModel coupon) {
    if (coupon.type == 'Cố định') {
      return 'Giảm ${PHelperFunctions.formatCurrency(coupon.discountAmount)}';
    } else {
      // Phần trăm
      return 'Giảm ${coupon.discountAmount.toStringAsFixed(0)}%';
    }
  }
}
