import 'package:get/get.dart';
import 'package:pine_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/order_model.dart';
import '../order/order_controller.dart';
import '../product/product_controller.dart';

class DashboardController extends PBaseController<OrderModel> {
  static DashboardController get instance => Get.find();

  final orderController = Get.put(OrderController());
  final customerController = Get.put(CustomerController());
  final productController = Get.put(ProductController());

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  final RxString salesViewType = 'week'.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  int get totalProductInStock => productController.allItems.fold(0, (sum, p) => sum + (p.stock ?? 0));
  int get totalProductSold => productController.allItems.fold(0, (sum, p) => sum + (p.soldQuantity ?? 0));


  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  Future<List<OrderModel>> fetchItems() async {
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }

    if (customerController.allItems.isEmpty) {
      await customerController.fetchItems();
    }

    if (productController.allItems.isEmpty) {
      await productController.fetchItems();
    }

    _calculateSalesGraphData();
    _calculateOrderStatusData();

    return orderController.allItems;
  }

  void changeSalesViewType(String type) {
    if (salesViewType.value == type) return;
    salesViewType.value = type;
    _calculateSalesGraphData();
  }

  void _calculateSalesGraphData() {
    final now = DateTime.now();
    switch (salesViewType.value) {
      case 'day':
        _calculateDailySales(now);
        break;
      case 'month':
        _calculateMonthlySales(now);
        break;
      case 'year':
        _calculateYearlySales(now);
        break;
      case 'range':
        _calculateSalesInRange();
        break;
      case 'week':
      default:
        _calculateWeeklySales(now);
    }
  }

  void _calculateWeeklySales(DateTime now) {
    final updated = List<double>.filled(7, 0.0);
    final startOfWeek = PHelperFunctions.getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    final orders = orderController.allItems.where((o) =>
    o.orderDate.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
        o.orderDate.isBefore(endOfWeek));

    for (var order in orders) {
      int index = (order.orderDate.weekday - 1) % 7;
      updated[index] += order.totalAmount;
    }

    weeklySales.assignAll(updated);
  }

  void _calculateDailySales(DateTime now) {
    final updated = List<double>.filled(24, 0.0);
    final today = DateTime(now.year, now.month, now.day);

    final orders = orderController.allItems.where((o) =>
    o.orderDate.year == today.year &&
        o.orderDate.month == today.month &&
        o.orderDate.day == today.day);

    for (var order in orders) {
      updated[order.orderDate.hour] += order.totalAmount;
    }

    weeklySales.assignAll(updated);
  }

  void _calculateMonthlySales(DateTime now) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final updated = List<double>.filled(daysInMonth, 0.0);

    final orders = orderController.allItems.where((o) =>
    o.orderDate.year == now.year && o.orderDate.month == now.month);

    for (var order in orders) {
      int dayIndex = order.orderDate.day - 1;
      updated[dayIndex] += order.totalAmount;
    }

    weeklySales.assignAll(updated);
  }

  void _calculateYearlySales(DateTime now) {
    final updated = List<double>.filled(12, 0.0);

    final orders = orderController.allItems
        .where((o) => o.orderDate.year == now.year);

    for (var order in orders) {
      updated[order.orderDate.month - 1] += order.totalAmount;
    }

    weeklySales.assignAll(updated);
  }

  void _calculateSalesInRange() {
    if (startDate.value == null || endDate.value == null) {
      weeklySales.clear();
      return;
    }

    final start = startDate.value!;
    final end = endDate.value!.add(const Duration(days: 1));
    final daysCount = end.difference(start).inDays;
    final updated = List<double>.filled(daysCount, 0.0);

    final orders = orderController.allItems.where((o) =>
    o.orderDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
        o.orderDate.isBefore(end));

    for (var order in orders) {
      int index = order.orderDate.difference(start).inDays;
      if (index >= 0 && index < daysCount) {
        updated[index] += order.totalAmount;
      }
    }

    weeklySales.assignAll(updated);
  }

  void _calculateOrderStatusData() {
    orderStatusData.clear();
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};

    for (var order in orderController.allItems) {
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    salesViewType.value = 'range';
    _calculateSalesInRange();
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

  double get todayRevenue {
    final now = DateTime.now();
    return orderController.allItems
        .where((o) =>
    o.orderDate.year == now.year &&
        o.orderDate.month == now.month &&
        o.orderDate.day == now.day)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get weekRevenue {
    final start = PHelperFunctions.getStartOfWeek(DateTime.now());
    final end = start.add(const Duration(days: 7));
    return orderController.allItems
        .where((o) =>
    o.orderDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
        o.orderDate.isBefore(end))
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get monthRevenue {
    final now = DateTime.now();
    return orderController.allItems
        .where((o) =>
    o.orderDate.year == now.year && o.orderDate.month == now.month)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get yearRevenue {
    final now = DateTime.now();
    return orderController.allItems
        .where((o) => o.orderDate.year == now.year)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) => false;

  @override
  Future<void> deleteItem(OrderModel item) async {}
}
