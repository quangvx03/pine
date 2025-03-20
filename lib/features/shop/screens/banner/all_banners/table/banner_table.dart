import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/banner/all_banners/table/banner_table_source.dart';
import 'package:pine_admin_panel/features/shop/screens/brand/all_brands/table/brand_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class BannersTable extends StatelessWidget {
  const BannersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 700,
      tableHeight: 900,
      dataRowHeight: 110,
      columns: const [
        DataColumn2(label: Text('Banner')),
        DataColumn2(label: Text('Màn hình chuyển hướng')),
        DataColumn2(label: Text('Hoạt động')),
        DataColumn2(label: Text('Hành động'), fixedWidth: 100),
      ],
      source: BannersRows(),
    );
  }
}

