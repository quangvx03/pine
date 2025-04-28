import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/data/repositories/order_repository.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../../../data/repositories/product_repository.dart';

class OrderController extends PBaseController<OrderModel> {
  static OrderController get instance => Get.find();

  RxBool statusLoader = false.obs;
  final _orderRepository = Get.put(OrderRepository());
  final orderStatuses = ['Tất cả', 'Đang xử lý', 'Đang chuẩn bị', 'Đang giao', 'Giao hàng thành công', 'Đã hủy'];
  var selectedStatus = 'Tất cả'.obs;

  var orderStatus = OrderStatus.delivered.obs;

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
    sortByProperty(
      sortColumnIndex,
      ascending,
          (OrderModel o) => o.totalAmount.toString().toLowerCase(),
    );
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (OrderModel o) => o.orderDate.toString().toLowerCase(),
    );
  }

  void sortByItemCount(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (OrderModel order) => order.items.length,
    );
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

      await _orderRepository.updateOrderSpecificValue(order.userId, order.docId, updateData);
      if (newStatus == OrderStatus.delivered) {
        updateData['deliveryDate'] = DateTime.now();
        for (var item in order.items) {
          await ProductRepository.instance.deductStockAndIncreaseSold(
            item.productId,
            item.quantity,
          );
        }
      }

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

  void filterByStatus(String status) {
    selectedStatus.value = status;

    if (status == 'Tất cả') {
      filteredItems.assignAll(allItems);
    } else {
      filteredItems.assignAll(
        allItems.where((order) =>
        _getStatusString(order.status).toLowerCase() == status.toLowerCase()),
      );
    }

    filteredItems.refresh();
    update();
  }

  String _getStatusString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Đang xử lý';
      case OrderStatus.processing:
        return 'Đang chuẩn bị';
      case OrderStatus.shipped:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Giao hàng thành công';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      default:
        return 'Không rõ';
    }
  }
}
