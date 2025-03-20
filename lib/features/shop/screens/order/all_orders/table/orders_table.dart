import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:pine_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:pine_admin_panel/features/shop/screens/order/all_orders/table/order_table_source.dart';
import 'package:pine_admin_panel/utils/device/device_utility.dart';

import '../../../../../../utils/constants/sizes.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return PPaginatedDataTable(
      minWidth: 700,
        columns: [
          const DataColumn2(label: Text('ID Đơn hàng')),
          const DataColumn2(label: Text('Ngày')),
          const DataColumn2(label: Text('Sản phẩm')),
          DataColumn2(label: Text('Trạng thái'), fixedWidth: PDeviceUtils.isMobileScreen(context) ? 120 : null),
          const DataColumn2(label: Text('Tổng')),
          const DataColumn2(label: Text('Hành động'), fixedWidth: 100),
        ],
        source: OrderRows(),
    );
  }
}

