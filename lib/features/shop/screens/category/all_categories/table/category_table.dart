import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/table/category_table_source.dart';

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 700,
        columns: const [
          DataColumn2(label: Text('Danh mục')),
          DataColumn2(label: Text('Danh mục cha')),
          DataColumn2(label: Text('Nổi bật')),
          DataColumn2(label: Text('Ngày')),
          DataColumn2(label: Text('Hành động'), fixedWidth: 100),
        ],
        source: CategoryRows(),
    );
  }
}

