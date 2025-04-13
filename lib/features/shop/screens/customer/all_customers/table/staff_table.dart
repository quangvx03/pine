import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/all_customers/table/staff_table_source.dart';

import '../../../../controllers/customer/customer_controller.dart';


class StaffTable extends StatelessWidget {
  const StaffTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return Obx(
            () {
          Text(controller.filteredItems.length.toString());

          return PPaginatedDataTable(
            minWidth: 700,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(label: const Text('Nhân viên'), onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending)),
              const DataColumn2(label: Text('Email')),
              const DataColumn2(label: Text('Số điện thoại')),
              const DataColumn2(label: Text('Đăng ký')),
              const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
            ],
            source: StaffRows(),
          );
        }
    );
  }
}

