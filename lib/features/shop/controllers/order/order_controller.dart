import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/order_repository.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

class OrderController extends PBaseController<OrderModel> {
  static OrderController get instance => Get.find();

  RxBool statusLoader = false.obs;
  var orderStatus = OrderStatus.delivered.obs;
  final _orderRepository = Get.put(OrderRepository());

  @override
  Future<List<OrderModel>> fetchItems() async {
    sortAscending.value = false;
    return await _orderRepository.getAllOrdersForAllUsers();
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) {
    return item.id.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    final userId = item.userId;
    final orderId = item.docId;

    await _orderRepository.deleteOrder(userId, orderId);
    await fetchItems();

    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.totalAmount.toString().toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (OrderModel o) => o.orderDate.toString().toLowerCase());
  }

  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    try {
      statusLoader.value = true;

      final Map<String, dynamic> updateData = {
        'status': newStatus.toString(),
      };

      if (newStatus == OrderStatus.delivered) {
        updateData['deliveryDate'] = DateTime.now();
      }

      await _orderRepository.updateOrderSpecificValue(
        order.userId,
        order.docId,
        updateData,
      );

      final updatedOrderDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(order.userId)
          .collection('Orders')
          .doc(order.docId)
          .get();

      if (updatedOrderDoc.exists) {
        final updatedOrder = OrderModel.fromSnapshot(updatedOrderDoc);

        final index = filteredItems.indexWhere((e) => e.docId == order.docId);
        if (index != -1) {
          filteredItems[index] = updatedOrder;
        }

        orderStatus.value = updatedOrder.status;
        filteredItems.refresh();
        update();

        PLoaders.successSnackBar(title: 'Đã cập nhật', message: 'Trạng thái đơn hàng đã được cập nhật');
      } else {
        PLoaders.warningSnackBar(title: 'Lỗi', message: 'Không tìm thấy đơn hàng.');
      }
    } catch (e) {
      PLoaders.warningSnackBar(title: 'Ôi không!', message: e.toString());
    } finally {
      statusLoader.value = false;
    }
  }

}
