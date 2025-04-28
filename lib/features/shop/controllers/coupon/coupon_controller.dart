import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/coupon_repository.dart';

import '../../models/coupon_model.dart';

class CouponController extends PBaseController<CouponModel> {
  static CouponController get instance => Get.find();

  final _couponRepository = Get.put(CouponRepository());

  var couponTypes = ['Tất cả', 'Phần trăm', 'Cố định'].obs;
  var selectedType = 'Tất cả'.obs;

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
    await fetchCouponsWithUsedCount();
    return filteredItems;
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) {
      return removeDiacritics(coupon.couponCode.toLowerCase());
    });
  }

  Future<void> fetchCouponsWithUsedCount() async {
    final now = DateTime.now();
    final snapshot = await FirebaseFirestore.instance.collection('Coupons').get();

    final coupons = await Future.wait(snapshot.docs.map((doc) async {
      CouponModel coupon = CouponModel.fromSnapshot(doc);
      final usedCount = await _couponRepository.getUsedCount(coupon.id);

      if (coupon.endDate != null && coupon.endDate!.isBefore(now) && coupon.status) {
        coupon = coupon.copyWith(status: false);
        await _couponRepository.updateCoupon(coupon);
      }

      return coupon.copyWith(usedCount: usedCount);
    }).toList());

    allItems.value = coupons;
    applyFilters();
  }

  void filterByType(String type) {
    selectedType.value = type;
    applyFilters();
  }

  @override
  void searchQuery(String query) {
    super.searchQuery(query);
    applyFilters();
  }

  void applyFilters() {
    final type = selectedType.value;
    final query = searchTextController.text.trim().toLowerCase();

    filteredItems.value = allItems.where((coupon) {
      final matchType = (type == 'Tất cả') || (coupon.type == type);
      final matchSearch = containsSearchQuery(coupon, query);
      return matchType && matchSearch;
    }).toList();
  }

  void sortByEndDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) {
      return coupon.endDate?.millisecondsSinceEpoch ?? 0;
    });
  }

  void sortByUsedCount(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) {
      return coupon.usedCount ?? 0;
    });
  }

}
