import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';

import 'coupon_table_source.dart';

class CouponTable extends StatelessWidget {
  const CouponTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());

        return PPaginatedDataTable(
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          minWidth: 700,
          columns: [
            DataColumn2(label: const Text('Mã giảm giá'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending)),
            DataColumn2(label: const Text('Loại')),
            const DataColumn2(label: Text('Giảm')),
            const DataColumn2(label: Text('Trạng thái')),
            const DataColumn2(label: Text('Ngày hết hạn')),
            const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
          ],
          source: CouponRows(),
        );
      }
    );
  }
}

