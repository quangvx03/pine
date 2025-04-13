import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../controllers/order/order_controller.dart';


class OrderRows extends DataTableSource {
  final controller = OrderController.instance;
  final currencyFormatter = NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0);

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredItems[index];
    return DataRow2(
      onTap: () => Get.toNamed(PRoutes.orderDetails, arguments: order),
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
            padding: const EdgeInsets.symmetric(vertical: PSizes.xs, horizontal: PSizes.md),
            backgroundColor: PHelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
            child: Text(
              order.status.name.capitalize.toString(),
              style: TextStyle(color: PHelperFunctions.getOrderStatusColor(order.status)),
            ),
          ),
        ),
        DataCell(Text(currencyFormatter.format(order.totalAmount))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => 0;
}
