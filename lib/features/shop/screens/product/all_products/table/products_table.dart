import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/table/category_table_source.dart';
import 'package:pine_admin_panel/features/shop/screens/product/all_products/table/product_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 1000,
        columns: [
          DataColumn2(label: const Text('Sản phẩm'), fixedWidth: !PDeviceUtils.isDesktopScreen(context) ? 300 : 400),
          const DataColumn2(label: Text('Kho')),
          const DataColumn2(label: Text('Thương hiệu')),
          const DataColumn2(label: Text('Giá')),
          const DataColumn2(label: Text('Ngày')),
          const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
        ],
        source: ProductsRows(),
    );
  }
}

