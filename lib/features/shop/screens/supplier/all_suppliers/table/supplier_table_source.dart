import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';

import '../../../../controllers/review/review_controller.dart';
import '../../../../controllers/supplier/supplier_controller.dart';

class SupplierRows extends DataTableSource {
  final controller = SupplierController.instance;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  DataRow? getRow(int index) {
    final supplier = controller.filteredItems[index];

    return DataRow2(
      cells: [
        // ID
        DataCell(
          Text(
            supplier.id,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: PColors.primary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Tên nhà cung cấp
        DataCell(Text(supplier.name)),

        // Số điện thoại
        DataCell(Text(supplier.phone)),

        // Tổng tiền
        DataCell(Text(currencyFormat.format(supplier.totalAmount))),

        // Ngày tạo đơn
        DataCell(Text(dateFormat.format(supplier.createdAt))),

        // Actions
        DataCell(
          PTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              PRoutes.supplierDetails,
              arguments: supplier,
            ),
            onDeletePressed: () => controller.confirmAndDeleteItem(supplier),
          ),
        ),
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

