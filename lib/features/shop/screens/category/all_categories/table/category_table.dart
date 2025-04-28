import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/table/category_table_source.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());

        return PPaginatedDataTable(
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          minWidth: 700,
          columns: [
            DataColumn2(label: const Text('Danh mục'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending)),
            DataColumn2(label: const Text('Danh mục cha'),
                onSort: (columnIndex, ascending) =>
                    controller.sortByName(columnIndex, ascending)),
            const DataColumn2(label: Text('Nổi bật')),
            DataColumn2(label: Text('Ngày'), onSort: (columnIndex, ascending) =>
                controller.sortByDate(columnIndex, ascending)),
            const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
          ],
          source: CategoryRows(),
        );
      }
    );
  }
}

