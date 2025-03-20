
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/features/shop/controllers/dashboard_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/sizes.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

class OrderRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    final order = DashboardController.orders[index];
    return DataRow2(
      onTap: () => Get.toNamed(PRoutes.orderDetails, arguments: order),
      selected: false,
      onSelectChanged: (value){},
      cells: [
        DataCell(
          Text(
            order.id,
            style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(Text('${order.items.length} sản phẩm')),
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

        DataCell(Text('${order.totalAmount}đ')),
        DataCell(
          PTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(PRoutes.orderDetails, arguments: order, parameters: {'orderId': order.id}),
            onDeletePressed: (){},
          )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => DashboardController.orders.length;

  @override
  int get selectedRowCount => 0;
}
