import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine/features/shop/models/coupon_model.dart';
import 'package:pine/features/shop/models/used_coupon_model.dart';

/// Repository quản lý các hoạt động liên quan đến mã giảm giá
class CouponRepository extends GetxController {
  static CouponRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Lấy tất cả mã giảm giá còn hiệu lực
  Future<List<CouponModel>> getAllValidCoupons() async {
    try {
      final now = DateTime.now();
      final snapshot = await _db
          .collection('Coupons')
          .where('Status', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => CouponModel.fromSnapshot(doc))
          .where((coupon) {
        // Kiểm tra ngày hết hạn
        if (coupon.endDate != null && coupon.endDate!.isBefore(now)) {
          return false;
        }
        return true;
      }).toList();
    } catch (e) {
      debugPrint('Lỗi khi lấy mã giảm giá: $e');
      return [];
    }
  }

  /// Lấy mã giảm giá theo ID
  Future<CouponModel?> getCouponById(String couponId) async {
    try {
      final snapshot = await _db.collection('Coupons').doc(couponId).get();
      if (snapshot.exists) {
        return CouponModel.fromSnapshot(snapshot);
      }
      return null;
    } catch (e) {
      debugPrint('Lỗi khi lấy thông tin mã giảm giá: $e');
      return null;
    }
  }

  /// Lấy thông tin các mã giảm giá đã sử dụng bởi người dùng
  Future<List<UsedCouponModel>> getUserUsedCoupons(String userId) async {
    try {
      final snapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('UsedCoupons')
          .get();

      return snapshot.docs
          .map((doc) => UsedCouponModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      debugPrint('Lỗi khi lấy thông tin mã giảm giá đã sử dụng: $e');
      return [];
    }
  }

  /// Lấy tất cả mã giảm giá đã sử dụng (dành cho admin)
  Future<List<UsedCouponModel>> getAllUsedCoupons() async {
    try {
      // Lấy danh sách tất cả người dùng
      final usersSnapshot = await _db.collection('Users').get();
      List<UsedCouponModel> allUsedCoupons = [];

      // Với mỗi người dùng, lấy danh sách mã giảm giá đã sử dụng
      for (var userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final userCouponsSnapshot = await _db
            .collection('Users')
            .doc(userId)
            .collection('UsedCoupons')
            .get();

        final userCoupons = userCouponsSnapshot.docs
            .map((doc) => UsedCouponModel.fromSnapshot(doc))
            .toList();

        allUsedCoupons.addAll(userCoupons);
      }

      return allUsedCoupons;
    } catch (e) {
      debugPrint('Lỗi khi lấy thông tin tất cả mã giảm giá đã sử dụng: $e');
      return [];
    }
  }

  /// Lấy các mã giảm giá còn hiệu lực và chưa được sử dụng bởi người dùng
  Future<List<CouponModel>> getAvailableCouponsForUser(String userId) async {
    try {
      // 1. Lấy danh sách mã giảm giá đã sử dụng bởi người dùng
      final usedCoupons = await getUserUsedCoupons(userId);
      final usedCouponIds =
          usedCoupons.map((coupon) => coupon.couponId).toList();

      // 2. Lấy tất cả mã giảm giá còn hiệu lực
      final now = DateTime.now();
      final couponsSnapshot = await _db
          .collection('Coupons')
          .where('Status', isEqualTo: true)
          .get();

      // 3. Lọc ra các mã giảm giá chưa được sử dụng và còn hiệu lực
      return couponsSnapshot.docs
          .map((doc) => CouponModel.fromSnapshot(doc))
          .where((coupon) {
        // Kiểm tra chưa sử dụng
        if (usedCouponIds.contains(coupon.id)) return false;

        // Kiểm tra chưa hết hạn
        if (coupon.endDate != null && coupon.endDate!.isBefore(now)) {
          return false;
        }

        return true;
      }).toList();
    } catch (e) {
      debugPrint('Lỗi khi lấy mã giảm giá khả dụng: $e');
      return [];
    }
  }

  /// Đánh dấu mã giảm giá đã được sử dụng bởi người dùng
  Future<void> markCouponAsUsed(UsedCouponModel usedCoupon) async {
    try {
      // Lưu vào subcollection của User
      await _db
          .collection('Users')
          .doc(usedCoupon.userId)
          .collection('UsedCoupons')
          .add(usedCoupon.toJson());
    } catch (e) {
      debugPrint('Lỗi khi đánh dấu mã giảm giá đã sử dụng: $e');
      throw Exception('Không thể đánh dấu mã giảm giá là đã sử dụng: $e');
    }
  }

  /// Tính giá trị giảm giá dựa trên loại mã giảm giá
  double calculateDiscount({
    required CouponModel coupon,
    required double orderAmount,
  }) {
    // Kiểm tra giá trị đơn hàng tối thiểu
    if (orderAmount < coupon.minimumPurchaseAmount) {
      return 0;
    }

    // Xử lý theo loại mã giảm giá
    if (coupon.type == 'Cố định') {
      // Giảm giá cố định
      return coupon.discountAmount;
    } else if (coupon.type == 'Phần trăm') {
      // Giảm giá theo phần trăm
      return orderAmount * (coupon.discountAmount / 100);
    }

    return 0;
  }

  /// Kiểm tra mã giảm giá có hợp lệ để sử dụng không
  bool isCouponValid({
    required CouponModel coupon,
    required double orderAmount,
  }) {
    // Kiểm tra trạng thái
    if (!coupon.status) return false;

    // Kiểm tra ngày hết hạn
    final now = DateTime.now();
    if (coupon.endDate != null && coupon.endDate!.isBefore(now)) {
      return false;
    }

    // Kiểm tra giá trị đơn hàng tối thiểu
    if (orderAmount < coupon.minimumPurchaseAmount) {
      return false;
    }

    return true;
  }
}
