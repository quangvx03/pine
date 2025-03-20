import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/customer/customer_detail/table/customer_detail_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 550,
        tableHeight: 640,
        dataRowHeight: kMinInteractiveDimension,
        columns: [
          const DataColumn2(label: Text('ID Đơn hàng')),
          const DataColumn2(label: Text('Ngày')),
          const DataColumn2(label: Text('Sản phẩm')),
          DataColumn2(label: Text('Trạng thái'), fixedWidth: PDeviceUtils.isMobileScreen(context) ? 100 : null),
          const DataColumn2(label: Text('Tổng'), numeric: true),
        ],
        source: CustomerOrdersRows(),
    );
  }
}
