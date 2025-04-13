import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/brand/all_brands/table/brand_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../controllers/brand/brand_controller.dart';



class BrandTable extends StatelessWidget {
  const BrandTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());

        final lgTable = controller.filteredItems.any((element) => element.brandCategories != null && element.brandCategories!.length > 2);
          return PPaginatedDataTable(
            minWidth: 700,
            tableHeight: lgTable ? 96 * 11.5 : 760,
            dataRowHeight: lgTable ? 96 : 64,
            sortAscending: controller.sortAscending.value,
            sortColumnIndex: controller.sortColumnIndex.value,
            columns: [
              DataColumn2(
                label: const Text('Thương hiệu'),
                fixedWidth: PDeviceUtils.isMobileScreen(Get.context!) ? null : 200,
                onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending)
              ),
              const DataColumn2(label: Text('Danh mục')),
              DataColumn2(label: Text('Nổi bật'), fixedWidth: PDeviceUtils.isMobileScreen(Get.context!) ? null : 100),
              DataColumn2(label: Text('Ngày'), fixedWidth: PDeviceUtils.isMobileScreen(Get.context!) ? null : 200),
              DataColumn2(label: Text('Hành động'), fixedWidth: PDeviceUtils.isMobileScreen(Get.context!) ? null : 100),
            ],
            source: BrandRows(),
          );

        }
    );
  }
}

