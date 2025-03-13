import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';

import '../../features/shop/models/order_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Get all order related to current user
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) {
        throw 'Không tìm thấy thông tin. Vui lòng thử lại sau.';
      }

      final result =
          await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs
          .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Lỗi khi tải thông tin đơn hàng. Vui lòng thử lại sau.';
    }
  }

  /// Store new user order
  Future<void> saveOrder(OrderModel order, String userId) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add(order.toJson());
    } catch (e) {
      throw 'Lỗi khi lưu thông tin đơn hàng. Vui lòng thử lại sau.';
    }
  }
}
