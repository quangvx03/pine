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
  final description = TextEditingController();
  final Rxn<DateTime> selectedEndDate = Rxn<DateTime>();

  final formKey = GlobalKey<FormState>();

  void init(CouponModel coupon) {
    couponCode.text = coupon.couponCode;
    type.value = coupon.type;
    discountAmount.text = coupon.discountAmount.toString();
    minimumPurchaseAmount.text = coupon.minimumPurchaseAmount.toString();
    status.value = coupon.status;
    description.text = coupon.description ?? '';

    if (coupon.endDate != null) {
      selectedEndDate.value = coupon.endDate;
      endDate.text = DateFormat('dd/MM/yyyy').format(coupon.endDate!);
    }
  }

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

      coupon.couponCode = couponCode.text.trim();
      coupon.type = type.value;
      coupon.discountAmount = double.tryParse(discountAmount.text.trim()) ?? 0;
      coupon.minimumPurchaseAmount = double.tryParse(minimumPurchaseAmount.text.trim()) ?? 0;
      coupon.endDate = selectedEndDate.value;
      coupon.status = status.value;
      coupon.description = description.text.trim();
      coupon.updatedAt = DateTime.now();

      await CouponRepository.instance.updateCoupon(coupon);

      CouponController.instance.updateItemFromLists(coupon);

      resetFields();

      PFullScreenLoader.stopLoading();
      PLoaders.successSnackBar(title: 'Thành công', message: 'Mã giảm giá đã được cập nhật!');
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Lỗi', message: e.toString());
    }
  }

  void resetFields() {
    loading(false);
    status(false);
    couponCode.clear();
    type.value = '';
    discountAmount.clear();
    minimumPurchaseAmount.clear();
    endDate.clear();
    description.clear();
  }
}

