import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/coupon_repository.dart';

import '../../models/coupon_model.dart';

class CouponController extends PBaseController<CouponModel> {
  static CouponController get instance => Get.find();

  final _couponRepository = Get.put(CouponRepository());

  @override
  bool containsSearchQuery(CouponModel item, String query) {
    return item.couponCode.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(CouponModel item) async {
    await _couponRepository.deleteCoupon(item.id);
  }

  @override
  Future<List<CouponModel>> fetchItems() async {
    return await _couponRepository.getAllCoupons();
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) {
      return removeDiacritics(coupon.couponCode.toLowerCase());
    });
  }
}