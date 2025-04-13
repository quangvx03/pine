import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:pine_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:pine_admin_panel/features/shop/models/order_model.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';
import 'package:pine_admin_panel/utils/constants/enums.dart';
import 'package:pine_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../../utils/constants/sizes.dart';


class CustomerOrdersRows extends DataTableSource {
  final controller = CustomerDetailController.instance;
  final currencyFormatter = NumberFormat("#,###", "vi_VN"); // Định dạng tiền VND

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredCustomerOrders[index];
    final totalAmount = order.items.fold<double>(0, (previousValue, element) => previousValue + element.price);

    return DataRow2(
        onTap: () => Get.toNamed(PRoutes.orderDetails, arguments: order),
        cells: [
          DataCell(Text(order.id, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: PColors.primary))),
          DataCell(Text(order.formattedOrderDate)),
          DataCell(Text('${order.items.length} Sản phẩm')),
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
          DataCell(Text('${currencyFormatter.format(totalAmount)}đ')), // Sửa lại để hiển thị số tiền có dấu chấm
        ]
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCustomerOrders.length;

  @override
  int get selectedRowCount => 0;
}
