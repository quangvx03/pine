import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import '../../features/shop/controllers/dashboard/notification_controller.dart';
import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final NotificationController _notificationController = Get.put(NotificationController());

  Future<List<OrderModel>> getAllOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    try {
      final result = await _db
          .collection("Users")
          .doc(userId)
          .collection("Orders")
          .orderBy('orderDate', descending: true)
          .get();
      return result.docs.map((querySnapshot) => OrderModel.fromSnapshot(querySnapshot)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<OrderModel>> getAllOrdersForAllUsers() async {
    List<OrderModel> allOrders = [];

    try {
      final users = await _db.collection("Users").get();

      for (var user in users.docs) {
        final userId = user.id;

        final orders = await _db
            .collection("Users")
            .doc(userId)
            .collection("Orders")
            .orderBy('orderDate', descending: true)
            .get();

        final orderList = orders.docs.map((querySnapshot) => OrderModel.fromSnapshot(querySnapshot)).toList();

        allOrders.addAll(orderList);
      }

      return allOrders;
    } catch (e) {
      return [];
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _db.collection("Users").doc(order.userId).collection("Orders").add(order.toJson());

      await _db.collection("Notifications").add({
        'title': 'Đơn hàng mới',
        'message': 'Khách hàng ${order.userId} đã đặt một đơn hàng mới!',
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _notificationController.addNotification(
        'Đơn hàng mới',
        'Khách hàng ${order.userId} đã đặt một đơn hàng mới!',
      );
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

  Future<void> updateOrderSpecificValue(String userId, String orderId, Map<String, dynamic> data) async {
    try {
      if (userId.isEmpty || orderId.isEmpty) {
        throw 'User ID hoặc Order ID không hợp lệ!';
      }
      await _db.collection("Users").doc(userId).collection("Orders").doc(orderId).update(data);
    } on FirebaseException catch (e) {
      throw 'Firebase Error: ${e.code}';
    } catch (e) {
      throw 'Lỗi không xác định khi cập nhật đơn hàng! Lỗi: $e';
    }
  }

  Future<void> deleteOrder(String userId, String orderId) async {
    try {

      await _db.collection("Users").doc(userId).collection("Orders").doc(orderId).delete();
    } on FirebaseException catch (e) {
      throw PFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const PFormatException();
    } on PlatformException catch (e) {
      throw PPlatformException(e.code).message;
    } catch (e) {
      throw 'Có lỗi khi xóa đơn hàng';
    }
  }

}
