import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/models/coupon_model.dart';
import 'package:pine_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:pine_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:pine_admin_panel/utils/exceptions/platform_exceptions.dart';

class CouponRepository extends GetxController {
  static CouponRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<CouponModel>> getAllCoupons() async {
    try {
      final snapshot = await _db.collection("Coupons").get();
      final now = DateTime.now();

      final coupons = await Future.wait(snapshot.docs.map((doc) async {
        var coupon = CouponModel.fromSnapshot(doc);

        if (coupon.endDate != null && coupon.endDate!.isBefore(now) && coupon.status) {
          coupon = coupon.copyWith(status: false);
          await updateCoupon(coupon);
        }

        return coupon;
      }).toList());

      return coupons;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<int> getUsedCount(String couponId) async {
    final usersSnapshot = await _db.collection('Users').get();
    int totalUsed = 0;

    for (var userDoc in usersSnapshot.docs) {
      final usedCouponsSnapshot = await _db
          .collection('Users')
          .doc(userDoc.id)
          .collection('UsedCoupons')
          .where('CouponId', isEqualTo: couponId)
          .get();

      totalUsed += usedCouponsSnapshot.size;
    }

    return totalUsed;
  }

  Future<String> createCoupon(CouponModel coupon) async {
    try{
      final data = await _db.collection("Coupons").add(coupon.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> updateCoupon(CouponModel coupon) async {
    try{
      await _db.collection("Coupons").doc(coupon.id).update(coupon.toJson());
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try{
      await _db.collection("Coupons").doc(couponId).delete();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi xảy ra. Vui lòng thử lại';
    }
  }
}