import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pine_admin_panel/common/widgets/icons/table_action_icon_buttons.dart';
import 'package:pine_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:pine_admin_panel/routes/routes.dart';
import 'package:pine_admin_panel/utils/constants/colors.dart';

class CouponRows extends DataTableSource {
  final controller = CouponController.instance;
  final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final percentFormat = NumberFormat.percentPattern();

  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length) return null;
    final coupon = controller.filteredItems[index];

    return DataRow2(
      cells: [
        DataCell(
          Row(
            children: [
              Expanded(
                child: Text(
                  coupon.couponCode,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .bodyLarge!
                      .apply(color: PColors.primary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        DataCell(Text(coupon.type)),

        DataCell(
          Text(
            coupon.type == "Cố định"
                ? currencyFormat.format(coupon.discountAmount)
                : "${coupon.discountAmount}%",
          ),
        ),

        DataCell(
          Builder(
            builder: (_) {
              final isExpired = coupon.endDate != null && coupon.endDate!.isBefore(DateTime.now());

              if (isExpired) {
                return const Icon(Icons.star_border_rounded, color: Colors.redAccent);
              }

              return coupon.status
                  ? const Icon(Icons.star_rounded, color: PColors.primary)
                  : const Icon(Icons.star_border_rounded);
            },
          ),
        ),

        DataCell(Text('${coupon.usedCount}')),
        DataCell(Text(coupon.endDate == null ? '' : coupon.formattedEndDate)),
        DataCell(
          PTableActionButtons(
            onEditPressed: () => Get.toNamed(PRoutes.editCoupon, arguments: coupon),
            onDeletePressed: () => controller.confirmAndDeleteItem(coupon),
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
