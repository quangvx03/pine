import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../controllers/order/order_controller.dart';
import '../../dashboard/table/dashboard_table_source.dart';


class DashboardOrderTable extends StatelessWidget {
  const DashboardOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;

    return Obx(
      () {
        Text(controller.filteredItems.length.toString());

        return PPaginatedDataTable(
          minWidth: 700,
          tableHeight: 500,
          dataRowHeight: PSizes.xl * 1.2,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(label: const Text('ID Đơn hàng'), onSort: (columnIndex, ascending) => controller.sortById(columnIndex, ascending)),
            const DataColumn2(label: Text('Ngày')),
            const DataColumn2(label: Text('Sản phẩm')),
            DataColumn2(label: const Text('Trạng thái'), fixedWidth: PDeviceUtils.isMobileScreen(context) ? 120 : null),
            const DataColumn2(label: Text('Tổng tiền')),
          ],
          source: OrderRows(),
        );
      }
    );
  }
}
