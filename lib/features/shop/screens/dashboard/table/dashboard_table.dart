import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/dashboard/table/dashboard_table_source.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';

class DashboardOrderTable extends StatelessWidget {
  const DashboardOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 700,
      tableHeight: 500,
      dataRowHeight: PSizes.xl * 1.2,
      columns: const [
        DataColumn2(label: Text('ID Đơn hàng')),
        DataColumn2(label: Text('Ngày')),
        DataColumn2(label: Text('Sản phẩm')),
        DataColumn2(label: Text('Trạng thái')),
        DataColumn2(label: Text('Tổng tiền')),
      ],
      source: OrderRows(),
    );
  }
}
