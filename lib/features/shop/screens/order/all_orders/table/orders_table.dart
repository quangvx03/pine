import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/order/all_orders/table/order_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../controllers/order/order_controller.dart';



class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Obx(
          () {
        Text(controller.filteredItems.length.toString());

        return PPaginatedDataTable(
          minWidth: 700,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            const DataColumn2(label: Text('ID Đơn hàng')),
            DataColumn2(label: const Text('Ngày đặt'), onSort: (columnIndex, ascending) => controller.sortByDate(columnIndex, ascending)),
            DataColumn2(label: const Text('Ngày giao'), onSort: (columnIndex, ascending) => controller.sortByDate(columnIndex, ascending)),
            DataColumn2(label: Text('Sản phẩm'), onSort: (columnIndex, ascending) => controller.sortByItemCount(columnIndex, ascending)),
            DataColumn2(label: Text('Trạng thái'),
                fixedWidth: PDeviceUtils.isMobileScreen(context) ? 120 : null),
            const DataColumn2(label: Text('Tổng')),
            const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
          ],
          source: OrderRows(),
        );
      },
    );
  }
}

