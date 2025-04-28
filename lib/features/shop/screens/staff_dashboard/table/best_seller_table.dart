import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/staff_dashboard/table/best_seller_table_source.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class BestSellerTable extends StatelessWidget {
  const BestSellerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;

    return Obx(
            () {
          Text(controller.filteredItems.length.toString());

          return PPaginatedDataTable(
            minWidth: 700,
            tableHeight: 500,
            dataRowHeight: PSizes.xl * 2,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(label: const Text('Sản phẩm')),
              DataColumn2(label: const Text('Thương hiệu')),
              const DataColumn2(label: Text('Giá')),
              DataColumn2(label: const Text('Kho'), fixedWidth: PDeviceUtils.isMobileScreen(context) ? 120 : null),
              const DataColumn2(label: Text('Đã bán')),
            ],
            source: BestSellerRows(),
          );
        }
    );
  }
}
