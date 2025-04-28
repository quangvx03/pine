import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/user_repository.dart';
import 'package:pine_admin_panel/features/personalization/models/user_model.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/utils/popups/loaders.dart';

import '../../../../data/repositories/address_repository.dart';
import '../../../../utils/formatters/formatter.dart';

class CustomerDetailController extends GetxController {
  static CustomerDetailController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<OrderModel> allCustomerOrders = <OrderModel>[].obs;
  RxList<OrderModel> filteredCustomerOrders = <OrderModel>[].obs;

  Future<void> getCustomerOrders() async {
    try {
      ordersLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        List<OrderModel> fetchedOrders = await UserRepository.instance.fetchUserOrders(customer.value.id!);

        customer.update((val) {val?.orders = fetchedOrders;});
        allCustomerOrders.assignAll(fetchedOrders);
        filteredCustomerOrders.assignAll(fetchedOrders);
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Ôi không!', message: e.toString());
    } finally {
      ordersLoading.value = false;
      update();
    }
  }

  Future<void> getCustomerAddresses() async {
    try {
      addressesLoading.value = true;
      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.addresses =
        await addressRepository.fetchUserAddresses(customer.value.id!);
      }
    } catch (e) {
      PLoaders.errorSnackBar(title: 'Ôi không!', message: e.toString());
    } finally {
      addressesLoading.value = false;
    }
  }

  void searchQuery(String query) {
    filteredCustomerOrders.assignAll(
      allCustomerOrders.where((order) =>
      order.id.toLowerCase().contains(query.toLowerCase()) ||
          order.orderDate.toString().contains(query.toLowerCase())
      ),
    );
    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredCustomerOrders.sort((a, b) {
      if (ascending) {
        return a.id.toLowerCase().compareTo(b.id.toLowerCase());
      } else {
        return b.id.toLowerCase().compareTo(a.id.toLowerCase());
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;
    update();
  }

  String get lastOrderDate {
    if (customer.value.orders != null && customer.value.orders!.isNotEmpty) {
      customer.value.orders!.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      final lastOrder = customer.value.orders!.first;
      return PFormatter.formatDate(lastOrder.orderDate);
    }
    return 'Chưa có đơn hàng';
  }

  String get averageOrderValue {
    if (customer.value.orders != null && customer.value.orders!.isNotEmpty) {
      double totalAmount = customer.value.orders!.fold(0.0, (sum, order) {
        final orderTotal = order.items.fold(0.0, (sum, item) => sum + item.price);
        return sum + orderTotal;
      });

      double average = totalAmount / customer.value.orders!.length;

      return PFormatter.formatCurrencyRange(
          average.toStringAsFixed(0));
    }
    return 'Chưa có đơn hàng';
  }

}
