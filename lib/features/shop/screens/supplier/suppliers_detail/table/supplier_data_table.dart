import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/supplier/suppliers_detail/table/supplier_detail_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../controllers/supplier/supplier_detail_controller.dart';

class SupplierProductTable extends StatelessWidget {
  const SupplierProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SupplierDetailController.instance;

    return Obx(() {
      return PPaginatedDataTable(
        minWidth: 550,
        tableHeight: 640,
        dataRowHeight: kMinInteractiveDimension,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(
              label: const Text('Tên sản phẩm'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByName(columnIndex, ascending)),
          DataColumn2(label: Text('Số lượng'),
              onSort: (columnIndex, ascending) => controller.sortByQuantity(columnIndex, ascending)),
          const DataColumn2(label: Text('Giá nhập'), numeric: true),
          const DataColumn2(label: Text('Tổng tiền'), numeric: true),
        ],
        source: SupplierProductsRows(controller.filteredSupplierProducts),
      );
    });
  }
}
