import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/data/repositories/coupon_repository.dart';
import 'package:pine_admin_panel/features/shop/models/coupon_model.dart';
import 'package:pine_admin_panel/features/shop/models/product_model.dart';
import 'package:pine_admin_panel/utils/helpers/network_manager.dart';
import 'package:pine_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../models/category_model.dart';
import 'coupon_controller.dart';

class CreateCouponController extends GetxController {
  static CreateCouponController get instance => Get.find();

  final CouponRepository couponRepository = Get.put(CouponRepository());

  final loading = false.obs;
  final status = false.obs;
  final couponCode = TextEditingController();
  final type = ''.obs;
  final discountAmount = TextEditingController();
  final minimumPurchaseAmount = TextEditingController();
  final endDate = TextEditingController();
  final description = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final Rxn<DateTime> selectedEndDate = Rxn<DateTime>();

  Future<void> pickEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      selectedEndDate.value = pickedDate;
      endDate.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<void> createCoupon() async {
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

      final newRecord = CouponModel(
        id: '',
        couponCode: couponCode.text.trim(),
        type: type.value,
        discountAmount: double.tryParse(discountAmount.text.trim()) ?? 0,
        minimumPurchaseAmount: double.tryParse(minimumPurchaseAmount.text.trim()) ?? 0,
        endDate: selectedEndDate.value,
        status: status.value,
        createdAt: DateTime.now(),
        description: description.text.trim(),
      );

      newRecord.id = await CouponRepository.instance.createCoupon(newRecord);

      CouponController.instance.addItemToLists(newRecord);

      resetFields();

      PFullScreenLoader.stopLoading();

      String formattedDiscount = newRecord.type == 'Cố định'
          ? NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(newRecord.discountAmount)
          : '${newRecord.discountAmount}%';

      PLoaders.successSnackBar(
        title: 'Thành công',
        message: 'Đã thêm mã giảm giá thành công. Giảm giá: $formattedDiscount',
      );
    } catch (e) {
      PFullScreenLoader.stopLoading();
      PLoaders.errorSnackBar(title: 'Ôi không', message: e.toString());
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

