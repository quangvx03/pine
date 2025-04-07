import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine/data/repositories/authentication_repository.dart';
import 'package:pine/utils/constants/enums.dart';

import '../../features/shop/models/order_model.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

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

  // Thêm các phương thức này vào order_repository.dart

  /// Tìm document dựa trên model ID
  Future<DocumentSnapshot?> findOrderDocumentByModelId(String modelId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;

      // Truy vấn tất cả đơn hàng của người dùng và lọc theo ID trong model
      final querySnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .where('id', isEqualTo: modelId)
          .limit(1) // Chỉ cần 1 kết quả
          .get();

      // Kiểm tra xem có tìm thấy đơn hàng không
      if (querySnapshot.docs.isEmpty) {
        return null; // Không tìm thấy đơn hàng
      }

      // Lấy document đầu tiên từ kết quả
      return querySnapshot.docs.first;
    } catch (e) {
      throw 'Không thể tìm thấy đơn hàng: $e';
    }
  }

  /// Cập nhật trạng thái đơn hàng dựa trên model ID
  Future<void> updateOrderStatus(String modelId, OrderStatus newStatus) async {
    try {
      final userId = AuthenticationRepository.instance.authUser.uid;

      // Tìm document dựa trên model ID
      final doc = await findOrderDocumentByModelId(modelId);

      if (doc == null) {
        throw 'Không tìm thấy đơn hàng với ID: $modelId';
      }

      // Dữ liệu cần cập nhật - luôn có trạng thái
      final Map<String, dynamic> updateData = {
        'status': newStatus.toString(),
      };

      // Nếu đơn hàng được giao thành công HOẶC bị hủy, ghi lại thời điểm hiện tại vào deliveryDate
      if (newStatus == OrderStatus.delivered ||
          newStatus == OrderStatus.cancelled) {
        updateData['deliveryDate'] = DateTime.now();
      }

      // Cập nhật trạng thái đơn hàng
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .doc(doc.id) // Sử dụng document ID
          .update(updateData);
    } catch (e) {
      throw 'Không thể cập nhật trạng thái đơn hàng: $e';
    }
  }

  /// Lấy thông tin đơn hàng chi tiết theo model ID
  Future<OrderModel?> getOrderDetails(String modelId) async {
    try {
      final doc = await findOrderDocumentByModelId(modelId);
      if (doc == null) {
        return null;
      }
      return OrderModel.fromSnapshot(doc);
    } catch (e) {
      throw 'Không thể lấy thông tin đơn hàng: $e';
    }
  }
}
