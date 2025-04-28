import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';

import '../../../../controllers/review/review_controller.dart';
import '../../../../controllers/supplier/supplier_controller.dart';
import 'supplier_table_source.dart';

class SupplierTable extends StatelessWidget {
  const SupplierTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupplierController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());

        return PPaginatedDataTable(
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          minWidth: 700,
          columns: [
            DataColumn2(label: const Text('ID')),
            DataColumn2(label: const Text('Nhà cung cấp'), onSort: (columnIndex, ascending) =>
                controller.sortByName(columnIndex, ascending)),
            const DataColumn2(label: Text('Số điện thoại')),
            const DataColumn2(label: Text('Tổng tiền')),
            DataColumn2(label: Text('Ngày nhập'), onSort: (columnIndex, ascending) =>
                controller.sortByDate(columnIndex, ascending)),
            const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
          ],
          source: SupplierRows(),
        );
      }
    );
  }
}

