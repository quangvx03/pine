import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../../utils/constants/sizes.dart';


class OrderOrdersRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    final order = OrderModel(id: 'id', status: OrderStatus.shipped, totalAmount: 250.000, orderDate: DateTime.now(), items: [], shippingCost: 15.000);
    const totalAmount = '250,000';
    return DataRow2(
      selected: false,
        onTap: () => Get.toNamed(PRoutes.orderDetails, arguments: order),
        cells: [
          DataCell(Text(order.id, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary))),
          DataCell(Text(order.formattedOrderDate)),
          const DataCell(Text('${5} Sản phẩm')),
          DataCell(
            PRoundedContainer(
              radius: PSizes.cardRadiusSm,
              padding: const EdgeInsets.symmetric(vertical: PSizes.sm, horizontal: PSizes.md),
              backgroundColor: PHelperFunctions.getOrderStatusColor(order.status).withValues(alpha: 0.1),
              child: Text(
                order.status.name.capitalize.toString(),
                style: TextStyle(color: PHelperFunctions.getOrderStatusColor(order.status)),
              ),
            )
          ),
          const DataCell(Text('$totalAmountđ')),
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 5;

  @override
  int get selectedRowCount => 0;
}
