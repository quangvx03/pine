import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/features/shop/models/coupon_model.dart';

import '../../../../data/repositories/coupon_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import 'coupon_controller.dart';

class EditCouponController extends GetxController {
  static EditCouponController get instance => Get.find();

  final loading = false.obs;
  final status = false.obs;
  final couponCode = TextEditingController();
  final type = ''.obs;
  final discountAmount = TextEditingController();
  final minimumPurchaseAmount = TextEditingController();
  final endDate = TextEditingController();
  final description = TextEditingController(); // 🔹 THÊM MỚI
  final Rxn<DateTime> selectedEndDate = Rxn<DateTime>();

  final formKey = GlobalKey<FormState>();

  /// 🛠 Khởi tạo dữ liệu khi chỉnh sửa mã giảm giá
  void init(CouponModel coupon) {
    couponCode.text = coupon.couponCode;
    type.value = coupon.type;
    discountAmount.text = coupon.discountAmount.toString();
    minimumPurchaseAmount.text = coupon.minimumPurchaseAmount.toString();
    status.value = coupon.status;
    description.text = coupon.description ?? ''; // 🔹 THÊM MỚI

    if (coupon.endDate != null) {
      selectedEndDate.value = coupon.endDate;
      endDate.text = DateFormat('dd/MM/yyyy').format(coupon.endDate!);
    }
  }

  /// 📅 Chọn ngày hết hạn
  Future<void> pickEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      selectedEndDate.value = pickedDate;
      endDate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  /// 📝 Cập nhật mã giảm giá
  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      PFullScreenLoader.popUpCircular();
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        PFullScreenLoader.stopLoading();
        return;
      }
      if (!formKey.currentState!.validate()) {
        PFullScreenLoader.stopLoading();
        return;
      }

      // Cập nhật thông tin mã giảm giá
      coupon.couponCode = couponCode.text.trim();
      coupon.type = type.value;
      coupon.discountAmount = double.tryParse(discountAmount.text.trim()) ?? 0;
      coupon.minimumPurchaseAmount = double.tryParse(minimumPurchaseAmount.text.trim()) ?? 0;
      coupon.endDate = selectedEndDate.value;
      coupon.status = status.value;
      coupon.description = description.text.trim(); // 🔹 THÊM MỚI
      coupon.updatedAt = DateTime.now();

      // Gửi dữ liệu cập nhật lên server
      await CouponRepository.instance.updateCoupon(coupon);

      // Cập nhật danh sách trong CouponController
      CouponController.instance.updateItemFromLists(coupon);

      resetFields();

      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Thành công', message: 'Mã giảm giá đã được cập nhật!');
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  /// 🔄 Reset các trường nhập sau khi cập nhật
  void resetFields() {
    loading(false);
    status(false);
    couponCode.clear();
    type.value = '';
    discountAmount.clear();
    minimumPurchaseAmount.clear();
    endDate.clear();
    description.clear(); // 🔹 THÊM MỚI
  }
}

