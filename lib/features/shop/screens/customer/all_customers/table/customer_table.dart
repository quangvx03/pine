import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/category/all_categories/table/category_table_source.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/all_customers/table/customer_table_source.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 700,
        columns: const [
          DataColumn2(label: Text('Người dùng')),
          DataColumn2(label: Text('Email')),
          DataColumn2(label: Text('Số điện thoại')),
          DataColumn2(label: Text('Đăng ký')),
          DataColumn2(label: Text('Hành động'), fixedWidth: 100),
        ],
        source: CustomerRows(),
    );
  }
}

