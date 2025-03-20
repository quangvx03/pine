import 'package:get/get.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../utils/constants/enums.dart';
import '../models/order_model.dart';


class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  // -- Order
  static final List<OrderModel> orders = [
    OrderModel(
        id: 'P0012',
        status: OrderStatus.pending,
        totalAmount: 265.000,
        orderDate: DateTime(2025, 2, 20),
        deliveryDate: DateTime(2025, 2, 20), items: []),
    OrderModel(
        id: 'P0025',
        status: OrderStatus.processing,
        totalAmount: 369.000,
        orderDate: DateTime(2024, 5, 21),
        deliveryDate: DateTime(2024, 5, 21), items: []),
    OrderModel(
        id: 'P0152',
        status: OrderStatus.delivered,
        totalAmount: 254.000,
        orderDate: DateTime(2024, 5, 22),
        deliveryDate: DateTime(2024, 5, 22), items: []),
    OrderModel(
        id: 'P0256',
        status: OrderStatus.processing,
        totalAmount: 355.000,
        orderDate: DateTime(2024, 5, 23),
        deliveryDate: DateTime(2024, 5, 23), items: []),
    OrderModel(
        id: 'P1536',
        status: OrderStatus.cancelled,
        totalAmount: 115.000,
        orderDate: DateTime(2024, 5, 24),
        deliveryDate: DateTime(2024, 5, 24), items: []),
  ];

  @override
  void onInit() {
    _calculateWeeklySales();
    _calculateOrderStatusData();
    super.onInit();
  }

  // Calculate weekly sales
  void _calculateWeeklySales() {
    // Reset weeklySales to zeros
    weeklySales.value = List<double>.filled(7, 0.0);

    for (var order in orders) {
      final DateTime orderWeekStart = PHelperFunctions.getStartOfWeek(
          order.orderDate);

      // Check if the order is within the current week
      if (orderWeekStart.isBefore(DateTime.now()) &&
          orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (order.orderDate.weekday - 1) % 7;

        // Ensure the index is non-negative
        index = index < 0 ? index + 7 : index;

        weeklySales[index] += order.totalAmount;

        print('Ngày đặt hàng: ${order
            .orderDate}, CurrentWeekDay: $orderWeekStart, Index: $index');
      }
    }

    print('Bán hàng hàng tuần: $weeklySales');
  }

  void _calculateOrderStatusData() {
    // Reset status data
    orderStatusData.clear();

    // Map to store total amounts for each status
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};

    for (var order in orders) {
      // Count Orders
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;

      // Calculate total amounts for each status
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }
  }
  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Đang chuẩn bị';
      case OrderStatus.processing:
        return 'Đang xử lý';
      case OrderStatus.shipped:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Giao hàng thành công';
      case OrderStatus.cancelled:
        return 'Đã hủy đơn hàng';
      default:
        return 'Không xác định';
    }
  }
}