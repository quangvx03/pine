import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import 'customer_detail_table_source.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    return Obx(
      () {
        Text(controller.filteredCustomerOrders.length.toString());
        return PPaginatedDataTable(
          minWidth: 550,
          tableHeight: 640,
          dataRowHeight: kMinInteractiveDimension,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(label: const Text('ID Đơn hàng'), onSort: (columnIndex, ascending) => controller.sortById(columnIndex, ascending)),
            const DataColumn2(label: Text('Ngày')),
            const DataColumn2(label: Text('Sản phẩm')),
            DataColumn2(label: const Text('Trạng thái'),
                fixedWidth: PDeviceUtils.isMobileScreen(context) ? 100 : null),
            const DataColumn2(label: Text('Tổng'), numeric: true),
          ],
          source: CustomerOrdersRows(),
        );
      }
    );
  }
}
