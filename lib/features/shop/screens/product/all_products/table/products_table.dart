import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:pine_admin_panel/features/shop/screens/product/all_products/table/product_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());

        return PPaginatedDataTable(
          minWidth: 1000,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(
              label: const Text('Sản phẩm'),
              fixedWidth: !PDeviceUtils.isDesktopScreen(context) ? 300 : 400,
              onSort: (columnIndex, ascending) => controller.sortByName(columnIndex, ascending),
            ),
            DataColumn2(
                label: const Text('Kho'),
              onSort: (columnIndex, ascending) => controller.sortByStock(columnIndex, ascending),
            ),
            DataColumn2(
                label: const Text('Đã bán'),
                onSort: (columnIndex, ascending) => controller.sortBySoldItems(columnIndex, ascending)
            ),
            const DataColumn2(label: Text('Thương hiệu')),
            DataColumn2(
                label: const Text('Giá'),
                onSort: (columnIndex, ascending) => controller.sortByPrice(columnIndex, ascending)
            ),
            const DataColumn2(label: Text('Hiển thị')),
            const DataColumn2(label: Text('Ngày')),
            const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
          ],
          source: ProductsRows(),
        );
      }
    );
  }
}

